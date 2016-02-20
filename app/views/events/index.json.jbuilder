json.array!(@sessions) do |session|
  json.extract! session, :id, :title, :description
  json.start session.start_time
  json.end session.end_time
  json.dow session.day_of_week
  json.url session.club.tjfurl
end
