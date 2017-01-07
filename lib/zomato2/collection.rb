module Zomato2
  class Collection < EntityBase

    attr_reader :city_id, :id, :title, :url, :description, :image_url, :res_count, :share_url

    def initialize(zom_conn, cityid, attributes)
      super(zom_conn)
      @city_id = cityid
      @id  = attributes['collection_id']
      @url = attributes['url']
      @title  = attributes['title']
      @description = attributes['description']
      @image_url = attributes['image_url']
      @res_count = attributes['res_count']
      @share_url = attributes['share_url']
    end

    def restaurants(start: nil, count: nil)
      q = {collection_id: @id, entity_type: 'city', entity_id: @city_id }
      q[:start] = start if start
      q[:count] = count if count
      results = get('search', q)
      results['restaurants'].map { |e| Restaurant.new(@zom_conn, e['restaurant']) }
    end

  end
end

