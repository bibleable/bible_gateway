require 'bible_gateway/version'
require 'open-uri'
require 'nokogiri'

class BibleGatewayError < StandardError; end

class BibleGateway
  GATEWAY_URL = "http://www.biblegateway.com"

  VERSIONS = {
    :new_international_version => "NIV",
    :new_american_standard_bible => "NASB",
    :the_message => "MSG",
    :amplified_bible => "AMP",
    :new_living_translation => "NLT",
    :king_james_version => "KJV",
    :english_standard_version => "ESV",
    :contemporary_english_version => "CEV",
    :new_king_james_version => "NKJV",
    :new_century_version => "NCV",
    :king_james_version_21st_century => "KJ21",
    :american_standard_version => "ASV",
    :youngs_literal_translation => "YLT",
    :darby_translation => "DARBY",
    :holman_christian_standard_bible => "HCSB",
    :new_international_readers_version => "NIRV",
    :wycliffe_new_testament => "WYC",
    :worldwide_english_new_testament => "WE",
    :new_international_version_uk => "NIVUK",
    :todays_new_international_version => "TNIV",
  }

  def self.versions
    VERSIONS.keys
  end

  attr_accessor :version

  def initialize(version = :king_james_version)
    self.version = version
  end

  def version=(version)
    raise BibleGatewayError, 'Unsupported version' unless VERSIONS.keys.include? version
    @version = version
  end

  def lookup(passage)
    doc = Nokogiri::HTML(open(passage_url(passage)))
    scrape_passage(doc)
  end

  private
    def passage_url(passage)
      URI.escape "#{GATEWAY_URL}/passage/?search=#{passage}&version=#{VERSIONS[version]}"
    end

    def scrape_passage(doc)
      title = doc.css('h2')[0].content
      segment = doc.at('div.result-text-style-normal')
      segment.search('sup.xref').remove # remove cross reference links
      segment.search('sup.footnote').remove # remove footnote links
      segment.search("div.crossrefs").remove # remove cross references
      segment.search("div.footnotes").remove # remove footnotes
      segment.search('sup.versenum').each do |span|
        text = span.content
        span.swap "<sup>#{text}</sup>"
      end
      content = segment.inner_html.gsub('<p></p>', '').gsub(/<!--.*?-->/, '').strip
      {:title => title, :content => content }
    end
end
