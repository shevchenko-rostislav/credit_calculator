require_relative '../story_helper.rb'
require 'pry'

describe 'Application' do
  it 'should show index page' do
    get '/'

    last_response.status.must_equal 200
  end
end
