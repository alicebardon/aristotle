puts "Hey girl!"

require 'httparty'

API_KEY = "2a28d17c7d25458a32690f9869580391"

company_names = ['airbnb', 'uber', 'facebook', 'tiktok', 'twitter']

company_names.each do |name|

  response = HTTParty.get("https://api.crunchbase.com/api/v4/entities/organizations/#{name}",
    query: {
      user_key: API_KEY
    }
  )

  data = JSON.parse(response.body)

  puts data["properties"]["identifier"]["value"]
  puts data["properties"]["identifier"]["image_id"]
end
