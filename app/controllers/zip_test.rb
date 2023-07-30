puts "Hey Zip!"

require 'net/http'
require 'uri'
require 'zip'

def download_image(url, destination)
  uri = URI.parse(url)

  # Fetch the image from the URL using Net::HTTP and read its content
  image_data = Net::HTTP.get_response(uri).body

  # Save the image data to the destination file
  File.open(destination, 'wb') { |file| file.write(image_data) }
end

def create_zip_file(source_file, zip_file_name)
  # Create a new zip file
  Zip::OutputStream.open(zip_file_name) do |zipfile|
    # Add the image file to the zip file
    zipfile.put_next_entry(File.basename(source_file))
    File.open(source_file, 'rb') { |file| zipfile.write(file.read) }
  end
end

# Replace the URL with the actual Crunchbase logo URL you want to download
logo_url = 'https://images.crunchbase.com/image/upload/c_lpad,f_auto,q_auto:eco,dpr_1/bomkrvppqn1pssoqsxqy'

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




### THIS WORKS ###
# require 'net/http'
# require 'uri'
# require 'zip'

# def download_image(url, destination)
#   uri = URI.parse(url)

#   # Fetch the image from the URL using Net::HTTP and read its content
#   image_data = Net::HTTP.get_response(uri).body

#   # Save the image data to the destination file
#   File.open(destination, 'wb') { |file| file.write(image_data) }
# end

# def create_zip_file(source_file, zip_file_name)
#   # Create a new zip file
#   Zip::File.open(zip_file_name, Zip::File::CREATE) do |zipfile|
#     # Add the image file to the zip file
#     zipfile.add(File.basename(source_file), source_file)
#   end
# end

# # Replace the URL with the actual Crunchbase logo URL you want to download
# logo_url = 'https://images.crunchbase.com/image/upload/c_lpad,f_auto,q_auto:eco,dpr_1/bomkrvppqn1pssoqsxqy'

# # Specify the destination filename for the downloaded image
# image_filename = 'logo.jpg'

# # Specify the filename for the zip file
# zip_filename = 'logo.zip'

# # Use URI.parse to get the actual image URL (follow redirects if any)
# actual_image_url = URI.parse(logo_url).to_s

# # Download the image from the URL and save it to the destination file
# download_image(actual_image_url, image_filename)

# # Create a zip file and add the downloaded image to it
# create_zip_file(image_filename, zip_filename)

# puts "Logo downloaded and saved to #{zip_filename}"
