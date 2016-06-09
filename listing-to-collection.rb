require 'net/http'
require 'json'
 
apiKey = 'YOUR_API_KEY'
shopID = 'YOUR_SHOP_ID'
rateLimit = '120'
stopChar = '|'

listing_url = "https://openapi.etsy.com/v2/shops/#{shopID}/listings/active?method=GET&api_key=#{apiKey}&limit=#{rateLimit}"
listing_uri = URI(listing_url)

listing_response = Net::HTTP.get(listing_uri)
listing_parsed = JSON.parse(listing_response)

listing_info = listing_parsed["results"].each do |listing|

	fullTitle = listing["title"]
	shortTitle = fullTitle.split("#{stopChar}")[0]
	slug = shortTitle.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')

	File.open("#{slug}.md", 'w') do |file|

		file.puts "---"
		file.puts "layout: product"
		file.puts "title: #{shortTitle}"
		file.puts "full-title: #{fullTitle}"
		file.puts "listing_id: #{listing["listing_id"]}"
		file.puts "etsy_url: #{listing["url"]}"
		file.puts "section_id: #{listing["shop_section_id"]}"
		file.puts "price: #{listing["price"]}"
		file.puts "tags: #{listing["tags"]}"

		image_url = "https://openapi.etsy.com/v2/listings/#{listing["listing_id"]}/images?method=GET&api_key=#{apiKey}&limit=#{rateLimit}"
		image_uri = URI(image_url)

		image_response = Net::HTTP.get(image_uri)
		image_parsed = JSON.parse(image_response)

		count = 0
		image_parsed["results"].each do |image|
			file.puts "image_75x75_url_#{count}: #{image["url_75x75"]}"
			file.puts "image_570xN_url_#{count}: #{image["url_570xN"]}"
			file.puts "image_fullxfull_url_#{count}: #{image["url_fullxfull"]}"
			count = count+1
		end

		file.puts "---"

		file.puts "#{listing["description"]}"

	end
end
