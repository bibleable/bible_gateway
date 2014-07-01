# coding: utf-8
require "spec_helper"

describe BibleGateway do
  it "should have a list of versions" do
    BibleGateway.versions.should_not be_empty
  end

  describe "setting the version" do
    it "should have a default version" do
      gateway = BibleGateway.new
      gateway.version.should == :king_james_version
    end

    it "should be able to set the version to use" do
      gateway = BibleGateway.new :english_standard_version
      gateway.version.should == :english_standard_version
    end

    it "should raise an exception for unknown version" do
      lambda { BibleGateway.new :unknown_version }.should raise_error(BibleGatewayError)
    end

    it "should be able to change the version to use" do
      gateway = BibleGateway.new
      gateway.version = :english_standard_version
      gateway.version.should == :english_standard_version
    end

    it "should raise an exception when changing to unknown version" do
      gateway = BibleGateway.new
      lambda {  gateway.version = :unknown_version }.should raise_error(BibleGatewayError)
    end
  end

  describe "lookup" do
    context "verse" do
      it "should find the passage title" do
        title = BibleGateway.new(:english_standard_version).lookup("John 1:1")[:title]
        title.should == "John 1:1"
      end

      it "should find and clean the passage content" do
        content = BibleGateway.new(:english_standard_version).lookup("John 1:1")[:content]
        content.should include("<h3>The Word Became Flesh</h3>")
        content.should include("In the beginning was the Word, and the Word was with God, and the Word was God.")
      end
    end

    context "chapter" do
      it "should find the passage title" do
        title = BibleGateway.new(:english_standard_version).lookup("John 3")[:title]
        title.should == "John 3"
      end

      it "should find and clean the passage content" do
        content = BibleGateway.new(:english_standard_version).lookup("John 3")[:content]
        content.should include("<h3>You Must Be Born Again</h3>")
        content.should include("<h3>For God So Loved the World</h3>")
        content.should include("For God so loved the world,that he gave his only Son, that whoever believes in him should not perish but have eternal life.")
      end
    end

    context "multiple chapters" do
      it "should find the passage title" do
        title = BibleGateway.new(:english_standard_version).lookup("Psalm 1-5")[:title]
        title.should == "Psalm 1-5"
      end

      it "should find and clean the passage content" do
        content = BibleGateway.new(:english_standard_version).lookup("Psalm 1-5")[:content]
        content.should include("<h3>The Way of the Righteous and the Wicked</h3>")
        content.should include("<span class=\"chapternum\">1 </span>")
        content.should include("<h3>Save Me, O My God</h3>")
        content.should include("<span class=\"chapternum\">1 </span>")
        content.should include("For you are not a God who delights in wickedness;")
      end
    end
  end

end
