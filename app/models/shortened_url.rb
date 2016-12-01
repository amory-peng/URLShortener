class ShortenedUrl < ActiveRecord::Base
  include SecureRandom

  validates :user_id, :long_url, presence: true
  validates :short_url, uniqueness: true
  validate :valid_url_length, :too_many_submissions

  def valid_url_length
    if long_url.length > 1024
      errors[:url] << "is too long"
    end
  end

  def too_many_submissions
    if self.class.where("user_id = #{user_id} AND created_at <= '#{1.minute.ago}'").count > 5
      return if User.find(user_id).premium
      errors[:submissions] << ": you have too many"
    end
  end

  belongs_to :submitter,
    foreign_key: :user_id,
    primary_key: :id,
    class_name: :User

  has_many :visits,
  foreign_key: :shortened_url_id,
  primary_key: :id,
  class_name: :Visit

  has_many :visitors,
  -> { distinct },
  through: :visits,
  source: :visitors

  has_many :taggings,
    foreign_key: :url_id,
    primary_key: :id,
    class_name: :Tagging

  has_many :tags,
    through: :taggings,
    source: :tag

  has_many :votes,
    foreign_key: :url_id,
    primary_key: :id,
    class_name: :Vote

  has_many :voters,
    -> { distinct },
    through: :votes,
    source: :user

  def self.random_code
    random = SecureRandom.urlsafe_base64
    while ShortenedUrl.exists?(short_url: random)
      random = SecureRandom.urlsafe_base64
    end
    random
  end

  def self.create_for_user_and_long_url(user, long_url, custom_url = nil)
    short_url = User.find(user.id).premium ? custom_url : ShortenedUrl.random_code
    ShortenedUrl.create!(user_id: user.id,
                    long_url: long_url,
                    short_url: short_url)
  end

  def num_clicks
    self.select(:user_id).count
  end

  def num_uniques
    self.select(:user_id).count
  end

  def num_recent_uniques
    self.select(:user_id).where("visits.created_at <= '#{10.minutes.ago}'").count
  end

  def self.popular_links(tag)
    self.joins(:tags, :visits).select(:short_url).where("tag_topics.tag = '#{tag}'").group(:short_url).order('COUNT(visits.*) DESC').limit(10)
  end

  def self.top
    self.joins(:votes).select(:short_url).group(:short_url).order('SUM(votes.vote_value) DESC').limit(10)
  end

  def self.hot
    self.joins(:votes).select(:short_url).where("visits.created_at <= '#{10.minutes.ago}'").group(:short_url).order('SUM(votes.vote_value) DESC').limit(10)
  end

  def self.prune(n)
    self.joins(:visits).where("visits.updated_at > '#{n.minutes.ago}'").delete_all
  end
end
