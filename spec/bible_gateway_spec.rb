require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe BibleGateway do
  it 'should have a list of versions' do
    BibleGateway.versions.should_not be_empty
  end
  
  describe 'setting the version' do
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
    it "should find the passage title" do
      stub_get "http://www.biblegateway.com/passage/?search=John%201:1&version=ESV", 'john_1_1.html'
      BibleGateway.new(:english_standard_version).lookup("John 1:1")[:title].should == "John 1:1 (English Standard Version)"
    end
    
    it "should find and clean the passage content" do
      passage = "<h4>John 1</h4>\n<h5>The Word Became Flesh</h5> <sup>1</sup> In the beginning was the Word, and the Word was with God, and the Word was God."
      stub_get "http://www.biblegateway.com/passage/?search=John%201:1&version=ESV", 'john_1_1.html'
      result = BibleGateway.new(:english_standard_version).lookup("John 1:1")[:content]
      result.should include("<h4>John 1</h4>")
      result.should include("<h5>The Word Became Flesh</h5>")
      result.should include("<sup>1</sup>")
      result.should include("In the beginning was the Word, and the Word was with God, and the Word was God.")
      # result.should == passage # there are hidden characters in here that I need to track down
    end
  end
  
end
