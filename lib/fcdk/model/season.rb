
module Fcdk
  module Model
    # Represents a football season.
    # Has two parameters:
    # 1. +year+ - season year.
    # 2. +matches+ - matches in that season.
    #
    #   Season.new(year, matches)
    #   season.add_match(new_match)
    class Season
      attr_accessor :year, :matches

      def initialize(year, matches)
        @year = year
        @matches = matches
      end

      def add_match(match)
        matches.add match
      end

      def remove_match(match)
        matches.remove match
      end

      def <=>(other)
        @year <=> other.year if other.kind_of? Season
      end
    end
  end
end
