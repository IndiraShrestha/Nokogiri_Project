# external links and files
require'rubygems'
require 'nokogiri'
require 'open-uri'
#require 'pry'
require 'csv'

#url = "http://www.medstartr.com/project/detail/833-360me"


# file = load_file("RSPWMN_OVMRGD_09-16-16.TXT")

# file.each do |record|
# 	page = open(record[:url]).read

# 	doc = Nokogiri::HTML(page)

# 	begin 
# 	  file = open(url)
# 	  doc = Nokogiri::HTML(file) do
# 	    #do somet
# 	  end
# 	rescue Exception => e
# 	  puts e # Error message
# 	  puts e.io.status # Http Error code
# 	  puts e.io.readlines # Http response body
# 	end 

# end


#filename = "RSPWMN_OVMRGD_09-16-16.TXT" 
filename = "test_file.TXT" #This is a small subset, because this script takes a long time.

#Take text file list of scholarships, return hash of scholarships (by id)
#with subhash of scholarship info.
def load_file(filename)
	file_hash = Hash.new
	File.open(filename, "r") do |f|
	  id = ""
	  f.each_line do |line|
	  	line_tag = line[0..3].to_s
	    if line_tag == "<RN>"
	    	line_s = line.to_s
	    	id = line_s[4...line_s.index(' ')]
	    	file_hash[id] = Hash.new

	    #note: could refactor to just take all fields by their tags. 
	    elsif line_tag == "<PT>"
	    	line_s = line.to_s.chomp
	    	scholarship = line_s[4..line_s.length]
	    	file_hash[id][:scholarship_name] = scholarship
	    elsif line_tag == "<WW>"
	    	line_s = line.to_s.chomp
	    	url = line_s[4..line_s.length]
	    	file_hash[id][:url] = url
	    end
	  end
	end
	
	return file_hash
end

def get_web_info(file)
	file.each do |record_id, record|
		puts record_id
		record = get_record_info(record)
		file[record_id] = record
	end

	return file
end

def get_record_info(record)
	record = record
	#puts record
	url = record[:url]
	scholarship = record[:scholarship]
	response = "Page Found"
	search_result = 0
	error = ""

	#Prepend "http://" so open method identifies as url
	if url[0..3] != "http"
		url = "http://" + url
	end
	
	#Could externalize for optimization?
	#Need to add error handling for "https" urls...
	begin
	  page = open(url).read

	  search_result = page.scan(/\b#{scholarship}\b/i).length #Searches the html document for string, using regex to ignore case.

	rescue Exception => e
		response = "Error"
	  error = e # Error message
	  #error = e.io.status # Http Error code.  Doesn't seem to be working...
	  #puts e.io.readlines # Http response body
	end

	if search_result > 0
  	search_result = "Found"
  else
  	search_result = "Not Found on Page"
  end

	record[:response] = response
	record[:search_result] = search_result
	record[:error] = error

	return record

end




#process text file into a hash of scholarship info
file = load_file(filename)

#process 
file_info = get_web_info(file)

#Print the information to a text file in .csv format.
new_file = File.open("Output.txt", 'w') do |file|
	file.write("Record_ID,Scholarship Name," +
		"URL,Page_Response," +
		"Scholarship_Text_Search,Error_Text \n")
	file_info.each do |record_id, record|
		file.write("#{record_id},#{record[:scholarship_name]}," +
			"#{record[:url]},#{record[:response]}," +
			"#{record[:search_result]},#{record[:error]} \n")
	end
end
