require 'nokogiri'
require 'open-uri'

module Fcdk
  # Helps to communicate with Dynamo Kiev official site.
  # Common usage scenario is to query and parse information.
  # Examples:
  #   site = SiteConnector.new
  #   site.get_seasons
  #   site.get_fixtures '2014_2015'
  class SiteConnector
    SITE_URL = 'http://www.fcdynamo.kiev.ua/en'

    # Returns a list of available seasons.
    # Parsed from the following dom model:
    #   <div id='content'>
    #     ...
    #     <select id='season'>
    #       <option value='SEASON1'/>
    #       <option value='SEASON2'/>
    #       ...
    #     </select>
    #     ...
    #   </div>
    def get_seasons
      season_list_url = 'matches/dynamo/matches/'

      doc = Nokogiri::HTML(get_page_source(season_list_url))

      doc.xpath("//div[@id='content']/*/*/select[@id='season']/option/@value")
        .map do |value|
          value.to_s.strip
        end
    end

    # Returns a list of available fixtures.
    # Fixture is represented as hash with the following parameters:
    #   :date - date of the fixutre
    #   :team - Dynamo's opponent
    #   :ha   - home/away
    #   :comp - competition name
    #   :round - round number
    #   :result - final match result (0-0, 1-0, 1-1 etc.)
    # Parsed from the following dom model:
    #   <div id='content'>
    #     ...
    #     <table class='result'>
    #       <tbody>
    #         <tr>
    #           <td><em>date</em></td>
    #           <td>team</td>
    #           <td>ha</td>
    #           <td>comp</td>
    #           <td>round</td>
    #           <td>result</td>
    #         </tr>
    #       </tbody>
    #     </table>
    #   </div>
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
