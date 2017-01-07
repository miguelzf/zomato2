require 'faraday'
require 'json'

module Zomato2

  class Zomato

    def initialize(z_api_key)
      @api_key = z_api_key
      @headers = {'Accept' => 'application/json', 'user-key' => @api_key}
      @base_uri = 'https://developers.zomato.com/api/v2.1/'
      @conn = Faraday.new url: "#{@base_uri}", headers: @headers
    end

    def get(endpoint, params)
      query = params.map{ |k,v| "&#{k}=#{v}" }.join ''
      requrl = "#{endpoint}?#{query}"
      resp = @conn.get(requrl)
      results = JSON.parse(resp.body)
      results
    end

    def cities(params)
      if params.class != Hash or params.keys.length == 0
        warn 'This endpoint requires at least 1 param: "q" search, "lat"/"lot" or "city_id"'
      end

      results = get('cities', params)

      # {"location_suggestions" => Array, "status"=>"success", "has_more"=>0, "has_total"=>0}
      if results.key?("location_suggestions")
        results["location_suggestions"].map { |c| City.new(self, c) }
      else
        nil
      end
    end

    def categories()
      results = get('categories', {})
      results['categories'].map { |e| Category.new(self, e['categories']) }
    end

    # search for locations
    def locations(params={})
      args = [ :query, :lat, :lon, :count ]
      params.each do |k,v|
        if !args.include?(k)
          raise ArgumentError.new 'Search term not allowed: ' + k.to_s
        end
      end

      if !params.include?(:query)
        raise ArgumentError.new '"query" term with location name is required'
      end

      results = get('locations', params)
      if results.key?("location_suggestions")
        results["location_suggestions"].map { |l| Location.new(self, l) }
      else
        nil
      end
    end

    # general search for restaurants
    def restaurants(params={})
      args = [ :entity_id, :entity_type, # location
               :q, :start, :count, :lat, :lon,
               :radius, :cuisines, :establishment_type,
               :collection_id, :category, :sort, :order,
               :start, :count ]

      params.each do |k,v|
        if !args.include?(k)
          raise ArgumentError.new 'Search term not allowed: ' + k.to_s
        end
      end

      if params[:count] && params[:count].to_i > 20
        warn 'Count maxes out at 20'
      end

      # these filters are already city-specific
      has_sub_city = params[:establishment_type] || params[:collection_id] || params[:cuisines]

      if (has_sub_city && params[:q]) ||
         (has_sub_city && params[:entity_type] == 'city') ||
         (params[:q] && params[:entity_type] == 'city')
        warn 'More than 2 different kinds of City searches cannot be combined'
      end

      results = get('search', params)
      results['restaurants'].map { |e| Restaurant.new(self, e['restaurant']) }
    end

  end
end
