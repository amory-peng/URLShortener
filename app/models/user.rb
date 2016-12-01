class User < ActiveRecord::Base
  validates :email, uniqueness: true, presence: true


  has_many :submitted_urls,
    foreign_key: :user_id,
    primary_key: :id,
    class_name: :ShortenedUrl

  has_many :visits,
  foreign_key: :user_id,
  primary_key: :id,
  class_name: :Visit

  has_many :visited_urls,
  -> { distinct },
  through: :visits,
  source: :visited_urls

  has_many :votes,
    foreign_key: :user_id,
    primary_key: :id,
    class_name: :Vote

  has_many :voted_links,
    -> { distinct },
    through: :votes,
    source: :url
end
