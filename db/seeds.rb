# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

xml = Nokogiri::XML(File.open("config/club_location.xml")) do |config|
  config.options = Nokogiri::XML::ParseOptions::STRICT | Nokogiri::XML::ParseOptions::NONET
end

Club.delete_all

xml.css("marker").each do |response_node|
  Club.create(name: response_node["label"], location_lat: response_node["lat"], location_lng: response_node["lng"], postcode: response_node["Postcode"])
end
