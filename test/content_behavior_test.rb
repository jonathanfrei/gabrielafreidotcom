# frozen_string_literal: true

require "jekyll"
require_relative "../_plugins/responsive_media_embeds"

def assert(condition, message)
  abort(message) unless condition
end

youtube = ResponsiveMediaEmbeds.transform("https://youtu.be/dQw4w9WgXcQ\n")
soundcloud = ResponsiveMediaEmbeds.transform("https://soundcloud.com/artist/track\n")
vimeo = ResponsiveMediaEmbeds.transform("https://vimeo.com/76979871\n")
flickr = ResponsiveMediaEmbeds.transform("https://www.flickr.com/photos/bees/155761353\n")
inline_link = ResponsiveMediaEmbeds.transform("Listen at https://youtu.be/dQw4w9WgXcQ today.\n")

assert(youtube.include?("youtube-nocookie.com/embed/dQw4w9WgXcQ"), "YouTube embed conversion failed")
assert(soundcloud.include?("w.soundcloud.com/player/"), "SoundCloud embed conversion failed")
assert(vimeo.include?("player.vimeo.com/video/76979871"), "Vimeo embed conversion failed")
assert(flickr.include?("embedr.flickr.com/photos/bees/155761353"), "Flickr embed conversion failed")
assert(inline_link == "Listen at https://youtu.be/dQw4w9WgXcQ today.\n", "Inline media link was changed")

site = Jekyll::Site.new(Jekyll.configuration)
site.read

page_urls = site.collections.fetch("pages").docs.map(&:url)
assert((["/welcome", "/on-demand"] - page_urls).empty?, "Collection page permalink check failed")

post = site.posts.docs.find { |document| document.basename_without_ext.include?("come-what-may") }
expected_post_url = "/2013/04/15/come-what-may-duet-with-paul-todd-jr"
assert(post&.url == expected_post_url, "Post permalink check failed: #{post&.url}")

home = site.pages.find { |page| page.name == "index.md" }
assert(home&.url == "/", "Home permalink check failed: #{home&.url}")

puts "Content behavior checks passed"
