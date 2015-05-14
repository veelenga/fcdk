require 'spec_helper'

module Fcdk
  module Model
    describe Result do
      describe '#owner_goal' do
        it 'returns number of goals that has owner team' do
          expect(Result.new(3, 2).owner_goal).to be 3
          expect(Result.new(0, 2).owner_goal).to be 0
        end
      end

      describe '#guest_goal' do
        it 'returns number of goals that has guest team' do
          expect(Result.new(2, 3).guest_goal).to be 3
          expect(Result.new(2, 0).guest_goal).to be 0
        end
      end

      describe '#won?' do

        context 'when owner team has more goals then guest team' do
          subject { Result.new(2, 1) }
          it 'returns true with home parameter equal to true' do
            expect(subject.won?(true)).to be true
          end
          it 'returns false with home parameter equal to false' do
            expect(subject.won?(false)).to be false
          end
        end

        context 'when owner team has less goals then guest team' do
          subject { Result.new(1, 2) }
          it 'returns false with home parameter equal to true' do
            expect(subject.won?(true)).to be false
          end
          it 'returns true with home parameter equal to false' do
            expect(subject.won?(false)).to be true
          end
        end

        context 'when owner team has equal goals with guest team' do
          subject { Result.new(2, 2) }
          it 'returns false always' do
            expect(subject.won?(true)).to be false
            expect(subject.won?(false)).to be false
          end
        end
      end

      describe '#draw?' do
        context 'when owner team has more goals then guest team' do
          subject { Result.new(2, 1) }
          it 'retuns false' do
            expect(subject.draw?).to be false
          end
        end

        context 'when owner team has less goals then guest team' do
          subject { Result.new(1, 2) }
          it 'returns false' do
            expect(subject.draw?).to be false
          end
        end

        context 'when owner team has equal goals with guest team' do
          subject { Result.new(2, 2) }
          it 'returns true always' do
            expect(subject.draw?).to be true
          end
        end
      end

      context 'when at least one goal number is negative' do
        it 'raise ArgumentError' do
          expect{ Result.new(-1, 2) }.to raise_error ArgumentError
          expect{ Result.new(2, -1) }.to raise_error ArgumentError
          expect{ Result.new(-1, -1) }.to raise_error ArgumentError
        end
      end
    end
  end
end
