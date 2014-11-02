require 'test_helper'

class PaymentAccountControllerTest < ActionController::TestCase
  test "should get credit" do
    get :credit
    assert_response :success
  end

  test "should get debit" do
    get :debit
    assert_response :success
  end

end
