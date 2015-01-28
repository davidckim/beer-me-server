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
                      @beer_page = Nokogiri::HTML(open("https://www.beermenus.com/beers/#{@beer_name_search_comp}"))
                      @description = @beer_page.css('div.description').children.text.gsub(/\n/, "").squeeze.gsub(/^\s/, '')
                      @image_scrape = @beer_page.css('img')[1].attribute('src').to_s
                      if @image_scrape.include?('https') && @image_scrape.include?('thumb')
                        @beer_pic = @image_scrape
                      else
                        @beer_pic = 'http://i.imgur.com/jeJp7f6.png'
                      end
                    end

                    @new_beer = Beer.create(name: @beer, abv: @abv, price: @price, image: @beer_pic, desc: @description)
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


def seed_ratings
  beers_array = Beer.pluck(:name)
  beers_array.each do |beer_name|
    cold_filtered = filter_beer_name(beer_name)
    scrape_search_page(cold_filtered, beer_name)
  end
end

def filter_beer_name(beer_name)
  beer_name.gsub(/[äöü’]/) do |match|
    case match
      when "ä" then "a"
      when "ö" then "o"
      when "’" then ""
      when "ü" then "u" 
     end      
  end
end

def scrape_search_page(beer_name, db_name)
  beer = beer_name.gsub(" ", "+")
  # puts "http://beeradvocate.com/search?q=#{beer}&qt=beer"
  ba_searchpage = Nokogiri::HTML(open("http://beeradvocate.com/search?q=#{beer}&qt=beer"))
  first_beer = ba_searchpage.css('ul').children.css('a').first
  first_url = first_beer.attributes["href"].value
    if first_url == 'lost-password/'
      not_rated = Beer.find_by(name: db_name)
      not_rated.update(rating: "NR")
      # puts "#{beer_name.to_s} : Not yet rated"
    else
      #start on individual beer page
      scrape_profile_page(first_url, db_name)
    end
end
  
  
def scrape_profile_page(url, db_name)
  profile_page = Nokogiri::HTML(open("http://beeradvocate.com#{url}"))
  rating_value = profile_page.css("span.ba-score").children.text.to_i
  # puts "#{name.to_s} : #{rating_value}"
  add_rating = Beer.find_by(name: db_name)
  add_rating.update(rating: rating_value.to_s)  
end

seed_ratings


