#!/usr/bin/env ruby
# frozen_string_literal: true

require "jekyll"
require_relative "../_plugins/responsive_media_embeds"

source_files = Dir.glob(File.expand_path("../{_posts,_pages}/**/*.{md,markdown,html}", __dir__))
urls = source_files.flat_map do |path|
  File.read(path).scan(%r{^https?://(?:www\.)?flickr\.com/\S+$})
end.uniq

abort "No standalone Flickr URLs found" if urls.empty?

ENV.delete("JEKYLL_OFFLINE")
ResponsiveMediaEmbeds.refresh_flickr_cache(urls)
puts "Cached #{urls.length} Flickr URL#{urls.length == 1 ? '' : 's'}"
