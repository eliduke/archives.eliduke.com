namespace :import do
  desc "Import POSTS from the /lib/posts.json file"
  task posts: [ :environment ] do
    file = File.open(Dir.pwd + "/lib/posts.json")
    posts = JSON.load(file)

    file.close

    posts.each do |post|
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

      new_post = Post.create!(
        tipe: "post",
        title: post["title"] || post["media"][0]["title"],
        uri: post["media"][0]["uri"],
        created: post["creation_timestamp"] || post["media"][0]["creation_timestamp"],
        latitude: metadata["latitude"],
        longitude: metadata["longitude"],
        element_count: post["media"].size
      )

      # Post created!
      print "."

      # Skip unless there are multiple media for this Post
      next unless new_post.element_count > 1

      post["media"].drop(1).each do |m|
        print "."
        metadata = if m["media_metadata"]["photo_metadata"].to_s.include?("latitude")
          # Photo metadata for lat long
          m["media_metadata"]["photo_metadata"]["exif_data"].first
        elsif m["media_metadata"]["video_metadata"].to_s.include?("latitude")
          # Video metadata for lat long
          m["media_metadata"]["video_metadata"]["exif_data"].first
        else
          {} # Empty metadata to handle nil condition
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

  desc "Import STORIES from the /lib/stories.json file"
  task stories: [ :environment ] do
    file = File.open(Dir.pwd + "/lib/stories.json")
    stories = JSON.load(file)

    file.close

    stories["ig_stories"].each do |story|
      Post.create!(
        type: "story",
        title: story["title"],
        uri: story["uri"],
        created: story["creation_timestamp"]
      )
    end
  end
end
