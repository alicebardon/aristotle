class StartupsController < ApplicationController
  require 'net/http'
  require 'uri'
  require 'zip'
  require 'fileutils'

  API_KEY = " "

  def index
    @startups = fetch_multiple_startups
  end

  def download_logos
    @startups = fetch_multiple_startups

    # Create the folder "Aristotle_logos" if it doesn't exist
    folder_name = 'Aristotle_logos'
    FileUtils.mkdir_p(folder_name)

    @startups.each do |startup|
      logo_url = "https://images.crunchbase.com/image/upload/c_lpad,f_auto,q_auto:eco,dpr_1/#{startup[:logo]}"
      # Specify the destination filename for the downloaded image
      image_filename = File.join(folder_name, "#{startup[:name]}.jpg")

      # Use URI.parse to get the actual image URL (follow redirects if any)
      actual_image_url = URI.parse(logo_url).to_s

      # Download the image from the URL and save it to the destination file
      download_image(actual_image_url, image_filename)
    end
  end

  ###### PRIVATE METHODS ######

  private

  def fetch_multiple_startups
    require 'httparty'

    company_names = %w[vivenu workmotion celonis deliverr stripe slack
      zoom datadog airbnb uber facebook tiktok twitter bolt pigment]

    data = []

    company_names.each do |name|
      response = HTTParty.get("https://api.crunchbase.com/api/v4/entities/organizations/#{name}",
        query: { user_key: API_KEY }
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

  def download_image(url, destination)
    uri = URI.parse(url)

    # Fetch the image from the URL using Net::HTTP and read its content
    image_data = Net::HTTP.get_response(uri).body

    # Save the image data to the destination file
    File.open(destination, 'wb') { |file| file.write(image_data) }
  end
end
