# external links and files
require'rubygems'
require 'nokogiri'
require 'open-uri'
require 'csv'

filename = "test_file.txt" #This is a small subset, because this script takes a long time.

#Take text file list of scholarships, return hash of scholarships (by id)
#with subhash of scholarship info.
def load_file(filename)
	#create a new empty hash to ....
	file_hash = Hash.new
	# this command will open a file ("r" is for read only option, there are other various options)
	# we will then loop through the file through each line
	File.open(filename, "r") do |f|
	  id = ""
	  #this command will loop through each line in the file (the whole file)
	  f.each_line do |line|
	  	#the line tag eg.<RN> has 4 character so the following code is going to first 4 character of the line 
	  	line_tag = line[0..3].to_s
	    if line_tag == "<RN>"
	    	line_s = line.to_s  #this will convert the line to a string as James choose to convert it into string. 
	    	id = line_s[4...line_s.index(' ')] #the <RN> tag has spaces in it's line so this will return from the 5th character till it reaches the space index
	    	file_hash[id] = Hash.new # it creates a empty subhash with key as the id,for example: file_hash = { 4728 = { }}; 

	    #note: could refactor to just take all fields by their tags. 
	    elsif line_tag == "<PT>"
	    	line_s = line.to_s.chomp # we use chomps as there was new line???
	    	scholarship = line_s[4..line_s.length] #using the same logic as in line 50, this will return the name of the scholarship. 
	    	file_hash[id][:scholarship_name] = scholarship #this will... ????? the id will be empty out here as the id it takes is from the line 43 right???
	    elsif line_tag == "<WW>"
	    	line_s = line.to_s.chomp #same as above (this will convert the line to a string as James choose to convert it into string)
	    	url = line_s[4..line_s.length] #from the 5th character to the end of the line which is received by line_s.length. 
	    	file_hash[id][:url] = url # this will .....?????
	    end
	  end
	end
	
	return file_hash #returns the hash 
end

#the purpose of the following code is to get the file info by passing in the txt file which will loop through the file_hash (as it's passed in the run_nokogiri.rb file)
#once it's looped through the file, it will attr_reader :attr_nameseturn 
def get_web_info(file) 
	file.each do |record_id, record|
		puts record_id
		record = get_record_info(record) #
		file[record_id] = record
	end

	return file
end

#this purpose of the following code is to ..... we pass in  as parameter that is the value ({:scholarship_name = "Grant", :url="www.scholarship.com"}) from key value pair of file_hash eg, file_hash = { 4728 = {:scholarship_name = "Grant", :url="www.scholarship.com"}}

def get_record_info(record)
	record = record #might not be necessary.
	#puts record
	url = record[:url] #www.scholarship.com
	scholarship = record[:scholarship_name] #Grant
	response = "Page Found"
	search_result = 0
	error = ""

	#Prepend "http://" so open method identifies as url
	if url[0..3] != "http"
		url = "http://" + url
	end
	
	#Could externalize for optimization?
	#Need to add error handling for "https" urls... ask about this one?????????????????????????????????
	begin
	  page = open(url).read

	rescue Exception => e
		response = "Error"
	  error = e # Error message
	  #error = e.io.status # Http Error code.  Doesn't seem to be working...
	  #puts e.io.readlines # Http response body
	end

	# *********************** To check for page that give "Page not found 404 error" **********************	
	# if the weblink doesn't raise any exception but give out "Page not found 404 error" page, we used nokogiri to get the title of the page and check if the title is includes "Page not found"
	#used the following tutorial/blog https://www.sitepoint.com/nokogiri-fundamentals-extract-html-web/
		# html_data = open('http://web.archive.org/web/20090220003702/http://www.sitepoint.com/').read
		nokogiri_object = Nokogiri::HTML(page)
		title_element = nokogiri_object.xpath("//title") #the title element is stored as an array

		title_element_text = title_element[0].text


	# *********************** To check if the scholarship name is mentioned in the webpage **********************		
	search_result_for_scholarship = page.scan(/\b#{scholarship}\b/i).length #Searches the html document for string, using regex to ignore case #scan looks for number of instances "Scholarship name is in the page" and return an array of it which is then .


	if search_result_for_scholarship > 0
  	search_result_for_scholarship = "Found"
  else
  	search_result_for_scholarship = "Not Found on Page"	
  end

  # adding new keys and values called response and response answer and so on
	record[:response] = response
	record[:title] = title_element_text
	record[:search_result_for_scholarship] = search_result_for_scholarship
	record[:error] = error

	return record

end





