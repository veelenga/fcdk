require 'spec_helper'

module Fcdk
  module Model
    describe Match do
      let(:params) { {:date => Date.today,
                      :opponent => 'Shakhtar',
                      :home => true,
                      :competition => 'Ukrainian Premier League',
                      :round => 26,
                      :result => Result.new(5, 0)} }

      subject { Match.new (params) }

      describe '#date' do
        it 'returns date of the match' do
          expect(subject.date).to be params[:date]
        end
      end

      describe '#opponent' do
        it "returns Dynamo's opponent" do
          expect(subject.opponent).to be params[:opponent]
        end
      end

      describe '#home' do
        it 'returns whether Dynamo plays at home' do
          expect(subject.home).to be params[:home]
        end
      end

      describe '#competition' do
        it 'returns name of the competition' do
          expect(subject.competition).to be params[:competition]
        end
      end

      describe '#round' do
        it 'returns number of the current round' do
          expect(subject.round).to be params[:round]
        end
      end

      describe '#result' do
        it 'returns result of the match' do
          expect(subject.result).to be params[:result]
        end
      end

      it 'is sorted by date' do
        sorted = [
          Match.new(:date => Date.today - 3),
          Match.new(:date => Date.today),
          Match.new(:date => Date.today - 1),
          Match.new(:date => Date.today - 2),
        ].sort

        sorted.each.with_index do |curr, i|
          if i > 0
            expect(curr.date).to be > sorted[i - 1].date
          end
        end
      end

      it 'is not comparable with other objects' do
        other = Object.new
        allow(other).to receive(:date).and_return(Date.today)
        expect(subject <=> other).to be nil
      end
    end
  end
end
