require "spec_helper"
require "twitter_images.rb"



describe TwitterTileGenerator do
  describe TwitterTileGenerator, "#tile_from_tweet" do
    def file_md5(path)
      Digest::MD5.hexdigest(File.read(path))
    end

    SHARED_MESSAGES = {
                        :text => "test tweet",
                        :[] => [:created_at => DateTime.now]
                      }

    def build_messages(messages)
      SHARED_MESSAGES.merge(messages)
    end

    # setup stuff
    let (:media) do
      media_messages = {
        :attrs => {:media_url => "http://samphippen.com/back.png"}
      }

      stub(:media, media_messages)
    end

    let (:geo) do
      geo_messages = {
        :coordinates => [51, -1]
      }

      stub(:geo, geo_messages)
    end

    subject do
      TwitterTileGenerator.tile_from_tweet(target)
      Tile.all
    end

    let (:tile) { subject.first }

    #shared examples for both tweets with geo information and without it
    shared_examples_for "a tile from a tweet" do
      it "only creates one tile" do
        subject.length.should == 1
      end

      it "should create a tile with the right description" do
        tile.description.should == target.text
      end

      it "should create a tile with a 200x200 image" do
        path = "public/#{tile.image}"
        img = (Magick::Image.read path)[0]
        img.columns.should == 200
        img.rows.should == 200
      end

      it "should have the right md5" do
        path = "public/#{tile.image}"
        tile.image_md5.should == file_md5(path)
      end
    end

    # examples for tweets with no media or geo information
    context "tweet with no media or geo" do
      let (:target) do
        messages = SHARED_MESSAGES.clone
        messages[:has_media?] = false

        stub(:target, messages)
      end

      it "should not create a tile" do
        subject.empty?.should == true
      end

    end

    # examples for tweets with media but no geo information
    context "no geo" do
      let (:target) do
        messages = SHARED_MESSAGES.clone
        messages[:geo] = nil
        messages[:has_media?] = true
        messages[:media] = [media]

        stub(:target, messages)
      end

      it_should_behave_like "a tile from a tweet"

      it "should have nil geo information" do
        [tile.lat, tile.long].should == [nil, nil]
      end

    end

    # examples for a tweet with all the information
    context "full tweet" do
      let (:target) do
        messages = build_messages ({
                        :geo => geo,
                        :has_media? => true,
                        :media => [media]
                       })
        stub(:target, messages)
      end

      it_should_behave_like "a tile from a tweet"

      it "should have the right location" do
        [tile.lat, tile.long].should  == geo.coordinates
      end
    end
  end
end
