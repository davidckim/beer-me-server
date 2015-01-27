class BeersController < ApplicationController
	before_filter :set_cors_headers
	def index
		@beers = Beer.all
		render json: @beers
	end

	def show
		get_beers_in_zip_code
		set_info_for_beers
		show_only_relevant_locations

		@beers = @beers.sort_by{|beer| beer[:rank]}

		render json: @beers
	end

	private
	def set_cors_headers
		headers['Access-Control-Allow-Origin'] = "*"
		headers['Access-Control-Allow-Methods'] = "GET"
		headers['Access-Control-Allow-Headers'] = "Origin, Content-Type, Accept, Authorization, Token"
	end

	def get_beers_in_zip_code
		@locations = Location.where(zip_code: params[:id])
		@beers_array = []
		@locations.each do |bar|
			@beers_array << bar.beers
		end
	end

	def set_info_for_beers		
		@beers_array.flatten!
		@beers = []
		@beers_array.each do |beer|
			@beers << {
				name: beer.name,
				abv: beer.abv,
				rank: beer.locations.count,
				price: beer.price,
				image: beer.image,
				rating: beer.rating,
				locations: beer.locations
			}
		end
	end

	def show_only_relevant_locations
		@beers.each do |beer|
				@locs = []
				@locs << beer[:locations]
				@locs.flatten!
				@locs.keep_if{|loc| @locations.include? loc}
				beer[:locations] = @locs
		end
	end

end
