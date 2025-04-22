require 'json'

file = File.open(Dir.pwd + "/json/posts.json")
posts = JSON.load(file)

file.close

posts.each do |post|
  time = post["creation_timestamp"] || post["media"][0]["creation_timestamp"]
  title = post["title"] || post["media"][0]["title"]

  media_links = "- #{post['media'][0]['uri']}"
  post["media"].drop(1).each do |media|
    media_links += "\n- #{media['uri']}"
  end

  media_metadata = post["media"][0]["media_metadata"]
  metadata = if media_metadata["photo_metadata"].to_s.include?("latitude")
    # Photo metadata with lat long
    media_metadata["photo_metadata"]["exif_data"].first
  elsif media_metadata["video_metadata"].to_s.include?("latitude")
    # Video metadata with lat long
    media_metadata["video_metadata"]["exif_data"].first
  else
    {} # Empty metadata to handle nil condition
  end

  File.open("_grams/#{time}.md", "w") do |f|
    f.write(
    <<~EOS
    ---
    layout: gram
    time: #{time}
    caption: #{title.inspect}
    latitude: #{metadata['latitude']}
    longitude: #{metadata['longitude']}
    media:
    #{media_links}
    ---
    EOS
    )
  end

  print "."
end
