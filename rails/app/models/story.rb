class Story < ActiveRecord::Base  
  before_create :generate_permalink

  belongs_to :author
  
  SIZE       = 30
  MIN_LENGTH = 4
  MAX_LENGTH = 40
  RANGE = MIN_LENGTH..MAX_LENGTH
  
#  validates_presence_of :title, :headline, :subhead, :text  

  def to_param
    "#{id}-#{title.gsub( /\W/, '-').downcase}"
  end

  protected
    #Strip out any special characters and replace them with a healthy hyphen
    def generate_permalink
      self.permalink = to_param
    end
  
end
