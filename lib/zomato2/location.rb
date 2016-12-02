module Zomato2
  class Location < EntityBase

    attr_reader :address, :locality, :city_name, :latitude, :longitude, :zipcode, :country_id,  # basic attrs
                :country_name, :city_id, :title, :entity_type, :entity_id      # detailed

    def initialize(zom_conn, attributes)
      super(zom_conn)
      @address      = attributes['address']
      @locality     = attributes['locality']
      @city_name    = attributes['city'] || attributes['city_name']
      @city_id      = attributes['city_id'] 
      @latitude     = attributes['latitude']
      @longitude    = attributes['longitude']
      @zipcode      = attributes['zipcode']
      @country_id   = attributes['country_id']
      @country_name = attributes['country_name']
      @title        = attributes['title']
      @entity_type  = attributes['entity_type']
      @entity_id    = attributes['entity_id']
    end

    def to_s; super; end

  end
end
