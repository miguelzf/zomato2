module Zomato2
  class Category < EntityBase

    attr_reader :id, :name

    def initialize(zom_conn, attributes)
      super(zom_conn)
      @id = attributes['id']
      @name = attributes['category_name']
    end

    def to_s; super; end

    def restaurants(start: nil, count: nil)
      q = {category_id: @id }
      q[:start] = start if start
      q[:count] = count if count
      results = get('search', q)
      results['restaurants'].map { |e| Restaurant.new(@zom_conn, e['restaurant']) }
    end

  end
end
