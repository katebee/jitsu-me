# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

require 'open-uri'

# Delete the current rows from the tables:
Club.delete_all
Session.delete_all

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

def get_club_sessions(html_link, club_id)
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
    Session.create(title: club_name, club_id: club_id, day_of_week: day_string_to_index(day_of_week), start_time: start_time, end_time: end_time)
  end
end

# Source and store data:
club_location_doc = Nokogiri::XML(File.open("config/club_location.xml")) do |config|
  config.options = Nokogiri::XML::ParseOptions::STRICT | Nokogiri::XML::ParseOptions::NONET
end

london_region_url = "http://www.jitsufoundation.org/Jiujitsu.asp?Page=jujitsu&region=London"
london_region_doc = Nokogiri::HTML(open(london_region_url))

london_clubs = london_region_doc.css("div.RegionsClubs a.linkaaaaaa").map do |link|
  "http://www.jitsufoundation.org" + link["href"]
end

# Populate the club and session tables:
london_clubs.each do |tjf_club_url|

  club_page_doc = Nokogiri::HTML(open(tjf_club_url))

  name_node = club_page_doc.at_css("title").to_s
  club_name = name_node[/(?<=\-\s)(.*)Club/]

  club = Club.create(name: club_name, tjfurl: tjf_club_url)

  titlebox_node = club_page_doc.css("#titlebox2").last
  strong_node = titlebox_node.css("strong")

  strong_node.each do |session_node|
    session_node = session_node.to_s
    day_of_week = session_node[/(?<=<strong>)[a-zA-Z]{3}/]
    start_time = session_node[/(?<=,\s)\d{2}:\d{2}/]
    end_time = session_node[/(?<=\-\s)\d{2}:\d{2}/]

    Session.create(title: club.name, club_id: club.id, day_of_week: day_string_to_index(day_of_week), start_time: start_time, end_time: end_time)
  end
end
