module Zomato2
  class Restaurant < EntityBase

    attr_reader :id, :name, :location, :average_cost_for_two, :price_range, :currency, :thumb, :featured_image,
                :photos_url, :menu_url, :events_url, :user_rating, :has_online_delivery, :is_delivering_now,
                :has_table_booking, :deeplink, :cuisines, :all_reviews_count, :photo_count,
                :phone_numbers, :photos,  :city_id
    attr_accessor :reviews, :establishments

    def initialize(zom_conn, attributes)
      super(zom_conn)
      @location = Location.new zom_conn, attributes["location"]
      @city_id = @location.city_id

      attributes.each do |k,v|
        if k == 'apikey'
          next
        elsif k == 'R'
          @id = v['res_id']
        # Zomato never returns this?? bad API doc!
        elsif k == 'location'
          next
        elsif k == 'all_reviews'
          @reviews = v.map{ |r| Review.new(zom_conn, r) }
        elsif k == 'establishment_types'
          @establishments = v.map{ |e,ev| Establishment.new(zom_conn, @city_id, ev) }
        # elsif k == 'cuisines' the returned cuisines here are just a string..
        else
          #puts "ATTR @#{k} val #{v}"
          self.instance_variable_set("@#{k}", v)
        end
      end
    end

    def to_s; super; end

    def ==(other)
      @id == other.id and @name == other.name and @city_id == other.city_id # ...
    end

    def <=>(other)
      @id <=> other.id
    end

    def menu(start: nil, count: nil)
      q = {res_id: @id }
      q[:start] = start if start
      q[:count] = count if count
      results = get('dailymenu', q)
      return nil if results['message'] == "No Daily Menu Available"
      results['daily_menu'].map { |e| Menu.new(@zom_conn, @id, e['daily_menu']) }
    end

    # this doesn't actually give any more detailed info..
    def details(start: nil, count: nil)
    # warn "\tRestaurant#details: This method is currently useless, since, " +
    #      "as of January 2017, Zomato's API doesn't give any additional info here."

      q = {res_id: @id }
      q[:start] = start if start
      q[:count] = count if count
      results = get('restaurant', q)

      @location ||= Location.new zom_conn, attributes["location"]
      @city_id ||= @location.city_id

      results.each do |k,v|
        if k == 'apikey'
          next
        elsif k == 'R'
          @id = v['res_id']
        # Zomato never returns this?? bad API doc!
        elsif k == 'location'
          next
        elsif k == 'all_reviews'
          @reviews ||= v.map{ |r| Review.new(zom_conn, r) }
        elsif k == 'establishment_types'
          @establishments ||= v.map{ |e,ev| Establishment.new(zom_conn, @city_id, ev) }
        # elsif k == 'cuisines' the returned cuisines here are just a string..
        else
          #puts "ATTR @#{k} val #{v}"
          self.instance_variable_set("@#{k}", v)
        end
      end
      self
    end
  end
end
