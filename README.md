# Simple Etsy listings to YAML Ruby script

This is a really simple Ruby script to get the details of all the listings in an Etsy store and save it as a YAML file. I'm sure there's a much better way to do this, but it works for me.

## How to use

You need Ruby installed on your computer for this

Go to https://www.etsy.com/developers/ and create a new app.

In the script file, replace YOUR_API_KEY with your app's keystring, and YOUR_SHOP_ID with the id of the shop you want to get the listings for.

cd to the script file in Terminal and run it by typing 'ruby etsy-listings.rb'

It'll think for a bit and then save a 'listings.yaml' file in the same folder, perfect for using in Jekyll or other system of your choice.
