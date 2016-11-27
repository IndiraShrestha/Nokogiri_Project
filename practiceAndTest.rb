# external links and files
require'rubygems'
require 'nokogiri'
require 'open-uri'
#require 'pry'
require 'csv'

# 1.) separate out the tags and create a hash with the record it(which is also an empty hash) and within the recored create a key and value of scholaship_name and url
# 2.) get the record info for each record and set the response, search_result, error which is found by scrapping the web 
#     a.) check if the url has http beginging and if not set the http in the url
#     b.) begin the scrapping 
#     c.) search_result and scan the page if the weblink has the name mentioned search_result = "found" and if not "Not found"
#     d.) set new key and value in the record by giving :response as key and it's result as value
#     e.) return record 
# 3.) get the weblink function which takes in the file_hash as parameter (file_hash={4728(aka record_id)={record}})
# loop through each record and the record is passed into the get the record info function
# the result is set in the record which in turn is set in the file_hash[:record_id] = record

#once these functions are set, we will then need to return the results in the csv file. 




# *********************** To test the Nokogiri section of the program ********************** 


page = open("https://medium.freecodecamp.com/5-key-learnings-from-the-post-bootcamp-job-search-9a07468d2331#.66hyw5ile").read
  nokogiri_object = Nokogiri::HTML(page)
  title_element = nokogiri_object.xpath("//title") #the title element is stored as an array

  title_element_text = title_element[0].text

  puts title_element_text

# *********************** End of the program ********************** 

