require "images"
require "RMagick"

describe ImageManager do
  describe ImageManager, "#twitter_profile" do
    subject do
      name = ImageManager.twitter_profile("fnzcuvccra")
      "public/images/#{name}"
    end

    it "creates the user's profile image" do
      File.exists?(subject).should == true
    end

    it "creates an image with more than one byte" do
      open(subject, "rb").read().length.should > 0
    end

    after(:each) do
      File.delete(subject)
    end
  end


  describe ImageManager, "#resize_image" do
    before(:all) do
      @name = ImageManager.twitter_profile("fnzcuvccra")
    end

    subject do
      path = "public/images/#{@name}"
      ImageManager.resize_image(path)
      path
    end

    it "resizes the image to 200x200" do
      img = (Magick::Image.read subject)[0]
      img.bounding_box.width.should == 200
      img.bounding_box.height.should == 200
    end

    after(:all) do
      File.delete(subject)
    end
  end
end
