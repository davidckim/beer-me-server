require 'test_helper'

class BeerTest < ActiveSupport::TestCase
  
  test "saves yml beers to database" do
    assert Beer.count == 2
  end

  test "associations to locations can be called from beers" do
    assert Beer.find_by(name: 'beer1').locations.count == 4, Beer.find_by(name: 'beer1').locations.count 
  end
  
end
