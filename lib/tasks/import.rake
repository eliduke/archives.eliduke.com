namespace :import do
  desc "Import POSTS from the /lib/posts.json file"
  task posts: [:environment] do
    file = File.open(Dir.pwd + "/lib/posts.json")
    posts = JSON.load(file)

    file.close

    posts.each do |post|
      new_post = Post.create!(
        title: post["title"] || post["media"][0]["title"],
        created: post["creation_timestamp"] || post["media"][0]["creation_timestamp"],
        element_count: post["media"].size
      )

      post["media"].each do |m|
        print "."
        metadata = if m["media_metadata"]["photo_metadata"].to_s.include?("latitude")
          m["media_metadata"]["photo_metadata"]["exif_data"].first
        elsif m["media_metadata"]["video_metadata"].to_s.include?("latitude")
          m["media_metadata"]["video_metadata"]["exif_data"].first
        else
          {}
        end

        new_post.elements.create!(
          title: m["title"],
          uri: m["uri"],
          created: m["creation_timestamp"],
          latitude: metadata["latitude"],
          longitude: metadata["longitude"]
        )
      end
    end
  end
end
