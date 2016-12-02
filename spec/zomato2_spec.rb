require File.expand_path(File.dirname(__FILE__) + '/spec_helper.rb')

describe Zomato2 do

  before(:each) do
    @zomato = Zomato2::Zomato.new(zkey)
  end

  it 'has a version number' do
    expect(Zomato2::VERSION).not_to be nil
  end

  # TODO

end

