require 'delegate'

module ApplicantDispatch
  module Scorers
    class ScoreableEntity < SimpleDelegator
      attr_accessor :score

      def initialize(entity)
        @score = 0

        super(entity)
      end

      def unwrap
        __getobj__
      end
    end
  end
end
