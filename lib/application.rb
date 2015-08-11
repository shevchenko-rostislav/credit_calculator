require 'sinatra'
require 'pry'
require 'json'

require_relative 'calculator'

class Application < Sinatra::Base
  set :app_file, __FILE__
  configure { set :server, :puma }


  # Root path
  get '/' do
    erb :index
  end

  post '/calculate' do
    content_type :json

    @calculator = Calculator.new(calculation_params)

    if @calculator.valid?
      status 200

      { calculation: erb(:calculation, locals: { calculation: @calculator.calculate }, layout: false) }.to_json
    else
      status 422

      { errors: @calculator.errors }.to_json
    end
  end

  private

  def calculation_params
    params.select { |attribute, _| Calculator::REQUIRED_ATTRIBUTES.include?(attribute.to_sym) }.
      inject(Hash.new) { |memo, (key, value)| memo[key.to_sym] = value; memo } # turn string keys to sym keys
  end
end
