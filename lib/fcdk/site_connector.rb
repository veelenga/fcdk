require 'nokogiri'
require 'open-uri'

module Fcdk
  class SiteConnector
    SITE_URL = 'http://www.fcdynamo.kiev.ua/en'

    def get_fixtures(season = nil)
      fixture_list_url = 'matches/dynamo/matches/'
      fixture_list_url << "?season=#{season}" if season

      doc = Nokogiri::HTML(get_page_source(fixture_list_url))

      rows = doc.xpath("//div[@id='content']/*/table[@class='result']/tbody/tr")

      rows.collect do |row|
        detail = {}
        [
          [:date,   'td/em/text()'],
          [:team,   'td[2]/text()'],
          [:ha,     'td[3]/text()'],
          [:comp,   'td[4]/text()'],
          [:round,  'td[5]/text()'],
          [:result, 'td[6]/text()'],
        ].each do |name, xpath|
          detail[name] = row.at_xpath(xpath).to_s.strip
        end
        detail
      end
    end

    private

    def get_page_source(page)
      open("#{SITE_URL}/#{page}")
    end
  end
end
