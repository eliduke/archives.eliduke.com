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
