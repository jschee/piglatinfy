# frozen_string_literal: true
require 'open-uri'
require 'nokogiri'

class Wiki
  include ActiveModel::Model
  include Piglatinfy

  attr_accessor :url, :heading, :body

  def initialize(attributes)
    @url = attributes.fetch(:url)
    @heading = nil
    @body = nil
  end

  validates :url, presence: true

  def process
    start_scrape
  end

  def start_scrape
    get_wiki_page
  end

  private

  def get_wiki_page
    page = URI.open(@url)
    doc = Nokogiri::HTML(page)
    heading = doc.css('h1#firstHeading').text
    synopsis = doc.css('div#mw-content-text p').first.text.delete_suffix('\n')
    formatter(heading, synopsis)
  end

  def formatter(heading, synopsis)
    heading = translate_words(heading)
    body = translate_words(synopsis)
    self.heading = heading
    self.body = body
  end
end
