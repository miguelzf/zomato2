module Zomato2
  class City < EntityBase

    attr_reader :id, :name, :country_id, :country_name, :is_state, :state_id,
                :state_name, :state_code, :discovery_enabled, :has_new_ad_format

    def initialize(zom_conn, attributes)
      super(zom_conn)
      @id = attributes['id']
      @name = attributes['name']
      @country_id = attributes['country_id']
      @country_name = attributes['country_name']
      @is_state = attributes['is_state'] != 0
      @state_id = attributes['state_id']
      @state_name = attributes['state_name']
      @state_code = attributes['state_code']
      @discovery_enabled = attributes['discovery_enabled']
      @has_new_ad_format = attributes['has_new_ad_format']
    end

    def to_s; super; end

    def collections(start: nil, count: nil)
      q = {city_id: @id }
      q[:start] = start if start
      q[:count] = count if count
      results = get('collections', q)
      results['collections'].map { |c| Collection.new(@zom_conn, @id, c['collection']) }
    end

    def establishments(start: nil, count: nil)
      q = {city_id: @id }
      q[:start] = start if start
      q[:count] = count if count
      results = get('establishments', q)
      results['establishments'].map { |e| Establishment.new(@zom_conn, @id, e['establishment']) }
    end

    # alias :super_get :get
    def cuisines(start: nil, count: nil)
      q = {city_id: @id }
      q[:start] = start if start
      q[:count] = count if count
      results = get('cuisines', q)
      results['cuisines'].map { |c| Cuisine.new(@zom_conn, @id, c['cuisine']) }
    end

    def restaurants(start: nil, count: nil)
      q = {entity_type: 'city', entity_id: @id }  # entity_id == city_id
      q[:start] = start if start
      q[:count] = count if count
      results = get('search', q)
      results['restaurants'].map { |e| Restaurant.new(@zom_conn, e['restaurant']) }
    end

  end
end
