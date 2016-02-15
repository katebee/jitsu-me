# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

require 'open-uri'

# Source and store data:
club_location_doc = Nokogiri::XML(File.open("config/club_location.xml")) do |config|
  config.options = Nokogiri::XML::ParseOptions::STRICT | Nokogiri::XML::ParseOptions::NONET
end

london_region_url = "http://www.jitsufoundation.org/Jiujitsu.asp?Page=jujitsu&region=London"

london_region_doc = Nokogiri::HTML(open(london_region_url))

club_url_list = london_region_doc.css("div.RegionsClubs a.linkaaaaaa").map do |link|
  "http://www.jitsufoundation.org" + link["href"]
end

# Delete the current rows from the tables:
Club.delete_all
Event.delete_all

# Populate the club table:
club_location_doc.css("marker").each do |response_node|
  Club.create(name: response_node["label"], location_lat: response_node["lat"], location_lng: response_node["lng"], postcode: response_node["Postcode"])
end

# Experiments with storing session data:

club_url_list.each do |html_link|
  club_page_doc = Nokogiri::HTML(open(html_link))

  name_grab = club_page_doc.at_css("title").to_s
  titlebox_grab = club_page_doc.css("#titlebox2").last
  strong_grab = titlebox_grab.css("strong").to_s
  day_of_week = strong_grab[/(?<=<strong>)[a-zA-Z]{3}/]
  start_time = strong_grab[/(?<=,\s)\d{2}:\d{2}/]
  end_time = strong_grab[/(?<=\-\s)\d{2}:\d{2}/]
  club_name = name_grab[/(?<=\-\s)(.*)Club/]

  # Populate the club table:
  Event.create(title: club_name, description: day_of_week, start_time: start_time, end_time: end_time)

end
