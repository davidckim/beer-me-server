require 'test_helper'

class BeersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:beers)
  end

  test "retrieves only beers in the appropriate zip code" do
    get (:show), {'id' => 94110}
    assert_response :success
    assert_not_nil assigns(:beers)
    assert @response.body.include?('beer1') && @response.body.include?('beer2'), @response.body
  end

  test "ranks beers according to the number of locations" do
    get (:show), {'id' => 94110 }
    assert_response :success
    assert_not_nil assigns(:beers)
    assert @response.body.index('beer1') < @response.body.index('beer2')
  end
end
