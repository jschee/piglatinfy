module ScraperManager
  class Scraper < ApplicationService
    def initialize(attr)
      @url = attr[:url]
      @wiki = attr[:wiki]
    end

    def call
      start_scrape
    end

    def start_scrape
      get_wiki_page
    end

    private

    def get_wiki_page
      page = URI.open(@url)
      doc = Nokogiri::HTML(page)
      formatter(doc)
    end

    def formatter(doc)
      heading = doc.css('h1#firstHeading').text
      synopsis = doc.css('div#mw-content-text p').first.text.delete_suffix('\n')
      heading = translate_words(heading)
      body = translate_words(synopsis)
      @wiki.heading = heading
      @wiki.body = body
      @wiki
    end

    def translate_words(multi_words)
      multi_words.split.map do |word|
        translate(word)
      end.join(' ')
    end

    def translate(input)
      pig_string = ''
      if input[0] =~ /[aeiou]/
        return input + 'ay'
      elsif input[0] =~ /[^aeiou]/ && input[1] =~ /[aeiou]/
        return input[1..-1] + input[0] + 'ay'
      elsif input[0..1] =~ /[^aeiou]/
        return input[2..-1] + input[0..1] + 'ay'
      else
        return input[0] + input + 'ay'
      end
    end
  end
end