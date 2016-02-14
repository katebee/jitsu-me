# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

require 'open-uri'

# Source and store data:
clubxml = Nokogiri::XML(File.open("config/club_location.xml")) do |config|
  config.options = Nokogiri::XML::ParseOptions::STRICT | Nokogiri::XML::ParseOptions::NONET
end

sessionxml = Nokogiri::HTML(open("http://www.jitsufoundation.org/Jiujitsu.asp?page=jujitsu_club&clubid=Wandsworth_Jitsu_Club"))

# Delete the current rows from the tables:
Club.delete_all
Event.delete_all

# Populate the club table:
clubxml.css("marker").each do |response_node|
  Club.create(name: response_node["label"], location_lat: response_node["lat"], location_lng: response_node["lng"], postcode: response_node["Postcode"])
end

# Experiments with storing session data:
titlebox_grab = sessionxml.css("#titlebox2").last
strong_grab = titlebox_grab.css("strong").to_s
day_of_week = strong_grab[/(?<=<strong>)[a-zA-Z]{3}/]
start_time = strong_grab[/(?<=,\s)\d{2}:\d{2}/]
end_time = strong_grab[/(?<=\-\s)\d{2}:\d{2}/]

# Populate the club table:
Event.create(title: "Demo Event 1", description: day_of_week, start_time: start_time, end_time: end_time)
Event.create(title: "Demo Event 2", description: day_of_week, start_time: start_time, end_time: end_time)
Event.create(title: "Demo Event 3", description: day_of_week, start_time: start_time, end_time: end_time)
