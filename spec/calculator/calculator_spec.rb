require_relative '../spec_helper'
require_relative '../../lib/calculator'

describe Calculator do
  let(:valid_calculator) { Calculator.new(interest_rate: 4.5, amount: 100.000, maturity: 12, type: :standard) }
  let(:invalid_calculator) { Calculator.new(interest_rate: -4.5, amount: 0, maturity: 'abc', type: :none) }

  let(:expected_to_json_output) { "{\"interest_rate\":4.5,\"amount\":100,\"type\":\"standard\",\"maturity\":12}" }
  let(:expected_attributes) { { interest_rate: 4.5, amount: 100.000, maturity: 12, type: :standard } }
  let(:expected_validation_errors) { {:interest_rate=>["Must be greater than 0.0"], :amount=>["Must be greater than 0"], :type=>["Must be either one of standard, annuity"], :maturity=>["Must be greater than 0"]} }

  describe 'Valid Calculator' do
    subject { valid_calculator }

    it '#valid?' do
      valid_calculator.valid?.must_equal true
    end

    describe '#to_json' do
      it 'must generate an expected json' do
        valid_calculator.to_json.must_equal expected_to_json_output
      end
    end

    describe '#attributes' do
      it 'should return attributes hash' do
        valid_calculator.attributes.sort.must_equal expected_attributes.sort
      end
    end

  end

  describe 'Invalid Calculator' do
    subject { invalid_calculator }

    it '#valid?' do
      invalid_calculator.valid?.must_equal false
      invalid_calculator.errors.sort.must_equal expected_validation_errors.sort
    end
  end
end
