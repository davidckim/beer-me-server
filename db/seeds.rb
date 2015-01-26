require 'nokogiri'
require 'open-uri'

# counter = 1

# while counter <= 5 do

#   establishment = Nokogiri::HTML(open("https://www.beermenus.com/san-francisco/places?order=recent&page=#{counter}"))

#   establishment.css('a').each do |place|

#     link =  place.attribute('href').to_s
#     @restaurant = place.attribute('data-screen-title').to_s

#     if @restaurant != ''

#       beers_in_restaurants = Nokogiri::HTML(open("https://www.beermenus.com#{link}"))

#       @location_info = beers_in_restaurants.css('ul:first-child li:nth-child(2)').text.strip.to_s
#       @address = @location_info.strip.match(/^\d{1,}\s(\w|\s|\D){1,25}(\D|,)\s[a-zA-Z]{1,}(\s|.)/).to_s.gsub(/\r\n/," ")
#       @zip_code = @location_info.match(/\d{5}/).to_s

#       beers_in_restaurants.css('a').each do |info|
#           @beer = info.attribute('data-screen-title').to_s
#             if @beer != ''
#               info = info.css('p').text.strip.gsub("\n", "").split('  ')
#               @size = info[6].to_s
#               @abv = info[2]
#               @price = info.last.strip.to_s[4..-1]
#               if @size.include?('Draft')
#                 @new_beer = Beer.create(name: @beer, abv: @abv, price: @price)
#                 if @existing_beer = Beer.find_by(name: @beer)
#                   if !@existing_beer.locations.find_by(name: @restaurant)
#                     @existing_beer.locations << Location.create({name: @restaurant, address: @address, zip_code: @zip_code})
#                   end
#               end
#             end
#           end
#         end
#       end
#     end

#   counter += 1
# end


# counter = 1

# while counter <= 30 do

#   establishment = Nokogiri::HTML(open("https://www.beermenus.com/new-york-city/places?order=recent&page=#{counter}"))

#   establishment.css('a').each do |place|

#     link =  place.attribute('href').to_s
#     @restaurant = place.attribute('data-screen-title').to_s

#     if @restaurant != ''

#       beers_in_restaurants = Nokogiri::HTML(open("https://www.beermenus.com#{link}"))

#       @location_info = beers_in_restaurants.css('ul:first-child li:nth-child(2)').text.strip.to_s
#       @address = @location_info.strip.match(/^\d{1,}\s(\w|\s|\D){1,25}(\D|,)\s[a-zA-Z]{1,}(\s|.)/).to_s.gsub(/\r\n/," ")
#       @zip_code = @location_info.match(/\d{5}/).to_s

#       beers_in_restaurants.css('a').each do |info|
#           @beer = info.attribute('data-screen-title').to_s
#             if @beer != ''
#               info = info.css('p').text.strip.gsub("\n", "").split('  ')
#               @size = info[6].to_s
#               @abv = info[2]
#               @price = info.last.strip.to_s[4..-1]
#               if @size.include?('Draft')
#                 @new_beer = Beer.create(name: @beer, abv: @abv, price: @price)
#                 if @existing_beer = Beer.find_by(name: @beer)
#                   if !@existing_beer.locations.find_by(name: @restaurant)
#                     @existing_beer.locations << Location.create({name: @restaurant, address: @address, zip_code: @zip_code})
#                   end
#               end
#             end
#           end
#         end
#       end
#     end

#   counter += 1
# end

def seed_cities(city_array)

  city_array.each do |city|

    @city = city.downcase.split(' ').join('-')
    counter = 1

    while counter <= 5 do

      establishment = Nokogiri::HTML(open("https://www.beermenus.com/#{@city}/places?order=recent&page=#{counter}"))

      establishment.css('a').each do |place|

        link =  place.attribute('href').to_s
        @restaurant = place.attribute('data-screen-title').to_s

        if @restaurant != ''

          beers_in_restaurants = Nokogiri::HTML(open("https://www.beermenus.com#{link}"))

          @location_info = beers_in_restaurants.css('ul:first-child li:nth-child(2)').text.strip.to_s
          @address = @location_info.strip.match(/^\d{1,}\s(\w|\s|\D){1,25}(\D|,)\s[a-zA-Z]{1,}(\s|.)/).to_s.gsub(/\r\n/," ")
          @zip_code = @location_info.match(/\d{5}/).to_s

          beers_in_restaurants.css('a').each do |info|

            @beer = info.attribute('data-screen-title').to_s

            if @beer != ''
              info = info.css('p').text.strip.gsub("\n", "").split('  ')
              @size = info[6].to_s
              @abv = info[2]
              @price = info.last.strip.to_s[4..-1]

              if @size.include?('Draft')


                @existing_beer = Beer.find_by(name: @beer)
                 @beer_name_search_comp = @beer.downcase.gsub(/([^a-zA-Z0-9.])/, '-').gsub('.', '-')


                  if !@existing_beer

                    if @beer_name_search_comp  == 'timmermans-strawberry' || @beer_name_search_comp == nil
                      @beer_pic = 'http://i.imgur.com/jeJp7f6.png'
                    else
                      @image_scrape = Nokogiri::HTML(open("https://www.beermenus.com/beers/#{@beer_name_search_comp}")).css('img')[1].attribute('src').to_s

                      if @image_scrape.include?('https') && @image_scrape.include?('thumb')
                        @beer_pic = @image_scrape
                      else
                        @beer_pic = 'http://i.imgur.com/jeJp7f6.png'
                      end
                    end

                    @new_beer = Beer.create(name: @beer, abv: @abv, price: @price, image: @beer_pic)
                    @new_beer.locations << Location.create({name: @restaurant, address: @address, zip_code: @zip_code})
                  else
                    if !@existing_beer.locations.find_by(name: @restaurant)
                      @existing_beer.locations << Location.create({name: @restaurant, address: @address, zip_code: @zip_code})
                    end
                  end

                  # if !@existing_beer.locations.find_by(name: @restaurant)
                  # end

                  # if !@existing_beer.locations.find_by(name: @restaurant)
                  #   @existing_beer.locations << Location.create({name: @restaurant, address: @address, zip_code: @zip_code})
                  # end
                # end
              end
            end
          end
        end
      end
      counter += 1
    end
  end
end

seed_cities(['San Francisco'])




