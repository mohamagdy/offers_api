require 'rails_helper'

RSpec.describe "searches/new.html.haml", :type => :view do
  context "search form" do
    it "should display search form" do
      render

      expect(rendered).to include("uid")
      expect(rendered).to include("pub0")
      expect(rendered).to include("page")
    end
  end
end
