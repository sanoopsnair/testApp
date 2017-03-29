class Event < ActiveRecord::Base

  # Constants
  PUBLISHED = "published"
  UNPUBLISHED = "unpublished"
  REMOVED = "removed"
  ARCHIVED = "archived"
  STATUS_HASH = {"Published" => PUBLISHED, "Unpublished" => UNPUBLISHED, "Archived" => ARCHIVED, "Removed" => REMOVED}
  STATUS_HASH_REVERSE = {PUBLISHED => "Published", UNPUBLISHED => "Unpublished", ARCHIVED => "Archived", REMOVED => "Removed"}

  FEATURED_HASH = {"Featured" => true, "Non Featured" => false}
  FEATURED_HASH_REVERSE = {true => "Featured", false => "Non Featured"}

  TYPE_HASH = {"News" => true, "Events" => false}
  TYPE_HASH_REVERSE = {true => "News", false => "Events"}

  EXCLUDED_JSON_ATTRIBUTES = [:created_at, :updated_at]

  # Callbacks
  before_validation :make_permalink, if: Proc.new { self.permalink.blank? }, on: :create
  after_create :update_permalink, if: Proc.new { self.permalink.blank? }

  # Validations
  extend PoodleValidators
  validates :title, presence: true
  validates :permalink, presence: true, uniqueness: true
  validates :description1, presence: true
  
  validates :status, :presence=> true, :inclusion => {:in => STATUS_HASH_REVERSE.keys, :presence_of => :status, :message => "%{value} is not a valid status" }

  # Associations
  has_one :cover_image, :as => :imageable, :dependent => :destroy, :class_name => "Image::EventCoverImage"
  has_one :gallery_images, :as => :imageable, :dependent => :destroy, :class_name => "Image::EventGalleryImage"

  # ------------------
  # Class Methods
  # ------------------

  # return an published record relation object with the search query in its where clause
  # Return the ActiveRecord::Relation object
  # == Examples
  #   >>> user.search(query)
  #   => ActiveRecord::Relation object
  scope :search, lambda { |query| where("LOWER(title) LIKE LOWER('%#{query}%') OR\
                                        LOWER(venue) LIKE LOWER('%#{query}%') OR\
                                        LOWER(description1) LIKE LOWER('%#{query}%') OR\
                                        LOWER(description2) LIKE LOWER('%#{query}%') OR\
                                        LOWER(description3) LIKE LOWER('%#{query}%')")
                        }

  scope :status, lambda { |status| where("LOWER(status)='#{status}'") }
  scope :featured, lambda { |val| where(featured: val) }
  scope :filter_by_type, lambda { |val| where(news: val) }

  scope :published, -> { where(status: PUBLISHED) }
  scope :unpublished, -> { where(status: UNPUBLISHED) }
  scope :removed, -> { where(status: REMOVED) }
  scope :archived, -> { where(status: ARCHIVED) }

  scope :upcoming, lambda { where("starts_at >= ?", Time.now) }
  scope :past, lambda { where("starts_at < ?", Time.now) }
  
  # ------------------
  # Instance variables
  # ------------------

  # Exclude some attributes info from json output.
  def as_json(options={})
    #options[:include] = []
    options[:except] = EXCLUDED_JSON_ATTRIBUTES

    super(options)
  end

  # * Return true if the event is published, else false.
  # == Examples
  #   >>> event.published?
  #   => true
  def published?
    (status == PUBLISHED)
  end

  # change the status to :published
  # Return the status
  # == Examples
  #   >>> event.publish!
  #   => "published"
  def publish!
    self.update_attribute(:status, PUBLISHED)
  end

  # * Return true if the event is unpublished, else false.
  # == Examples
  #   >>> event.unpublished?
  #   => true
  def unpublished?
    (status == UNPUBLISHED)
  end

  # change the status to :unpublished
  # Return the status
  # == Examples
  #   >>> event.unpublish!
  #   => "unpublished"
  def unpublish!
    self.update_attributes(status: UNPUBLISHED, featured: false)
  end

  # * Return true if the event is removed, else false.
  # == Examples
  #   >>> event.removed?
  #   => true
  def removed?
    (status == REMOVED)
  end

  # change the status to :removed
  # Return the status
  # == Examples
  #   >>> event.remove!
  #   => "removed"
  def remove!
    self.update_attributes(status: REMOVED, featured: false)
  end

  # * Return true if the event is archived, else false.
  # == Examples
  #   >>> event.archived?
  #   => true
  def archived?
    (status == ARCHIVED)
  end

  # change the status to :archived
  # Return the status
  # == Examples
  #   >>> event.archive!
  #   => "archived"
  def archive!
    self.update_attributes(status: ARCHIVED, featured: false)
  end

  def default_image_url(size="medium")
    "/assets/defaults/event-#{size}.png"
  end

  private

  def make_permalink
    self.permalink = "#{id}-#{title.parameterize}"
  end

  def update_permalink
    update_attribute :permalink, "#{id}-#{title.parameterize}"
  end
  
end
