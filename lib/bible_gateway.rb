require 'bible_gateway/version'
require 'nokogiri'
require 'typhoeus'
require 'uri'

class BibleGatewayError < StandardError; end

class BibleGateway
  GATEWAY_URL = "http://www.biblegateway.com"

  VERSIONS = {
    :american_standard_version => "ASV",
    :amplified_bible => "AMP",
    :common_english_bible => "CEB",
    :contemporary_english_version => "CEV",
    :darby_translation => "DARBY",
    :english_standard_version => "ESV",
    :holman_christian_standard_bible => "HCSB",
    :king_james_version => "KJV",
    :king_james_version_21st_century => "KJ21",
    :new_american_standard_bible => "NASB",
    :new_century_version => "NCV",
    :new_international_readers_version => "NIRV",
    :new_international_version => "NIV",
    :new_international_version_uk => "NIVUK",
    :new_king_james_version => "NKJV",
    :new_living_translation => "NLT",
    :new_revised_standard_version => "NRSV",
    :the_message => "MSG",
    :todays_new_international_version => "TNIV",
    :world_english_bible => "WEB",
    :worldwide_english_new_testament => "WE",
    :wycliffe_new_testament => "WYC",
    :youngs_literal_translation => "YLT",
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
    response = Typhoeus.get(passage_url(passage), followlocation: true)
    doc = Nokogiri::HTML(response.body)
    scrape_passage(doc)
  end

  private
    def passage_url(passage)
      URI.escape "#{GATEWAY_URL}/passage/?search=#{passage}&version=#{VERSIONS[version]}"
    end

    def scrape_passage(doc)
      container = doc.css('div.container')
      title = container.css('div.passage-details h1')[0].content.strip
      segment = doc.at('div.passage-wrap')
      segment.search('sup.crossreference').remove # remove cross reference links
      segment.search('sup.footnote').remove # remove footnote links
      segment.search("div.crossrefs").remove # remove cross references
      segment.search("div.footnotes").remove # remove footnotes
      segment.search("span.text").each do |span|
        text = span.inner_html
        span.swap text
      end

      segment.search('sup.versenum').each do |sup|
        text = sup.content
        sup.swap "<sup>#{text}</sup>"
      end
      content = segment.inner_html.gsub('<p></p>', '').gsub(/<!--.*?-->/, '').strip
      {:title => title, :content => content }
    end
end
