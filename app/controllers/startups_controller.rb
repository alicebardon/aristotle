class StartupsController < ApplicationController
  require 'net/http'
  require 'uri'
  require 'zip'

  API_KEY = "2a28d17c7d25458a32690f9869580391"

  def index
    @startups = fetch_multiple_startups
  end

  def download_logos
    # Replace the URL with the actual Crunchbase logo URL you want to download
    logo_url = 'https://images.crunchbase.com/image/upload/c_lpad,f_auto,q_auto:eco,dpr_1/pgylhyxgfqueumssu8lq'

    # Specify the destination filename for the downloaded image
    image_filename = 'logo.jpg'

    # Specify the filename for the zip file
    zip_filename = 'logo.zip'

    # Use URI.parse to get the actual image URL (follow redirects if any)
    actual_image_url = URI.parse(logo_url).to_s

    # Download the image from the URL and save it to the destination file
    download_image(actual_image_url, image_filename)

    # Create a zip file and add the downloaded image to it
    create_zip_file(image_filename, zip_filename)

    puts "Logo downloaded and saved to #{zip_filename}"

  end



  ###### PRIVATE METHODS ######

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

  def download_image(url, destination)
    uri = URI.parse(url)

    # Fetch the image from the URL using Net::HTTP and read its content
    image_data = Net::HTTP.get_response(uri).body

    # Save the image data to the destination file
    File.open(destination, 'wb') { |file| file.write(image_data) }
  end

  def create_zip_file(source_file, zip_file_name)
    # Create a new zip file
    Zip::ZipOutputStream.open(zip_file_name) do |zipfile|
      # Add the image file to the zip file
      zipfile.put_next_entry(File.basename(source_file))
      File.open(source_file, 'rb') { |file| zipfile.write(file.read) }
    end
  end

end
