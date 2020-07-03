# coding: utf-8
require "spec_helper"
require 'net/ping'

describe BibleGateway do
  it "should have a list of versions" do
    expect(BibleGateway.versions).not_to be_empty
  end

  describe "setting the version" do
    it "should have a default version" do
      gateway = BibleGateway.new
      expect(gateway.version).to eq(:king_james_version)
    end

    it "should be able to set the version to use" do
      gateway = BibleGateway.new :english_standard_version
      expect(gateway.version).to eq(:english_standard_version)
    end

    it "should raise an exception for unknown version" do
      expect { BibleGateway.new :unknown_version }.to raise_error(BibleGatewayError)
    end

    it "should be able to change the version to use" do
      gateway = BibleGateway.new
      gateway.version = :english_standard_version
      expect(gateway.version).to eq(:english_standard_version)
    end

    it "should raise an exception when changing to unknown version" do
      gateway = BibleGateway.new
      expect {  gateway.version = :unknown_version }.to raise_error(BibleGatewayError)
    end
  end

  describe "reachability" do
    context "biblegateway.com" do
      it "should reach biblegateway.com" do
        check = Net::Ping::External.new(BibleGateway::GATEWAY_URL)
        check.ping?  
      end
    end

    context "classic biblegateway.com" do
      it "should reach classic biblegateway.com" do
        check = Net::Ping::External.new(BibleGateway::CLASSIC_GATEWAY_URL)
        check.ping?  
      end
    end
  end

  describe "lookup" do
    context "text only" do 
      it "should find the scripture text" do
        text = BibleGateway.new(:english_standard_version).lookup("John 1:1")[:text]
        expect(text).to eq("The Word Became Flesh1 In the beginning was the Word, and the Word was with God, and the Word was God.")
      end

      it "should find the scripture text via old_lookup" do
        text = BibleGateway.new(:english_standard_version).old_lookup("John 1:1")[:text]
        expect(text).to eq("The Word Became Flesh1 In the beginning was the Word, and the Word was with God, and the Word was God.")
      end
    end

    context "verse" do
      it "should find the passage title" do
        title = BibleGateway.new(:english_standard_version).lookup("John 1:1")[:title]
        expect(title).to eq("John 1:1")
      end

      it "should find and clean the passage content" do
        content = BibleGateway.new(:english_standard_version).lookup("John 1:1")[:content]
        expect(content).to include("<h3>The Word Became Flesh</h3>")
        expect(content).to include("In the beginning was the Word, and the Word was with God, and the Word was God.")
      end

      it "should find the passage title via old_lookup" do
        title = BibleGateway.new(:english_standard_version).old_lookup("John 1:1")[:title]
        expect(title).to eq("John 1:1")
      end

      it "should find and clean the passage content via old_lookup" do
        content = BibleGateway.new(:english_standard_version).old_lookup("John 1:1")[:content]
        expect(content).to include("<h3>The Word Became Flesh</h3>")
        expect(content).to include("In the beginning was the Word, and the Word was with God, and the Word was God.")
      end
    end

    context "chapter" do
      it "should find the passage title" do
        title = BibleGateway.new(:english_standard_version).lookup("John 3")[:title]
        expect(title).to eq("John 3")
      end

      it "should find and clean the passage content" do
        content = BibleGateway.new(:english_standard_version).lookup("John 3")[:content]
        expect(content).to include("<h3>You Must Be Born Again</h3>")
        expect(content).to include("<h3>For God So Loved the World</h3>")
        expect(content).to include("For God so loved the world, that he gave his only Son, that whoever believes in him should not perish but have eternal life.")
      end

      it "should find the passage title via old_lookup" do
        title = BibleGateway.new(:english_standard_version).old_lookup("John 3")[:title]
        expect(title).to eq("John 3")
      end

      it "should find and clean the passage content via old_lookup" do
        content = BibleGateway.new(:english_standard_version).old_lookup("John 3")[:content]
        expect(content).to include("<h3>You Must Be Born Again</h3>")
        expect(content).to include("<h3>For God So Loved the World</h3>")
        expect(content).to include("For God so loved the world, that he gave his only Son, that whoever believes in him should not perish but have eternal life.")
      end
    end

    context "multiple chapters" do
      it "should find the passage title" do
        title = BibleGateway.new(:english_standard_version).lookup("Psalm 1-5")[:title]
        expect(title).to eq("Psalm 1-5")
      end

      it "should find and clean the passage content" do
        content = BibleGateway.new(:english_standard_version).lookup("Psalm 1-5")[:content]
        expect(content).to include("<h3>The Way of the Righteous and the Wicked</h3>")
        expect(content).to include("<span class=\"chapternum\">1 </span>")
        expect(content).to include("<h3>Save Me, O My God</h3>")
        expect(content).to include("<span class=\"chapternum\">1 </span>")
        expect(content).to include("For you are not a God who delights in wickedness;")
      end

      it "should find the passage title via old_lookup" do
          title = BibleGateway.new(:english_standard_version).old_lookup("Psalm 1-5")[:title]
          expect(title).to eq("Psalm 1-5")
        end
  
        it "should find and clean the passage content via old_lookup" do
          content = BibleGateway.new(:english_standard_version).old_lookup("Psalm 1-5")[:content]
          expect(content).to include("<h3>The Way of the Righteous and the Wicked</h3>")
          expect(content).to include("<span class=\"chapternum\">1 </span>")
          expect(content).to include("<h3>Save Me, O My God</h3>")
          expect(content).to include("<span class=\"chapternum\">1 </span>")
          expect(content).to include("For you are not a God who delights in wickedness;")
        end
    end
  end
end
