require 'json'

file = File.open(Dir.pwd + "/json/posts.json")
posts = JSON.load(file)

file.close

posts.each do |post|
  time = post["creation_timestamp"] || post["media"][0]["creation_timestamp"]
  title = post["title"] || post["media"][0]["title"]
  medias = "- #{post['media'][0]['uri']}"

  post["media"].drop(1).each do |media|
    medias += "\n- #{media['uri']}"
  end

  File.open("_grams/#{time}.md", "w") do |f|
    f.write(
    <<~EOS
    ---
    layout: gram
    time: #{time}
    caption: #{title.inspect}
    media:
    #{medias}
    ---
    EOS
    )
  end

  print "."
end
