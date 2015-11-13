require "rails_helper"

RSpec.describe LivesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/").to route_to("lives#index")
    end

    it "routes to #cycle" do
      expect(:get => "/lives/1/cycle").to route_to("lives#cycle", :id => "1")
    end

  end
end
