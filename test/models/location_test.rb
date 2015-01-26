require 'test_helper'

class LocationTest < ActiveSupport::TestCase

  test "saves yml locations to database" do
    assert Location.all.count == 5
  end

  test "beers can be called from locations" do 
  	assert Location.find_by(name: 'loc4').beers.count == 2, Location.find_by(name: 'loc4').beers.count
  end

end
