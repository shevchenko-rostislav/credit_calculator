require 'json'
require 'finance'
require 'pry'

class Calculator
  REQUIRED_ATTRIBUTES = %i(interest_rate amount maturity type)
  ALLOWED_TYPES       = %i(standard annuity)

  attr_reader :interest_rate, :amount, :type, :maturity, :errors
  def initialize(interest_rate:, amount:, type:, maturity:)
    @interest_rate = interest_rate.to_f
    @amount        = amount.to_i
    @type          = type.to_sym
    @maturity      = maturity.to_i

    @errors = { interest_rate: [], amount: [], type: [], maturity: [] }
  end

  def attributes
    { interest_rate: @interest_rate, amount: @amount, type: @type, maturity: @maturity }
  end

  def valid?
    REQUIRED_ATTRIBUTES.each { |attribute, _| passes_validation_for?(attribute) }

    has_errors?
  end

  def to_json
    attributes.to_json
  end

  def rate
    @_rate ||= Finance::Rate.new interest_rate/100, loan_type, duration: maturity
  end

  def amortization
    @_amortization ||= Finance::Amortization.new amount, rate
  end

  def calculate
    payments, interest = amortization.payments, amortization.interest

    payments.map.with_index do |payment, index|
      { month: index + 1,
        loan_payment: (payment.abs - interest[index]).to_f.round(10),
        interest: interest[index].to_f.round(10),
        total_payment: payment.abs.to_f.round(10),
        loan_payment_left: (amount - (payment.abs - interest[index])).to_f.round(10)
      }
    end
  end

  private

  def loan_type
    :apr
  end

  def passes_validation_for?(attribute)
    case attribute
    when :interest_rate then calculator_value_greater_than?(:interest_rate, 0.0)
    when :amount        then calculator_value_greater_than?(:amount, 0)
    when :maturity      then calculator_value_greater_than?(:maturity, 0)
    when :type          then calculator_value_allowed_in?(:type, ALLOWED_TYPES)
    end
  end

  def has_errors?
    errors.all? { |_, attribute_errors| attribute_errors.empty? }
  end

  def calculator_value_greater_than?(attribute, offset)
    return true if send(attribute) > offset

    errors[attribute] << "Must be greater than #{offset}"
    false
  end

  def calculator_value_allowed_in?(attribute, allowed_values)
    return true if allowed_values.include?(send(attribute))

    errors[attribute] << "Must be either one of #{allowed_values.join(', ')}"
    false
  end
end
