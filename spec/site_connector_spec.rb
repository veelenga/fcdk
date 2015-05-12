require 'spec_helper'

require 'fcdk/site_connector'

module Fcdk
  describe SiteConnector do

    def mock_subject(page)
      allow(subject).to receive(:get_page_source).and_return(page)
      subject
    end

    describe '#get_seasons' do
      context 'when page contains seasons' do
        let(:page) do
          <<-EOP
            <div id='content'>
              <form action='#' class='select-form'>
                <fieldset>
                  <select id='season' name='season'>
                    <option value="2014_2015" selected>2014/2015</option>
                    <option value="2013_2014" >2013/2014</option>
                    <option value="2012_2013" >2012/2013</option>
                  </select>
                </fieldset>
              </form>
            </div>
          EOP
        end

        let(:seasons) { mock_subject(page).get_seasons }

        it 'detects all seasons' do
          expect(seasons).to match_array ['2014_2015', '2013_2014', '2012_2013']
        end
      end

      context 'when page does not contain seasons' do
        let(:page) do
          <<-EOP
            <div id='content'>
              <form>
                <fieldset/>
              </form>
            </div>
          EOP
        end

        let(:seasons) { mock_subject(page).get_seasons }

        it 'returns empty list' do
          expect(seasons).to be_empty
        end
      end
    end

    describe '#get_fixtures' do
      def search(fixtures, key)
        fixtures.inject([]) do |values, hash|
          values << hash[key]
        end
      end

      context 'when page contains fixtures' do
        let(:page) do
          <<-EOH
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
        end

        let(:fixtures) { mock_subject(page).get_fixtures }

        it 'detects all fixtures' do
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

      context 'when page does not contain fixtures' do
        let(:page) { "<div id='content' />" }
        let(:fixtures) { mock_subject(page).get_fixtures }

        it 'returns empty list' do
          expect(fixtures).to be_empty
        end
      end

      context "when 'season' parameter passed" do
        let(:page_2015) do
          <<-EOH
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
        end

        let(:page_2014) do
          <<-EOH
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
        end

        let(:connector) do
          allow(subject).to receive(:get_page_source)
            .with('matches/dynamo/matches/?season=2013')
            .and_return('')

          allow(subject).to receive(:get_page_source)
            .with('matches/dynamo/matches/?season=2014')
            .and_return(page_2014)

          allow(subject).to receive(:get_page_source)
            .with('matches/dynamo/matches/?season=2015')
            .and_return(page_2015)

          subject
        end

        it 'returns fixtures for the corresponding season' do
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
