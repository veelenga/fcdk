require 'spec_helper'

module Fcdk
  module Model
    describe Match do
      let(:params) { {:month => 3,
                      :day => 12,
                      :opponent => 'Shakhtar',
                      :home => true,
                      :competition => 'Ukrainian Premier League',
                      :round => 26,
                      :result => Result.new(5, 0)} }

      subject { Match.new (params) }

      describe '#month' do
        it 'returns month of the match date' do
          expect(subject.month).to be params[:month]
        end
      end

      describe '#day' do
        it 'returns day of the match date' do
          expect(subject.day).to be params[:day]
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

      it 'is comporable by date' do
        match1 = Match.new(:month => 3, :day => 1)
        match2 = Match.new(:month => 4, :day => 1)
        match3 = Match.new(:month => 4, :day => 2)
        match4 = Match.new(:month => 4, :day => 2)

        expect(match1 <=> match2).to be(-1)
        expect(match2 <=> match1).to be(1)
        expect(match2 <=> match3).to be(-1)
        expect(match3 <=> match2).to be(1)
        expect(match3 <=> match4).to be(0)
      end

      it 'is not comparable with other objects' do
        other = Object.new
        allow(other).to receive(:month).and_return(12)
        allow(other).to receive(:day).and_return(1)
        expect(subject <=> other).to be nil
      end
    end
  end
end
