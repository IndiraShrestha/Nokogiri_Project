# external links and files
require'rubygems'
require 'nokogiri'
require 'open-uri'
require 'pry'
require 'csv'

url = "http://www.rspfunding.com/cart/cart/3673719.html"

begin 
  file = open(url)
  doc = Nokogiri::HTML(file) do
    #do somet
  end
rescue Exception => e
  puts e # Error message
  puts e.io.status # Http Error code
  puts e.io.readlines # Http response body
end  