# The instagram json data export is truly terrible, and I want to make a note here
# for my future self so that this importer makes sense to me years from now.
#
# The posts.json file dump is a root-level array of hashes, with each hash containing
# one "media" array. The "media" array contains each media element (image or video) for
# that specific instagram post. The truly wacky part is that if there is only one media
# element for that post, the title and timestamp keys are within that first element
# in media array. If there are many media elements, the title and timestamp are outside
# the media array at the root of the parent hash. Bonkers.
#
# {
#   "media": [{
#     "uri": "media/posts/202006/123...",
#     "creation_timestamp": 1591648539,
#     "title": "Nonsense title for examples..."
#   }]
# },{
#   "media": [
#     {"uri": "media/posts/202005/345..."},
#     {"uri": "media/posts/202005/456..."}
#   ],
#   "title": "So I am just making this shit up...",
#   "creation_timestamp": 1590270160
# }
#
# And, on top of that shit, the metadata key for each media elemint is different
# for photos and videos: 'photo_metadata' vs 'video_metadata'. Absolutely unhinged.

require 'json'

file = File.open(Dir.pwd + "/json/posts.json")
# To get symbolized names, I had to set create_additions to false to avoid conflict?
posts = JSON.load(file, nil, symbolize_names: true, create_additions: false)

file.close

posts.each do |post|
  first_media = post[:media][0]
  time = post[:creation_timestamp] || first_media[:creation_timestamp]
  title = post[:title] || first_media[:title]

  media_links = "- #{first_media[:uri]}"
  post[:media].drop(1).each do |media|
    media_links += "\n- #{media[:uri]}"
  end

  media_metadata = first_media[:media_metadata]
  metadata = if media_metadata[:photo_metadata].to_s.include?("latitude")
    # Photo metadata with lat long
    media_metadata[:photo_metadata][:exif_data].first
  elsif media_metadata[:video_metadata].to_s.include?("latitude")
    # Video metadata with lat long
    media_metadata[:video_metadata][:exif_data].first
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
    latitude: #{metadata[:latitude]}
    longitude: #{metadata[:longitude]}
    media:
    #{media_links}
    ---
    EOS
    )
  end

  print "."
end
