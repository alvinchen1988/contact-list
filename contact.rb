require 'csv'
require 'pg'

# Represents a person in an address book.
# The ContactList class will work with Contact objects instead of interacting with the CSV file directly
class Contact

  attr_accessor :name, :email, :id
  
  # Creates a new contact object
  # @param name [String] The contact's name
  # @param email [String] The contact's email address
  def initialize(name, email)
    # TODO: Assign parameter values to instance variables.
    @name = name
    @email = email
  end

  def persisted?
    !id.nil?
  end

  def save
    if persisted?
      Contact.connection.exec_params("UPDATE contacts SET name = $1, email = $2 WHERE id = $3;", [name, email, id])
    else
      Contact.connection.exec_params("INSERT INTO contacts(name, email) VALUES ($1, $2);", [self.name, self.email])
    end
  end

  def destroy
    Contact.connection.exec_params("DELETE FROM contacts WHERE id = $1::int;", [self.id])
  end

  def inspect
    "Contact: @id=#{id} @name=#{name} @email=#{email}"
  end
  # Contact:0x909a5c0 @name="Tina Ji", @email="tinaji@qq.com", @id="1"

  # Provides functionality for managing contacts in the csv file.
  class << self

    def connection
      conn = PG.connect(
        host: 'localhost',
        dbname: 'contact_list',
        user: 'development',
        password: 'development'
      )
    end

    # Opens 'contacts.csv' and creates a Contact object for each line in the file (aka each contact).
    # @return [Array<Contact>] Array of Contact objects
    def all
      all_contacts = self.connection.exec("SELECT * FROM contacts;")

      all_contacts_in_array = self.connection.exec("SELECT * FROM contacts;").map do |row|
        contact = Contact.new(row['name'], row['email'])
        contact.id = row['id']
        contact
      end 

      all_contacts_in_array

    end

    # Creates a new contact, adding it to the csv file, returning the new contact.
    # @param name [String] the new contact's name
    # @param email [String] the contact's email
    def create(name, email)
      # TODO: Instantiate a Contact, add its data to the 'contacts.csv' file, and return it.
      contact = Contact.new(name, email) 
      contact.save
      contact
    end
    
    # Find the Contact in the 'contacts.csv' file with the matching id.
    # @param id [Integer] the contact id
    # @return [Contact, nil] the contact with the specified id. If no contact has the id, returns nil.
    def find(id)

      # TODO: Find the Contact in the 'contacts.csv' file with the matching id.
      res = self.connection.exec_params("SELECT * FROM contacts WHERE id = $1::int;", [id])
      return nil if res.count == 0
      contact = Contact.new(res[0]['name'], res[0]['email'])
      contact.id = res[0]['id']
      contact
    end
    
    # Search for contacts by either name or email.
    # @param term [String] the name fragment or email fragment to search for
    # @return [Array<Contact>] Array of Contact objects.
    def search(term)

      res = self.connection.exec_params("SELECT * FROM contacts WHERE name ILIKE $1 OR email ILIKE $2", ["%#{term}%", "%#{term}%"])
      return nil if res.count == 0
      res_in_array = res.map do |row|
        contact  = self.new(row['name'], row['email'])
        contact.id = row['id']
        contact
      end
      res_in_array
      # TODO: Select the Contact instances from the 'contacts.csv' file whose name or email attributes contain the search term.
    end



  end

end