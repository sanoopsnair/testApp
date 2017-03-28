class Enquiry < ActiveRecord::Base

  # Constants
  UNREAD = "unread"
  READ = "read"
  ARCHIVED = "archived"
  REMOVED = "removed"

  STATUS_HASH = {"Read" => READ, "Unread" => UNREAD, "Archived" => ARCHIVED, "Removed" => REMOVED}
  STATUS_HASH_REVERSE = {READ => "Read", UNREAD => "Unread", ARCHIVED => "Archived", REMOVED => "Removed"}

  EXCLUDED_JSON_ATTRIBUTES = [:created_at, :updated_at]

  # Validations
  extend PoodleValidators
  validate_string :name, mandatory: true
  
  validates :email, :presence=> false
  validates :phone, :presence=> false
  validates :subject, :presence=> false
  validates :message, :presence=> false
  
  validates :status, :presence=> true, :inclusion => {:in => STATUS_HASH_REVERSE.keys, :presence_of => :status, :message => "%{value} is not a valid status" }

  # ------------------
  # Class Methods
  # ------------------

  # return an active record relation object with the search query in its where clause
  # Return the ActiveRecord::Relation object
  # == Examples
  #   >>> user.search(query)
  #   => ActiveRecord::Relation object
  scope :search, lambda {|query| where("LOWER(name) LIKE LOWER('%#{query}%') OR\
                                        LOWER(email) LIKE LOWER('%#{query}%') OR\
                                        LOWER(phone) LIKE LOWER('%#{query}%') OR\
                                        LOWER(subject) LIKE LOWER('%#{query}%') OR\
                                        LOWER(message) LIKE LOWER('%#{query}%')")
                        }

  scope :status, lambda { |status| where("LOWER(status)='#{status}'") }
  
  scope :unread, -> { where(status: UNREAD) }
  scope :read, -> { where(status: READ) }
  scope :archived, -> { where(status: ARCHIVED) }
  scope :removed, -> { where(status: REMOVED) }
  
  # ------------------
  # Instance variables
  # ------------------

  # Exclude some attributes info from json output.
  def as_json(options={})
    #options[:include] = []
    options[:except] = EXCLUDED_JSON_ATTRIBUTES

    super(options)
  end

  def display_name
    "#{self.subject}, #{self.name}"
  end

  # * Return true if the enquiry is read, else false.
  # == Examples
  #   >>> enquiry.read?
  #   => true
  def read?
    (status == READ)
  end

  # change the status to :read
  # Return the status
  # == Examples
  #   >>> enquiry.read!
  #   => "read"
  def read!
    self.update_attribute(:status, READ)
  end

  # * Return true if the enquiry is unread, else false.
  # == Examples
  #   >>> enquiry.unread?
  #   => true
  def unread?
    (status == UNREAD)
  end

  # change the status to :unread
  # Return the status
  # == Examples
  #   >>> enquiry.unread!
  #   => "unread"
  def unread!
    self.update_attribute(:status, UNREAD)
  end

  # * Return true if the enquiry is archived, else false.
  # == Examples
  #   >>> enquiry.archived?
  #   => true
  def archived?
    (status == ARCHIVED)
  end

  # change the status to :archived
  # Return the status
  # == Examples
  #   >>> enquiry.archived!
  #   => "archived"
  def archived!
    self.update_attribute(:status, ARCHIVED)
  end

  # * Return true if the enquiry is removed, else false.
  # == Examples
  #   >>> enquiry.removed?
  #   => true
  def removed?
    (status == REMOVED)
  end

  # change the status to :removed
  # Return the status
  # == Examples
  #   >>> enquiry.remove!
  #   => "removed"
  def remove!
    self.update_attribute(:status, REMOVED)
  end
  
end
