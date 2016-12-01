class Tagging < ActiveRecord::Base
  validates :url_id, :tag_id, presence: true

  belongs_to :url,
    foreign_key: :url_id,
    primary_key: :id,
    class_name: :ShortenedUrl

  belongs_to :tag,
    foreign_key: :tag_id,
    primary_key: :id,
    class_name: :TagTopic
end
