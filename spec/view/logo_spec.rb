require 'spec_helper'
require 'fcdk/view/logo'

module Fcdk
  module View
    describe Logo do
      it 'has not nil CONTENT of type String' do
        expect(Logo::CONTENT).to be_a String
        expect(Logo::CONTENT).not_to be nil?
      end
    end
  end
end
