require File.expand_path(File.dirname(__FILE__) + '/spec_helper.rb')

describe Zomato2::Zomato do

  before(:each) do
    @zomato = Zomato2::Zomato.new(ENV['ZOMATO_API_KEY'])
#    @nyc = @zomato.cities(q: 'New York City, NY')[0]
#    @lisbon = @zomato.cities(q: 'Lisbon, Portugal')[0]
  end

  describe 'Zomato search restaurants' do
    it 'search restaurants by coordinates' do
      VCR.use_cassette('rests_search_coords') do
        restaurants = @zomato.restaurants(lat: 28.557706, lon: 77.205879)  # New Delhi
        expect(restaurants.count).to be_a(Fixnum)
        expect(restaurants.count).to be > 10
        restaurants.each do |r|
          expect(r).to be_kind_of(Zomato2::Restaurant)
          expect(r.location).to be_kind_of(Zomato2::Location)
          r.establishments.each { |er| expect(er).to be_kind_of(Zomato2::Establishment) }
          r.reviews.each { |er| expect(er).to be_kind_of(Zomato2::Review) } if !r.reviews.nil?
        end
      end
    end

    it 'search restaurants by city name' do
      VCR.use_cassette('rests_search_city_name') do
        restaurants = @zomato.restaurants(q: 'Lisbon, Portugal')
        expect(restaurants.count).to be_a(Fixnum)
        expect(restaurants.count).to be > 10
        restaurants.each do |r|
          expect(r).to be_kind_of(Zomato2::Restaurant)
          expect(r.location).to be_kind_of(Zomato2::Location)
          r.establishments.each { |er| expect(er).to be_kind_of(Zomato2::Establishment) }
          r.reviews.each { |er| expect(er).to be_kind_of(Zomato2::Review) } if !r.reviews.nil?
        end
      end
    end

    it 'search restaurants by city name with start and count' do
      VCR.use_cassette('rests_search_city_name_limit') do
        restaurants = @zomato.restaurants(q: 'Lisbon, Portugal', start:10, count: 17)
        expect(restaurants.count).to be_a(Fixnum)
        expect(restaurants.count).to be == 17
        restaurants.each do |r|
          expect(r).to be_kind_of(Zomato2::Restaurant)
        end
      end
    end

    it 'search restaurants by establishment type' do
      VCR.use_cassette('rests_search_estab') do
        nyc = @zomato.cities(q: 'New York City, NY')[0]
        fine_dining_nyc = nyc.establishments.find {|e| e.name == 'Fine Dining' }
        rests_fine_nyc = @zomato.restaurants establishment_type: fine_dining_nyc.id

        expect(rests_fine_nyc.count).to be_a(Fixnum)
        expect(rests_fine_nyc.count).to be > 10

        rests_fine_nyc.each do |r|
          expect(r).to be_kind_of(Zomato2::Restaurant)
          res = r.establishments.any? {|e| e.id == fine_dining_nyc.id.to_s and e.name == 'Fine Dining'}
          expect(res).to be true
        end
      end
    end

    it 'search restaurants by collection type' do
      VCR.use_cassette('rests_search_collection') do
        nyc = @zomato.cities(q: 'New York City, NY')[0]
        collectname = 'Trending this week'
        trending_nyc = nyc.collections.find {|e| e.title == collectname }
        rests_trending_nyc = @zomato.restaurants collection_id: trending_nyc.id
        expect(rests_trending_nyc.count).to be_a(Fixnum)
        expect(rests_trending_nyc.count).to be > 10
        rests_trending_nyc.each do |r| expect(r).to be_kind_of(Zomato2::Restaurant) end
      end
    end

  end # zomato search restaurants


  describe 'Zomato Cities' do
    it 'city restaurants' do
      VCR.use_cassette('city_get_restaurants') do
        nyc = @zomato.cities(q: 'New York City, NY')[0]
        restaurants = nyc.restaurants
        restaurants.each do |r|
          expect(r).to be_kind_of(Zomato2::Restaurant)
          expect(r.location).to be_kind_of(Zomato2::Location)
          r.establishments.each { |er| expect(er).to be_kind_of(Zomato2::Establishment) }
          r.reviews.each { |er| expect(er).to be_kind_of(Zomato2::Review) } if !r.reviews.nil?
        end
      end
    end

    it 'city collections' do
      VCR.use_cassette('city_get_collects') do
        nyc = @zomato.cities(q: 'New York City, NY')[0]
        collections = nyc.collections
        expect(collections.count).to be_a(Fixnum)
        expect(collections.count).to be > 10

        collections.each do |c|
          expect(c).to be_kind_of(Zomato2::Collection)
          expect(c.city_id).to be == nyc.id

          %w(city_id id res_count).each do |k|
            v = c.send(k)
            expect(v).to be_kind_of(Fixnum)
            expect(v).to be > 0
          end
          %w(title description).each do |k|
            v = c.send(k)
            expect(v).to be_kind_of(String)
            expect(v.length).to be > 2
          end
          %w(url image_url share_url).each do |k|
            expect(k).to be_url
          end
        end
      end
    end

    it 'city establishments' do
      VCR.use_cassette('city_get_establishs') do
        nyc = @zomato.cities(q: 'New York City, NY')[0]
        establishments = nyc.establishments
        expect(establishments.count).to be_a(Fixnum)
        expect(establishments.count).to be > 10

        establishments.each do |e|
          expect(e).to be_kind_of(Zomato2::Establishment)
          expect(e.city_id).to be == nyc.id
          expect(e.id).to be_kind_of(Fixnum)
          expect(e.name).to be_kind_of(String)
          expect(e.name.length).to be > 2
        end
      end
    end

    it 'city cuisines' do
      VCR.use_cassette('city_get_cuisines') do
        nyc = @zomato.cities(q: 'New York City, NY')[0]
        cuisines = nyc.cuisines
        expect(cuisines.count).to be_a(Fixnum)
        expect(cuisines.count).to be > 10

        cuisines.each do |c|
          expect(c).to be_kind_of(Zomato2::Cuisine)
          expect(c.city_id).to be == nyc.id
          expect(c.id).to be_kind_of(Fixnum)
          expect(c.name).to be_kind_of(String)
          expect(c.name.length).to be > 2
        end
      end
    end

  end

  describe 'Zomato Restaurants' do
    # fetches more details about a given restaurant.. if any
    it 'restaurant details' do
      VCR.use_cassette('rests_get_details') do
        nyc = @zomato.cities(q: 'New York City, NY')[0]
        restaurants = nyc.restaurants
        restaurants.each do |r|
          expect(r).to be_kind_of(Zomato2::Restaurant)
          rd = r.details
          expect(rd).to be == r  # same id, name etc

          expect(rd).to be_kind_of(Zomato2::Restaurant)
          expect(rd.location).to be_kind_of(Zomato2::Location)
          rd.establishments.each { |er| expect(er).to be_kind_of(Zomato2::Establishment) }
          rd.reviews.each { |er| expect(er).to be_kind_of(Zomato2::Review) } if !r.reviews.nil?
        end
      end
    end

    # currently Zomato's API gives no menus..!?
    it 'restaurant menus' do
      VCR.use_cassette('rests_get_details') do
        #####
      end
    end
  end

  describe 'Zomato Establishments' do
    it 'establishment restaurants' do
      VCR.use_cassette('establs_get_restaurs') do
        nyc = @zomato.cities(q: 'New York City, NY')[0]
        fine_dining_nyc = nyc.establishments.find {|e| e.name == 'Fine Dining' }
        rests_fine_nyc = fine_dining_nyc.restaurants

        expect(rests_fine_nyc.count).to be_a(Fixnum)
        expect(rests_fine_nyc.count).to be > 10

        rests_fine_nyc.each do |r|
          expect(r).to be_kind_of(Zomato2::Restaurant)
          res = r.establishments.any? {|e| e.id == fine_dining_nyc.id and e.name == 'Fine Dining'}
          expect(res).to be true
        end
      end
    end
  end  # Zomato Establishments

  describe 'Zomato Collections' do
    it 'collection restaurants' do
      VCR.use_cassette('collects_get_restaurs') do
        nyc = @zomato.cities(q: 'New York City, NY')[0]
        collectname = 'Trending this week'
        trending_nyc = nyc.collections.find {|e| e.title == collectname }
        rests_trending_nyc = trending_nyc.restaurants

        expect(rests_trending_nyc.count).to be_a(Fixnum)
        expect(rests_trending_nyc.count).to be > 10
        rests_trending_nyc.each do |r|
          expect(r).to be_kind_of(Zomato2::Restaurant)
        end
      end
    end
  end  # Zomato Collections

  describe 'Zomato Locations' do
    it 'search locations by query' do
      VCR.use_cassette('locations_query') do
        lisbon = @zomato.cities(q: 'Lisbon')[0]

        loc = @zomato.locations(query: 'Lisbon')[0]
        expect(loc.longitude).to be_kind_of(Float)
        expect(loc.latitude).to be_kind_of(Float)
        expect(loc.city_id).to be == lisbon.id

        %w(city_name country_name title entity_type).each do |k|
          v = loc.send(k)
          expect(v).to be_kind_of(String)
          expect(v.length).to be > 2
        end
        %w(country_id city_id entity_id).each do |k|
          v = loc.send(k)
          expect(v).to be_kind_of(Fixnum)
          expect(v).to be > 2
        end
      end
    end


    it 'search locations by coords' do
      VCR.use_cassette('locations_coords') do
        params = {query: 'Alfama', lat: 38.736946, lon: -9.142685}
        loc = @zomato.locations(params)[0] # Lisbon
        lisbon = @zomato.cities(q: 'Lisbon')[0]

        expect(loc.longitude).to be_kind_of(Float)
        expect(loc.latitude).to be_kind_of(Float)
        expect(loc.city_id).to be == lisbon.id

        %w(city_name country_name title entity_type).each do |k|
          v = loc.send(k)
          expect(v).to be_kind_of(String)
          expect(v.length).to be > 2
        end
        %w(country_id city_id entity_id).each do |k|
          v = loc.send(k)
          expect(v).to be_kind_of(Fixnum)
          expect(v).to be > 2
        end
      end
    end
  end

  describe 'Zomato Categories' do
    it 'zomato categories' do
      VCR.use_cassette('categories_list') do
        cats = @zomato.categories
        cats.each do |c|
          expect(c.id).to be_kind_of(Fixnum)
          expect(c.name).to be_kind_of(String)
          expect(c.name.length).to be > 2
        end
      end
    end

    it 'category restaurants' do
      VCR.use_cassette('categories_rests') do
        cats = @zomato.categories
        cat_nightlife = cats.find {|c| c.name == 'Nightlife'}
        expect(cat_nightlife).to be_truthy

        rests_nightlife = cat_nightlife.restaurants start:5, count:10
        rests_nightlife.each do |r|
          expect(r).to be_kind_of(Zomato2::Restaurant)
          expect(r).to be_kind_of(Zomato2::Restaurant)
          expect(r.location).to be_kind_of(Zomato2::Location)
          r.establishments.each { |er| expect(er).to be_kind_of(Zomato2::Establishment) }
          r.reviews.each { |er| expect(er).to be_kind_of(Zomato2::Review) } if !r.reviews.nil?
        end
      end
    end

  end  # Zomato Categories
end

