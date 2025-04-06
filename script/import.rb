require 'json'

file = File.open(Dir.pwd + "/lib/posts.json")
posts = JSON.load(file)

posts.each do |post|
  # puts "*" * 100
  # puts post["title"]
  # puts post["creation_timestamp"]
  # post["media"].each do |m|
  #   puts m["creation_timestamp"]
  #   puts m["title"]
  #   puts m["uri"]
  # end

  post = Post.create!(
    title: post["title"],
    created: post["creation_timestamp"]
  )

  post["media"].each do |m|
    post.elements.create!(
      title: m["title"],
      uri: m["uri"],
      created: m["creation_timestamp"],
    )
  end
end
