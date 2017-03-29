class Team < ActiveRecord::Base

  # Contants
  PUBLISHED = "published"
  UNPUBLISHED = "unpublished"
  REMOVED = "removed"
  STATUS_LIST = [PUBLISHED, UNPUBLISHED, REMOVED]

  EXCLUDED_JSON_ATTRIBUTES = [:created_at, :updated_at]

  # Validations
  extend PoodleValidators
  validate_string :name, mandatory: true
  
  validates :designation, :presence=> false
  
  validates :status, :presence=> true, :inclusion => {:in => STATUS_LIST, :presence_of => :status, :message => "%{value} is not a valid status" }

  # Associations
  has_one :team_image, :as => :imageable, :dependent => :destroy, :class_name => "Image::TeamImage"

  # ------------------
  # Class Methods
  # ------------------

  # return an published record relation object with the search query in its where clause
  # Return the ActiveRecord::Relation object
  # == Examples
  #   >>> user.search(query)
  #   => ActiveRecord::Relation object
  scope :search, lambda { |query| where("LOWER(name) LIKE LOWER('%#{query}%') OR\
                                        LOWER(designation) LIKE LOWER('%#{query}%') OR\
                                        LOWER(description) LIKE LOWER('%#{query}%')")
                        }

  scope :status, lambda { |status| where("LOWER(status)='#{status}'") }
  
  scope :unpublished, -> { where(status: UNPUBLISHED) }
  scope :published, -> { where(status: PUBLISHED) }
  
  # ------------------
  # Instance variables
  # ------------------

  # * Return true if the team is published, else false.
  # == Examples
  #   >>> team.published?
  #   => true
  def published?
    (status == PUBLISHED)
  end

  # change the status to :published
  # Return the status
  # == Examples
  #   >>> team.publish!
  #   => "published"
  def publish!
    self.update_attribute(:status, PUBLISHED)
  end

  # * Return true if the team is unpublished, else false.
  # == Examples
  #   >>> team.unpublished?
  #   => true
  def unpublished?
    (status == UNPUBLISHED)
  end

  # change the status to :unpublished
  # Return the status
  # == Examples
  #   >>> team.unpublish!
  #   => "unpublished"
  def unpublish!
    self.update_attribute(:status, UNPUBLISHED)
  end

  # * Return true if the team is removed, else false.
  # == Examples
  #   >>> team.removed?
  #   => true
  def removed?
    (status == REMOVED)
  end

  # change the status to :removed
  # Return the status
  # == Examples
  #   >>> product.remove!
  #   => "removed"
  def remove!
    self.update_attribute(:status, REMOVED)
  end

  # Exclude some attributes info from json output.
  def as_json(options={})
    #options[:include] = []
    options[:except] = EXCLUDED_JSON_ATTRIBUTES

    super(options)
  end

  def default_image_url(size="medium")
    "/assets/defaults/team-#{size}.png"
  end
  
end
