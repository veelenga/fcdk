module Fcdk
  module Model
    # Result of the football match.
    # Represented by two numbers of goals:
    # 1. Goals that has owner team.
    # 2. Goals that has guest team.
    #
    #   # home team has 2 goals, guest team - 1
    #   Result.new(2, 1)
    #
    #   # both teams has 2 goals
    #   result = Result.new(2, 2)
    #   result.draw? # true
    class Result

      attr_accessor :owner_goal, :guest_goal

      def initialize(g1, g2)
        raise ArgumentError.new('number of goals can\'t be negative') if (g1 < 0 || g2 < 0)
        @owner_goal = g1
        @guest_goal = g2
      end

      def won?(home)
        (home && @owner_goal > @guest_goal) || (!home && @owner_goal < @guest_goal)
      end

      def draw?
        @owner_goal == @guest_goal
      end
    end
  end
end
