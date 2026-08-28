# frozen_string_literal: true

require "jekyll"
require_relative "../_plugins/responsive_media_embeds"
require "tmpdir"

def assert(condition, message)
  abort(message) unless condition
end

youtube = ResponsiveMediaEmbeds.transform("https://youtu.be/dQw4w9WgXcQ\n")
soundcloud = ResponsiveMediaEmbeds.transform("https://soundcloud.com/artist/track\n")
vimeo = ResponsiveMediaEmbeds.transform("https://vimeo.com/76979871\n")
flickr = ResponsiveMediaEmbeds.transform("https://www.flickr.com/photos/bees/155761353\n")
flickr_album_url = "https://www.flickr.com/photos/42651221@N07/albums/72157622468792653"
flickr_album = ResponsiveMediaEmbeds.transform("#{flickr_album_url}\n")
inline_link = ResponsiveMediaEmbeds.transform("Listen at https://youtu.be/dQw4w9WgXcQ today.\n")

assert(youtube.include?("youtube-nocookie.com/embed/dQw4w9WgXcQ"), "YouTube embed conversion failed")
assert(soundcloud.include?("w.soundcloud.com/player/"), "SoundCloud embed conversion failed")
assert(vimeo.include?("player.vimeo.com/video/76979871"), "Vimeo embed conversion failed")
assert(flickr.include?("data-flickr-embed"), "Flickr photo embed conversion failed")
assert(flickr_album.include?("data-flickr-embed"), "Flickr album embed conversion failed")
assert(inline_link == "Listen at https://youtu.be/dQw4w9WgXcQ today.\n", "Inline media link was changed")

Dir.mktmpdir("gabrielafrei-jekyll-test") do |destination|
  configuration = Jekyll.configuration(
    "destination" => destination,
    "quiet" => true
  )
  site = Jekyll::Site.new(configuration)
  site.process

  page_urls = site.collections.fetch("pages").docs.map(&:url)
  assert((["/welcome", "/on-demand"] - page_urls).empty?, "Collection page permalink check failed")

  post = site.posts.docs.find { |document| document.basename_without_ext.include?("come-what-may") }
  expected_post_url = "/2013/04/15/come-what-may-duet-with-paul-todd-jr"
  assert(post&.url == expected_post_url, "Post permalink check failed: #{post&.url}")

  home = site.pages.find { |page| page.name == "index.md" }
  assert(home&.url == "/", "Home permalink check failed: #{home&.url}")

  peace_post = site.posts.docs.find { |document| document.basename_without_ext.include?("peace-in-jesus") }
  peace_html = File.read(peace_post.destination(destination))
  assert(peace_html.include?("youtube-nocookie.com/embed/agLnWHrh3k8"), "YouTube post did not render an embed")
  assert(!peace_html.include?("<p>https://www.youtube.com/watch"), "YouTube URL remained visible")

  love_post = site.posts.docs.find { |document| document.basename_without_ext.include?("l-o-v-e-live") }
  love_html = File.read(love_post.destination(destination))
  assert(love_html.include?("player.vimeo.com/video/7000100"), "Vimeo post did not render an embed")
  assert(!love_html.include?("<p>https://vimeo.com/7000100</p>"), "Vimeo URL remained visible")

  performances_post = site.posts.docs.find { |document| document.basename_without_ext.include?("performances") }
  performances_html = File.read(performances_post.destination(destination))
  assert(performances_html.include?("data-flickr-embed"), "Flickr gallery did not render an embed")
  assert(!performances_html.include?("<p>#{flickr_album_url}</p>"), "Flickr gallery URL remained visible")

  stylesheet = File.read(File.join(destination, "assets", "main.css"))
  assert(stylesheet.include?(".media-embed--video"), "Responsive embed CSS was not compiled")
  assert(stylesheet.match?(/aspect-ratio:\s*16\s*\/\s*9/), "Responsive video aspect ratio was not compiled")
  root_pages = {
    "music.md" => "/music",
    "events.md" => "/events",
    "about.md" => "/about",
    "journal.md" => "/journal"
  }
  root_pages.each do |name, expected_url|
    generated_page = site.pages.find { |page| page.name == name }
    assert(generated_page&.url == expected_url, "#{name} URL should be #{expected_url}, got #{generated_page&.url}")
  end
  %w[index.html music.html events.html about.html journal.html].each do |path|
    assert(File.exist?(File.join(destination, path)), "Expected generated page is missing: #{path}")
  end
  home_html = File.read(File.join(destination, "index.html"))
  assert(home_html.include?("Songs from the heart, offered with grace."), "New home hero was not rendered")
  assert(home_html.include?('aria-label="Main navigation"'), "Accessible navigation was not rendered")
  assert(home_html.include?('class="theme-toggle"'), "Theme control was not rendered")
  assert(site.collections.fetch("events").docs.any?, "Events collection is empty")
  assert(site.collections.fetch("discography").docs.any?, "Discography collection is empty")
  assert(site.collections.fetch("events").docs.all? { |event| event.url.start_with?("/appearances/") }, "Event detail URLs conflict with /events")
  assert(site.collections.fetch("discography").docs.all? { |release| release.url.start_with?("/releases/") }, "Release detail URLs conflict with /music")
end

puts "Content behavior checks passed"
