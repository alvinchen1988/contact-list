require_relative 'contact'

# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList
  attr_accessor :user_input, :first_param, :second_param, :param_length

  def initialize
    @user_input = ARGV
    @first_param = @user_input[0]
    @second_param = @user_input[1]
    @param_length = @user_input.length
  end

  def welcome_screen
    output = "Here is a list of available commands for browsing through your contact book: \n"
    output += "     new      - Create a new contact\n"
    output += "     list     - List all contacts\n"
    output += "     show     - Show a contact\n"
    output += "     search   - Search contacts"
  end

  def index
    contacts = Contact.all
    # return "The Contact book is empty" if contacts.empty?
    contact_output = ""
    num_of_records = contacts.length
    contacts.each do |contact|
      contact_output += "#{contact.id}: #{contact.name} (#{contact.email})\n"
    end
      contact_output += "---\n#{num_of_records} records total"
  end

  def new_contact(name, email)
    contact= Contact.create(name,email)
    puts contact ? "#{contact.name} is succesfully added to the contact list" : "#{email} already exist in your contact book" 
  end

  def find_contact(id)
    contact = Contact.find(id)
    # puts 1
    puts contact.nil? ? "record with id:#{id} not found" : "id: #{contact.id}\nname: #{contact.name}\nemail: #{contact.email}"
  end

  def search_contact(term)
    filtered_contacts = Contact.search(term)
    return puts "Not found" if filtered_contacts.nil?

    filtered_contacts.each do |contact|
      puts "#{contact.id} #{contact.name} (#{contact.email})"
    end

    puts "------\n#{filtered_contacts.length} records found"

  end

  def update_contact(id, name, email)
    the_contact = Contact.find(id)
    the_contact.name = name
    the_contact.email = email
    the_contact.save
  end

  def delete_contact(id)
    the_contact = Contact.find(id)
    the_contact.destroy
  end

end

contact_list = ContactList.new

if contact_list.param_length == 0
  puts contact_list.welcome_screen
end

case contact_list.first_param

  when "list" 
    contacts = contact_list.index.split("\n")
    contacts_rows_displayed = contacts.length
    begin
      puts "Press enter key to see the next 5 contacts" if contacts_rows_displayed > 5
      total_record_string = contacts.pop
      pagination = contacts.shift(5)
      pagination = pagination.join("\n").chomp("\n")
      print pagination
      contacts_rows_displayed -= 5
    end
    while(contacts_rows_displayed > 0)
      user_input = STDIN.gets.chomp
      if user_input == ""
        pagination = contacts.shift(5)
        pagination = pagination.join("\n").chomp("\n")
        print pagination
        contacts_rows_displayed -= 5
      end
      # puts "hello"
    end
    puts "\n#{total_record_string}"

  when "new"
    print "Enter the name of the new contact: "
    name = STDIN.gets.chomp
    print "Enter the email of the new contact: "
    email = STDIN.gets.chomp
    contact_list.new_contact(name, email)


  when "show" 
    if contact_id = contact_list.second_param
      contact_id = contact_id.to_i
      contact_list.find_contact(contact_id)
    else
      puts "missing user id as the second argument of show"
    end

  when "search"
    if contact_term = contact_list.second_param
      contact_list.search_contact(contact_term)
    else
      puts "missing search keyword as the second argument of search"
    end

  when "update"
    if contact_id = contact_list.second_param
      print "Enter the new name of the contact: "
      contact_name = STDIN.gets.chomp
      print "Enter the new email of the contact: "
      contact_email = STDIN.gets.chomp
      contact_list.update_contact(contact_id, contact_name , contact_email)
      puts "id: #{contact_id} has been updated"
    else
      puts "missing user id as the second argument of update"
    end  

  when "destroy"
    if contact_id = contact_list.second_param
      contact_list.delete_contact(contact_id)
    else
      puts "missing user id as the second argument of destroy"
    end
end
