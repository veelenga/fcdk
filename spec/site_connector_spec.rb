require 'spec_helper'

require 'fcdk/site_connector'

module Fcdk
  describe SiteConnector do

    describe '#get_fixtures' do

      def search(fixtures, key)
        fixtures.inject([]) do |values, hash|
          values << hash[key]
        end
      end

      context 'when page has few fixtures' do
        let(:fixtures) do
          html = <<-EOH
            <div id='content'>
              <div class='box'>
                <table class='result'>
                  <tbody>
                    <tr>
                      <td><em>date1</em></td>
                      <td>team1</td>
                      <td>ha1</td>
                      <td>comp1</td>
                      <td>round1</td>
                      <td>result1</td>
                    </tr>
                    <tr>
                      <td><em>date2</em></td>
                      <td>team2</td>
                      <td>ha2</td>
                      <td>comp2</td>
                      <td>round2</td>
                      <td>result2</td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
          EOH
          object = SiteConnector.new
          allow(object).to receive(:get_page_source)
            .and_return(html)

          object.get_fixtures
        end

        it 'detects all fixtures on the page' do
          expect(fixtures.size).to be 2
        end

        it "properly parses fixture's date" do
          dates = search(fixtures, :date)
          expect(dates).to match_array(['date1', 'date2'])
        end

        it "properly parses fixture's team" do
          dates = search(fixtures, :team)
          expect(dates).to match_array(['team1', 'team2'])
        end

        it "properly parses fixture's H/A" do
          dates = search(fixtures, :ha)
          expect(dates).to match_array(['ha1', 'ha2'])
        end

        it "properly parses fixture's competion" do
          dates = search(fixtures, :comp)
          expect(dates).to match_array(['comp1', 'comp2'])
        end

        it "properly parses fixture's round" do
          dates = search(fixtures, :round)
          expect(dates).to match_array(['round1', 'round2'])
        end

        it "properly parses fixture's result" do
          dates = search(fixtures, :result)
          expect(dates).to match_array(['result1', 'result2'])
        end

      end

      context 'when page does not have fixtures' do
        let(:fixtures) do
          html = <<-EOH
            <div id='content'/>
          EOH
          object = SiteConnector.new
          allow(object).to receive(:get_page_source)
            .and_return(html)

          object.get_fixtures
        end
        it 'returns empty list' do
          expect(fixtures).to be_empty
        end
      end

      context "when 'season' parameter passed" do

        let(:connector) do
          html_2015 = <<-EOH
            <div id='content'>
              <div class='box'>
                <table class='result'>
                  <tbody>
                    <tr>
                      <td><em>2015</em></td>
                      <td>team</td>
                      <td>ha</td>
                      <td>comp</td>
                      <td>round</td>
                      <td>result</td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
          EOH

          html_2014 = <<-EOH
            <div id='content'>
              <div class='box'>
                <table class='result'>
                  <tbody>
                    <tr>
                      <td><em>2014</em></td>
                      <td>team</td>
                      <td>ha</td>
                      <td>comp</td>
                      <td>round</td>
                      <td>result</td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
          EOH

          object = SiteConnector.new
          allow(object).to receive(:get_page_source)
            .with('matches/dynamo/matches/?season=2014')
            .and_return(html_2014)

          allow(object).to receive(:get_page_source)
            .with('matches/dynamo/matches/?season=2015')
            .and_return(html_2015)

          allow(object).to receive(:get_page_source)
            .with('matches/dynamo/matches/?season=2013')
            .and_return('')

          object
        end

        it 'returns fixtures for that corresponding season' do
          fixtures = connector.get_fixtures('2015')
          expect(search(fixtures, :date)).to match_array ['2015']

          fixtures = connector.get_fixtures('2014')
          expect(search(fixtures, :date)).to match_array ['2014']
        end

        it 'returns empty list if such season not exists' do
          fixtures = connector.get_fixtures('2013')
          expect(fixtures).to be_empty
        end
      end
    end
  end
end
