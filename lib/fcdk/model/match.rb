
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
    #   Match.new({:date => Date.today,
    #              :opponent => 'Shakhtar',
    #              :home => true,
    #              :competition => 'Ukrainian Premier League',
    #              :round => 26,
    #              :result => Result.new(5, 0)})
    class Match
      attr_accessor :date, :opponent, :home,
        :competition, :round, :result

      def initialize(params)
        date = params[:date]
        @date = date if date.kind_of? Date

        @opponent = params[:opponent]
        @home = params[:home]
        @competition = params[:competition]
        @round = params[:round]
        @result = params[:result]
      end

      def <=>(other)
        @date <=> other.date if other.kind_of? Match
      end
    end
  end
end
