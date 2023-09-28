require 'down'
require 'fileutils'
require 'json'
require 'net/http'

shopsEndpoint = 'https://openapi.etsy.com/v3/application/shops'
listingsEndpoint = 'https://openapi.etsy.com/v3/application/listings'

apiKey = 'YOUR_API_KEY'
shopID = 'YOUR_SHOP_ID'
offset = ARGV[0]
stopChar = '|'
header = {'x-api-key': apiKey}

imagesOutput = './images/posts'
postsOutput = './_posts'
FileUtils.mkdir_p imagesOutput
FileUtils.mkdir_p postsOutput

listing_url = "#{shopsEndpoint}/#{shopID}/listings/active"\
			  "?method=GET"\
			  "&api_key=#{apiKey}"\
			  "&limit=100"\
			  "&offset=#{offset}"
listing_uri = URI(listing_url)
listing_response = Net::HTTP.get(listing_uri, header)
listing_parsed = JSON.parse(listing_response)

listing_info = listing_parsed["results"].each do |listing|

	fullTitle = listing["title"]
	shortTitle = fullTitle.split("#{stopChar}")[0]
	slug = shortTitle.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')

	File.open("#{postsOutput}/#{slug}.md", 'w') do |file|

		file.puts "---"
		file.puts "title: '#{shortTitle}'"
		file.puts "full-title: '#{fullTitle}'"
		file.puts "listing_id: #{listing["listing_id"]}"
		file.puts "etsy_url: #{listing["url"]}"
		file.puts "section_id: #{listing["shop_section_id"]}"
		file.puts "price: #{listing["price"]}"
		file.puts "tags: #{listing["tags"]}"

		image_url = "#{listingsEndpoint}/#{listing["listing_id"]}/images"\
					"?method=GET"\
					"&api_key=#{apiKey}"\
					"&rateLimit=100"\
					"&offset=#{offset}"
		image_uri = URI(image_url)
		image_response = Net::HTTP.get(image_uri, header)
		image_parsed = JSON.parse(image_response)

		count = 0
		image_parsed["results"].each do |image|

			Down.download(
				image["url_fullxfull"], 
				destination: "#{imagesOutput}/#{listing["listing_id"]}_full_#{count}.jpg"
			)

			Down.download(
				image["url_570xN"], 
				destination: "#{imagesOutput}/#{listing["listing_id"]}_medium_#{count}.jpg"
			)

			Down.download(
				image["url_75x75"], 
				destination: "#{imagesOutput}/#{listing["listing_id"]}_thumbnail_#{count}.jpg"
			)

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
