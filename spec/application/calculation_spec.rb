require_relative '../story_helper.rb'
require 'pry'

describe 'Application' do
  it 'should render errors if invalid parameters posted' do
    post '/calculate', { interest_rate: 0, amount: 0, type: :none, maturity: 0 }

    last_response.status.must_equal 422

    expected_errors = {"errors"=>
                       {"interest_rate"=>["Must be greater than 0.0"],
                        "amount"=>["Must be greater than 0"],
                        "type"=>["Must be either one of standard, annuity"],
                        "maturity"=>["Must be greater than 0"]}
    }

    JSON.parse(last_response.body).must_equal expected_errors
  end

  it 'should render calculations if valid parameters posted' do
    post '/calculate', { interest_rate: 5, amount: 10000, type: :annuity, maturity: 2 }

    last_response.status.must_equal 200

    expected_body = "{\"calculation\":\"  <tr>\\n    <td> 1 </td>\\n    <td> 4989.6 </td>\\n    <td> 41.67 </td>\\n    <td> 5031.27 </td>\\n    <td> 5010.4 </td>\\n  </tr>\\n  <tr>\\n    <td> 2 </td>\\n    <td> 5010.4 </td>\\n    <td> 20.88 </td>\\n    <td> 5031.28 </td>\\n    <td> 4989.6 </td>\\n  </tr>\\n\"}"
    last_response.body.must_equal expected_body
  end
end
