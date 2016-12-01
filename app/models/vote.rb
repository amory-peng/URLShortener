class Vote < ActiveRecord::Base
  validates :user_id, :url_id, :vote_value, presence: true
  validate :unique_pair

  def unique_pair
    if Vote.exists?(user_id: user_id, url_id: url_id)
      errors[:already] << "voted on this link"
    end
  end

  belongs_to :user,
    foreign_key: :user_id,
    primary_key: :id,
    class_name: :User

  belongs_to :url,
    foreign_key: :url_id,
    primary_key: :id,
    class_name: :ShortenedUrl

end
