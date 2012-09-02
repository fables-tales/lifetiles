require "twitter_images"
require "spec_helper"

describe TwitterTileGenerator do
  describe TwitterTileGenerator, "#tile_from_tweet" do

    let (:media) do
      media_messages = {
        :attrs => {:media_url => "http://samphippen.com/back.png"}
      }

      stub(:media, media_messages)
    end
    let (:target) do
      messages = {
        :media => [media],
        :text  => "test text",
        :[] => [:created_at => DateTime.now]
      }
      stub(:target, messages)
    end

    subject do
      TwitterTileGenerator.tile_from_tweet(target)
      Tile.all
    end

    it "only creates one tile" do
      subject.length.should == 1
    end

    it "should create a tile with the right description" do
      subject.first.description.should == target.text
    end

    it "should create a tile with a 200x200 image" do
      path = "public/#{subject.first.image}"
      (Magick::Image.read path)[0].columns.should == 200
      (Magick::Image.read path)[0].rows.should == 200
    end

    it "should have the right md5" do
      path = "public/#{subject.first.image}"
      subject.first.image_md5.should == Digest::MD5.hexdigest(File.read(path))
    end
  end
end
