# Zomato2

This is a simple and clean wrapper for the API version 2.1 of Zomato / Urbanspoon.

## Installation

Add this gem to your application's Gemfile:

```ruby
gem 'zomato2'
```

And then execute:

    $ bundle

Or install directly with:

    $ gem install zomato2

## Usage

```Ruby
require 'zomato2'

zom_api_key = ENV['ZOMATO_API_KEY']
zomato = Zomato2::Zomato.new(zom_api_key)

puts zomato.restaurants #.each { |r| puts r.details.reviews }

zomato.cities({q: 'new'}).each do |c|
  c.restaurants.each { |r| puts r.details }
end

nyc = zomato.cities(q: "New York City, NY")[0]

american_nyc = nyc.cuisines.find {|c| c.name == 'American'}

top_trending_nyc = nyc.collections[0]

fine_dining_nyc = nyc.establishments.find {|e| e.name == 'Fine Dining' }

american_rests_in_nyc = american_nyc.restaurants

american_rests_in_nyc.find_all {|r| r.name =~ /Joe/ } .each { |r| puts r.menu }

some_rests1 = zomato.restaurants establishment_type: fine_dining_nyc.id, start:10, count: 5

some_rests2 = zomato.restaurants q: 'Lisboa'
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.


## Contributing

Bug reports and pull requests are welcome.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

