# Simple Etsy listings to YAML Ruby script

This is a really simple Ruby script to get the details of all the listings in an Etsy store and save it as a YAML file. I'm sure there's a much better way to do this, but it works for me.

## How to use

You need Ruby on your computer for this.

Go to https://www.etsy.com/developers/ and create a new app.

In the script file, replace YOUR_API_KEY with your app's keystring, and YOUR_SHOP_ID with the id of the shop you want to get the listings for. The Etsy API is rate limited, so change the rateLimit value to the number of listings in the shop.

cd to the script file in Terminal and run it by typing 'ruby etsy-listings.rb'

It'll think for a bit and then save a 'listings.yaml' file in the same folder.

## How it works

The script works in two stages. Firstly it gets all the data associated with a listing, then, as images are handled by Etsy separately, it looks up the image info for each.

Although the API call first returns all of the data associated with a listing, the script doesn't print everything - I only needed a few fields. If you need a field which currently isn't there, it's straightforward to add. 

Look at the listing API reference page https://www.etsy.com/developers/documentation/reference/listing#section_fields and pick your field. Then add a new line to the script, after line 23, like this:

...ruby
file.puts "  FIELD_TITLE: #{listing["FIELD"]}"
...

FIELD_TITLE is what you want to call the field in the YAML file. FIELD is the name of the Etsy field (they can have the same name). So, to print the description field, you'd write:

...ruby
file.puts "  description: #{listing["description"]}"
...

