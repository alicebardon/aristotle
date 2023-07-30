class StartupsController < ApplicationController

  API_KEY = "2a28d17c7d25458a32690f9869580391"

  def index
    @startups = fetch_multiple_startups
  end






  private

  def fetch_multiple_startups
    require 'httparty'

    company_names = ['airbnb', 'uber', 'facebook', 'tiktok', 'twitter']

    data = []

    company_names.each do |name|
      response = HTTParty.get("https://api.crunchbase.com/api/v4/entities/organizations/#{name}",
        query: {
          user_key: API_KEY
        }
      )
      result = JSON.parse(response.body)
      data << result
    end

    companies = []

    data.each do |company|
      companies << {
        name: company["properties"]["identifier"]["value"],
        logo: company["properties"]["identifier"]["image_id"]
      }
    end
    return companies
  end
end
