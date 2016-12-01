# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

users = User.create([{ email: 'a@b.com'}])

ShortenedUrl.create_for_user_and_long_url(users.first, 'www.nba.com')

tags = TagTopic.create([{ tag: 'basketball' }])

taggings = Tagging.create([{ tag_id: 1, url_id: 1 }])
