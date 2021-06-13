require 'net/http'
require 'open-uri'
require 'json'

apiKey = 'YOUR_API_KEY'
shopID = 'YOUR_SHOP_ID'
offset = ARGV[0]
stopChar = '|'


listing_url = "https://openapi.etsy.com/v2/shops/#{shopID}/listings/active?method=GET&api_key=#{apiKey}&limit=100&offset=#{offset}"
listing_uri = URI(listing_url)

listing_response = Net::HTTP.get(listing_uri)
listing_parsed = JSON.parse(listing_response)

listing_info = listing_parsed["results"].each do |listing|

	fullTitle = listing["title"]
	shortTitle = fullTitle.split("#{stopChar}")[0]
	slug = shortTitle.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')

	File.open("../_artwork/#{slug}.md", 'w') do |file|

		file.puts "---"
		file.puts "title: '#{shortTitle}'"
		file.puts "full-title: '#{fullTitle}'"
		file.puts "listing_id: #{listing["listing_id"]}"
		file.puts "etsy_url: #{listing["url"]}"
		file.puts "section_id: #{listing["shop_section_id"]}"
		file.puts "price: #{listing["price"]}"
		file.puts "tags: #{listing["tags"]}"

		image_url = "https://openapi.etsy.com/v2/listings/#{listing["listing_id"]}/images?method=GET&api_key=#{apiKey}&rateLimit=100&offset=#{offset}"
		image_uri = URI(image_url)

		image_response = Net::HTTP.get(image_uri)
		image_parsed = JSON.parse(image_response)

		count = 0
		image_parsed["results"].each do |image|

			open("#{image["url_fullxfull"]}") do |image|
			  File.open("../images/artwork/#{listing["listing_id"]}_full_#{count}.jpg", "wb") do |file|
			    file.write(image.read)
			  end
			end

			open("#{image["url_570xN"]}") do |image|
			  File.open("../images/artwork/#{listing["listing_id"]}_medium_#{count}.jpg", "wb") do |file|
			    file.write(image.read)
			  end
			end

			open("#{image["url_75x75"]}") do |image|
			  File.open("../images/artwork/#{listing["listing_id"]}_thumbnail_#{count}.jpg", "wb") do |file|
			    file.write(image.read)
			  end
			end


			file.puts "image_thumbnail_#{count}: #{listing["listing_id"]}_thumbnail_#{count}.jpg"
			file.puts "image_medium_#{count}: #{listing["listing_id"]}_medium_#{count}.jpg"
			file.puts "image_full_#{count}: #{listing["listing_id"]}_full_#{count}.jpg"
			count = count+1
		end

		file.puts "---"

		file.puts "#{listing["description"]}"

	end
	puts "#{slug}"
end
