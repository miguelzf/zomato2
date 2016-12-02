module Zomato2
  class Restaurant < EntityBase

    attr_reader :id, :name, :location, :average_cost_for_two, :price_range, :currency, :thumb, :featured_image,
                :photos_url, :menu_url, :events_url, :user_rating, :has_online_delivery, :is_delivering_now,
                :has_table_booking, :deeplink, :cuisines, :all_reviews_count, :photo_count,
                :phone_numbers, :photos, :reviews

    def initialize(zom_conn, attributes)
      super(zom_conn)
      attributes.each do |k,v|
        if k == 'apikey'
          next
        elsif k == 'R'
          @id = v['res_id']
        # Zomato never returns this?? bad API doc!
        elsif k == 'all_reviews'
          @reviews = []
          v.each do |rev|
            @reviews << Review.new(zom_conn, rev)
          end
        else
          # error if invalid attr
          self.instance_variable_set("@#{k}", v)
        end
      end
    end

    def to_s; super; end

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

      results.each do |k,v|
        if k == 'apikey'
          next
        elsif k == 'R'
          @id = v['res_id']
        elsif k == 'all_reviews'
          @reviews = []
          v.each do |rev|
            @reviews << Review.new(zom_conn, rev)
          end
        else
          # error if invalid attr
          self.instance_variable_set("@#{k}", v)
        end
      end
      self
    end

  end
end
