require 'net/http'
require 'json'
 
apiKey = 'YOUR_API_KEY'
shopID = 'YOUR_SHOP_ID'

listing_url = "https://openapi.etsy.com/v2/shops/#{shopID}/listings/active?method=GET&api_key=#{apiKey}&limit=100"
listing_uri = URI(listing_url)

listing_response = Net::HTTP.get(listing_uri)
listing_parsed = JSON.parse(listing_response)

File.open('listings.yaml', 'w') do |file|
	file.puts "---"
	listing_info = listing_parsed["results"].each do |listing|
		file.puts "-"
		file.puts "  title: #{listing["title"]}"
		file.puts "  listing_id: #{listing["listing_id"]}"
		file.puts "  url: #{listing["url"]}"
		file.puts "  section_id: #{listing["shop_section_id"]}"
		file.puts "  price: #{listing["price"]}"
		file.puts "  tags: #{listing["tags"]}"

		image_url = "https://openapi.etsy.com/v2/listings/#{listing["listing_id"]}/images?method=GET&api_key=#{apiKey}&limit=100"
		image_uri = URI(image_url)

		image_response = Net::HTTP.get(image_uri)
		image_parsed = JSON.parse(image_response)

		image_parsed["results"].each do |image|
			file.puts "  image_570xN_url: #{image["url_570xN"]}"
			file.puts "  image_fullxfull_url: #{image["url_fullxfull"]}"
		end
	end
end
