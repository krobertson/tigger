require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "/browser" do
  before(:each) do
    @response = request("/browser")
  end
end