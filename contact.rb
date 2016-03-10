require 'csv'

# Represents a person in an address book.
# The ContactList class will work with Contact objects instead of interacting with the CSV file directly
class Contact

  @@contact_content = CSV.read('seed.csv')

  # @@contact_contents_hash = 
  # [[1,"alvin","alin@icloud.com"], [1,"tina", "tina@hotmail.com"]]

  attr_accessor :name, :email
  
  # Creates a new contact object
  # @param name [String] The contact's name
  # @param email [String] The contact's email address
  def initialize(name, email)
    # TODO: Assign parameter values to instance variables.
    @name = name
    @email = email
  end



  # Provides functionality for managing contacts in the csv file.
  class << self

    def convert_csv_to_array_hash
      contacts = []
        @@contact_content.each do |inner_array|
          contact = { id: inner_array[0],name: inner_array[1], email: inner_array[2]}
          contacts << contact
        end
      contacts
    end

    # Opens 'contacts.csv' and creates a Contact object for each line in the file (aka each contact).
    # @return [Array<Contact>] Array of Contact objects
    def all
      self.convert_csv_to_array_hash
    end

    # Creates a new contact, adding it to the csv file, returning the new contact.
    # @param name [String] the new contact's name
    # @param email [String] the contact's email
    def create(name, email)
      # TODO: Instantiate a Contact, add its data to the 'contacts.csv' file, and return it.
      contact = Contact.new(name, email)
      if @@contact_content.empty?
        id = 1
      else
        id = @@contact_content.last.first.to_i + 1
      end

      contacts = self.convert_csv_to_array_hash

      contacts.each do |contact|
        return false if contact[:email] == email
      end

      contact_array = []

      contact_array << id
      contact_array << contact.name
      contact_array << contact.email

      CSV.open('seed.csv', 'ab') do |csv_object|
        csv_object << contact_array
      end
      contact = {name: contact.name, id: id}
    end
    
    # Find the Contact in the 'contacts.csv' file with the matching id.
    # @param id [Integer] the contact id
    # @return [Contact, nil] the contact with the specified id. If no contact has the id, returns nil.
    def find(id)
      # TODO: Find the Contact in the 'contacts.csv' file with the matching id.
      id = id - 1
      contact = @@contact_content[id]
    end
    
    # Search for contacts by either name or email.
    # @param term [String] the name fragment or email fragment to search for
    # @return [Array<Contact>] Array of Contact objects.
    def search(term)

      term = term.downcase
      contacts = self.convert_csv_to_array_hash

      fillter_contacts = contacts.select do |contact|
        contact[:name].downcase.include?(term) or contact[:email].downcase.include?(term)
      end

      # TODO: Select the Contact instances from the 'contacts.csv' file whose name or email attributes contain the search term.
    end



  end

end