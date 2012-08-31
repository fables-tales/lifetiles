require "singleton"
require "twitter"
require "http"
require 'digest/md5'

class ImageManager

  def self.twitter_profile(username)
    url = Twitter.user(username)[:profile_image_url].gsub("_normal", "")
    extension = url[-4..-1]
    filename = "#{Random.rand(1000000000)}#{extension}"

    result = Http.get url

    handle = open("public/images/#{filename}", "wb")
    handle.write(result)
    handle.close()

    return filename
  end

  def self.resize_image(path)
    img = (Magick::Image.read path)[0]
    thumb = img.resize_to_fill(200, 200)
    thumb.write path
  end

  def self.get_md5(path)
    Digest::MD5.hexdigest(File.read(path))
  end

end
