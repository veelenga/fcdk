require 'spec_helper'

module Fcdk
  module Model
    describe Season do
      let(:year) { 2015 }
      subject{ Season.new(
        year, [
          Match.new({}),
          Match.new({}),
          Match.new({})
        ])}

      describe '#year' do
        it 'returns a year when season started' do
          expect(subject.year).to be year
        end
      end

      describe '#matches' do
        it 'returns a list of matches in this season' do
          expect(subject.matches).not_to be_empty
        end
      end

      it 'is comparable by year' do
        season1 = Season.new(2015, [Match.new(:round => 1)])
        season2 = Season.new(2016, [Match.new(:round => 2)])
        season3 = Season.new(2015, [Match.new(:round => 3)])

        expect(season1 <=> season2).to be(-1)
        expect(season2 <=> season1).to be(1)
        expect(season1 <=> season3).to be(0)
      end
    end
  end
end
