# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

require 'open-uri'

# Format day
def day_string_to_index(string)
  case string
    when 'Sun'
      return 0
    when 'Mon'
      return 1
    when 'Tue'
      return 2
    when 'Wed'
      return 3
    when 'Thu'
      return 4
    when 'Fri'
      return 5
    when 'Sat'
      return 6
    else
      return 8
  end
end

def tjf_club_url(club_name)
  basic_url = "http://www.jitsufoundation.org/Jiujitsu.asp?page=jujitsu_club&clubid="
  return basic_url + club_name.gsub!(/\s/,'_')
end

# Source and store data:
club_location_doc = Nokogiri::XML(File.open("config/club_location.xml")) do |config|
  config.options = Nokogiri::XML::ParseOptions::STRICT | Nokogiri::XML::ParseOptions::NONET
end

london_region_url = "http://www.jitsufoundation.org/Jiujitsu.asp?Page=jujitsu&region=London"

london_region_doc = Nokogiri::HTML(open(london_region_url))

# Delete the current rows from the tables:
Club.delete_all
Event.delete_all

# Populate the club table:
club_location_doc.css("marker").each do |response_node|
  Club.create(name: response_node["label"], website: tjf_club_url(response_node["label"]), location_lat: response_node["lat"], location_lng: response_node["lng"], postcode: response_node["Postcode"])
end

# Experiments with storing session data:

club_url.each do |html_link|
  club_page_doc = Nokogiri::HTML(open(html_link))

  # Get the name of the club
  name_node = club_page_doc.at_css("title").to_s

  titlebox_node = club_page_doc.css("#titlebox2").last
  strong_node = titlebox_node.css("strong")

  strong_node.each do |session_node|
    session_node = session_node.to_s
    day_of_week = session_node[/(?<=<strong>)[a-zA-Z]{3}/]
    start_time = session_node[/(?<=,\s)\d{2}:\d{2}/]
    end_time = session_node[/(?<=\-\s)\d{2}:\d{2}/]
    club_name = name_node[/(?<=\-\s)(.*)Club/]

    # Populate the club table:
    Event.create(title: club_name, description: day_string_to_index(day_of_week), start_time: start_time, end_time: end_time)
  end
end
