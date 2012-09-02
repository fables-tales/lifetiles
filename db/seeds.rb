# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#

require "images"
require "twitter_images"

puts "deleting all tiles!"
Tile.delete_all

path = ImageManager.twitter_profile("@fnzcuvccra")
ImageManager.resize_image("public/images/#{path}")
md5 = ImageManager.get_md5("public/images/#{path}")


if Tile.where("image_md5 = ?", md5).length == 0
  tile = Tile.manufacture "Twitter Profile Picture", "images/#{path}"
  tile.lat = 50.991259
  tile.long = -1.494362
  tile.save
end

TwitterTileGenerator.make_tiles("fnzcuvccra")

puts "created some tiles: #{Tile.all.length}"
