require 'active_record'
require 'active_support'
# Represents a person in an address book.
# The ContactList class will work with Contact objects instead of interacting with the CSV file directly

module AppConfig

  def self.establish_connection
    puts "Connecting to database...1 moment'"
      ActiveRecord::Base.establish_connection(
        :adapter  => "postgresql",
        :host     => "localhost",
        :username => "development",
        :password => "development",
        :database => "contact_list"
      )
  end

end

class Contact < ActiveRecord::Base

end

