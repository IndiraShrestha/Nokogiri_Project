require './nokogiri.rb'

#process text file into a hash of scholarship info
file = load_file(filename)

#we used the get_web_info(file)
file_info = get_web_info(file)

#Print the information to a text file in .csv format.
new_file = File.open("Output.txt", 'w') do |file|
  file.write("Record_ID\tScholarship Name\t" +
    "URL\tPage_Response\t" + "\tPage_Title\t" +
    "Scholarship_Text_Search\tError_Text \n")
  file_info.each do |record_id, record|
    file.write("#{record_id}\t#{record[:scholarship_name]}\t" +
      "#{record[:url]}\t#{record[:response]}\t" + " ...... " +
      "#{record[:search_result_for_scholarship]}\t#{record[:error]} \n")
  end
end
