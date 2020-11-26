require 'bible_gateway/version'
require 'nokogiri'
require 'typhoeus'
require 'uri'

class BibleGatewayError < StandardError; end

class BibleGateway
  GATEWAY_URL = "http://biblegateway.com"
  CLASSIC_GATEWAY_URL = "http://classic.biblegateway.com"

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

    # French
    :bible_du_semeur => "BDS",
    :louis_segond => "LSG",
    :nouvelle_edition_de_geneve => "NEG1979",
    :segond_21 => "SG21",

    #Chinese
    :chinese_new_version_simplified => "CNVS",
    :chinese_union_version_simplified => "CUVS",
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
    scrape_passage(doc, @version, passage)
  end

  def old_lookup(passage)
    response = Typhoeus.get(old_passage_url(passage), followlocation: true)
    doc = Nokogiri::HTML(response.body)
    old_way_scrape_passage(doc)
  end

  private
    def passage_url(passage)
      "#{GATEWAY_URL}/passage/?search=#{URI.encode_www_form_component(passage)}&version=#{URI.encode_www_form_component(VERSIONS[version])}"
    end

    def old_passage_url(passage)
      "#{CLASSIC_GATEWAY_URL}/passage/?search=#{URI.encode_www_form_component(passage)}&version=#{URI.encode_www_form_component(VERSIONS[version])}"
    end

    def scrape_passage(doc, version, passage)
      container = doc.css('div.passage-text')
      title = doc.css(".dropdown-display-text").first.children.first.text
      title ||= passage
      segment = doc.at('div.passage-text')

      segment.search('sup.crossreference').remove # remove cross reference links
      segment.search('sup.footnote').remove # remove footnote links
      segment.search("div.crossrefs").remove # remove cross references
      segment.search("div.footnotes").remove # remove footnotes

      text = ""
      segment.search("span.text").each do |span|
        text += span.inner_text
      end

      segment.search("span.text").each do |span|
        html_content = span.inner_html
        span.swap html_content
      end
      
      segment.search('sup.versenum').each do |sup|
        html_content = sup.content
        sup.swap "<sup>#{html_content}</sup>"
      end

      content = segment.inner_html.gsub('<p></p>', '').gsub(/<!--.*?-->/, '').strip
      {:title => title, :content => content, :text => text }
    end

    def old_way_scrape_passage(doc)
      container = doc.css('div.container')
      title = container.css('div.passage-details h1')[0].content.strip
      segment = doc.at('div.passage-wrap')
      segment.search('sup.crossreference').remove # remove cross reference links
      segment.search('sup.footnote').remove # remove footnote links
      segment.search("div.crossrefs").remove # remove cross references
      segment.search("div.footnotes").remove # remove footnotes

      # extract text only from scripture
      text = ""
      segment.search("span.text").each do |span|
        text += span.inner_text
      end

      segment.search("span.text").each do |span|
        html_content = span.inner_html
        span.swap html_content
      end
      
      segment.search('sup.versenum').each do |sup|
        html_content = sup.content
        sup.swap "<sup>#{html_content}</sup>"
      end

      content = segment.inner_html.gsub('<p></p>', '').gsub(/<!--.*?-->/, '').strip
      {:title => title, :content => content, :text => text }
    end
end
