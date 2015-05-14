
module Fcdk
  module Model
    # Football match of Dynamo Kiev vs opponent.
    # Represented by parameters:
    # 1. +date+ - date of the match
    # 2. +opponent+ - Dynamo's opponent
    # 3. +home+ - whether Dynamo plays at home or not
    # 4. +competition+ - name of the competition
    # 5. +round+ - round number
    # 6. +result+ - match resutl if match finished
    #
    # Match object is comparable with other Match object
    # by match date.
    #
    #   Match.new({:month => 3,
    #              :day => 12,
    #              :opponent => 'Shakhtar',
    #              :home => true,
    #              :competition => 'Ukrainian Premier League',
    #              :round => 26,
    #              :result => Result.new(5, 0)})
    class Match
      attr_accessor :month, :day, :opponent, :home,
        :competition, :round, :result

      def initialize(params)
        month = params[:month]
        day = params[:day]
        raise ArgumentError.new('Wrong month') if month && (month < 1 || month > 12)
        raise ArgumentError.new('Wrong day') if day && (day < 1 || day > 31)

        @month = month
        @day = day
        @opponent = params[:opponent]
        @home = params[:home]
        @competition = params[:competition]
        @round = params[:round]
        @result = params[:result]
      end

      def <=>(other)
        return nil unless other.kind_of? Match
        return @month <=> other.month if @month != other.month
        @day <=> other.day
      end
    end
  end
end
