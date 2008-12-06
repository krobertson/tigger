require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "/commits" do
  before(:each) do
    @response = request("/commits")
  end
end