# [
#   {
#     tweet: {
#     id: "1828991784942481441",
#     in_reply_to_status_id: "1747378284911092181",
#     created_at: "Thu Aug 29 03:03:17 +0000 2024",
#     full_text: "https://t.co/tsTi7nSdyt",
#     extended_entities: {
#       media: [{
#         media_url: "http://pbs.twimg.com/media/GWHiU2IbgAAgner.jpg",
#         type: "photo"
#       }]
#     }
#   },{
#     tweet: {...}
#   }
# ]

require 'json'

file = File.open(Dir.pwd + "/json/tweets-shitfannysays.json")

# To get symbolized names, I had to set create_additions to false to avoid conflict?
posts = JSON.load(file, nil, symbolize_names: true, create_additions: false)

file.close

posts.each do |post|
  tweet = post[:tweet]

  puts "id: #{tweet[:id]}"
  puts "relpy_id: #{tweet[:in_reply_to_status_id]}"
  puts "created_at: #{tweet[:created_at]}"
  puts "full_text: #{tweet[:full_text]}"
  puts "#" * 100
end
