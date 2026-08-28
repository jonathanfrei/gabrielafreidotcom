# frozen_string_literal: true

require "cgi"
require "uri"

module ResponsiveMediaEmbeds
  STANDALONE_URL = /^\s*(https?:\/\/[^\s<>]+)\s*$/i
  YOUTUBE_ID = /\A[A-Za-z0-9_-]{11}\z/

  module_function

  def transform(content)
    content.each_line.map do |line|
      match = line.match(STANDALONE_URL)
      match ? embed_for(match[1]) || line : line
    end.join
  end

  def embed_for(url)
    uri = URI.parse(url)
    host = uri.host.to_s.downcase.sub(/\Awww\./, "")

    case host
    when "youtu.be", "youtube.com", "m.youtube.com"
      youtube_embed(uri, host)
    when "vimeo.com", "player.vimeo.com"
      vimeo_embed(uri)
    when "soundcloud.com", "m.soundcloud.com"
      soundcloud_embed(url)
    when "flickr.com", "m.flickr.com"
      flickr_embed(uri)
    end
  rescue URI::InvalidURIError
    nil
  end

  def youtube_embed(uri, host)
    video_id = if host == "youtu.be"
                 uri.path.split("/").reject(&:empty?).first
               elsif uri.path == "/watch"
                 CGI.parse(uri.query.to_s).fetch("v", []).first
               else
                 segments = uri.path.split("/").reject(&:empty?)
                 segments[1] if %w[embed shorts live].include?(segments[0])
               end

    return unless video_id&.match?(YOUTUBE_ID)

    <<~HTML
      <div class="media-embed media-embed--video">
        <iframe src="https://www.youtube-nocookie.com/embed/#{video_id}" title="YouTube video player" loading="lazy" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
      </div>
    HTML
  end

  def soundcloud_embed(url)
    encoded_url = CGI.escape(url)
    <<~HTML
      <div class="media-embed media-embed--soundcloud">
        <iframe src="https://w.soundcloud.com/player/?url=#{encoded_url}&amp;color=%23000000&amp;auto_play=false&amp;hide_related=false&amp;show_comments=true&amp;show_user=true&amp;show_reposts=false&amp;visual=false" title="SoundCloud audio player" loading="lazy" allow="autoplay"></iframe>
      </div>
    HTML
  end

  def vimeo_embed(uri)
    segments = uri.path.split("/").reject(&:empty?)
    video_id = segments.reverse.find { |segment| segment.match?(/\A\d+\z/) }
    return unless video_id

    <<~HTML
      <div class="media-embed media-embed--video">
        <iframe src="https://player.vimeo.com/video/#{video_id}?dnt=1" title="Vimeo video player" loading="lazy" allow="autoplay; fullscreen; picture-in-picture" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
      </div>
    HTML
  end

  def flickr_embed(uri)
    match = uri.path.match(%r{\A/photos/([A-Za-z0-9@_-]+)/(\d+)/?\z})
    return unless match

    user_id, photo_id = match.captures
    <<~HTML
      <div class="media-embed media-embed--flickr">
        <iframe src="https://embedr.flickr.com/photos/#{user_id}/#{photo_id}" title="Flickr photo" loading="lazy" allowfullscreen></iframe>
      </div>
    HTML
  end
end

Jekyll::Hooks.register :documents, :pre_render do |document|
  document.content = ResponsiveMediaEmbeds.transform(document.content)
end

Jekyll::Hooks.register :posts, :pre_render do |post|
  post.content = ResponsiveMediaEmbeds.transform(post.content)
end

Jekyll::Hooks.register :pages, :pre_render do |page|
  page.content = ResponsiveMediaEmbeds.transform(page.content)
end
