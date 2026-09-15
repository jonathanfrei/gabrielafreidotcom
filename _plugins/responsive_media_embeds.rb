# frozen_string_literal: true

require "cgi"
require "fileutils"
require "json"
require "net/http"
require "uri"
require "time"

module ResponsiveMediaEmbeds
  STANDALONE_URL = /^\s*(https?:\/\/[^\s<>]+)\s*$/i
  YOUTUBE_ID = /\A[A-Za-z0-9_-]{11}\z/
  FLICKR_CACHE_PATH = File.expand_path("../_data/flickr_cache.json", __dir__)
  FLICKR_CACHE_TTL = 86_400

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
      flickr_embed(url)
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

  def flickr_embed(url)
    cached = flickr_cache.fetch(url, nil)
    return wrap_flickr(cached["html"]) if cache_fresh?(cached)

    embed_html = fetch_flickr_html(url)
    if embed_html
      flickr_cache[url] = { "fetched_at" => Time.now.utc.iso8601, "html" => embed_html }
      write_flickr_cache
      return wrap_flickr(embed_html)
    end

    wrap_flickr(cached && cached["html"])
  end

  def fetch_flickr_html(url)
    return if ENV["JEKYLL_OFFLINE"] == "true"

    endpoint = URI("https://www.flickr.com/services/oembed/")
    endpoint.query = URI.encode_www_form(format: "json", url: url)
    response = Net::HTTP.start(
      endpoint.host,
      endpoint.port,
      use_ssl: true,
      open_timeout: 5,
      read_timeout: 10
    ) { |http| http.get(endpoint.request_uri) }
    return unless response.is_a?(Net::HTTPSuccess)

    html = JSON.parse(response.body)["html"]
    html unless html.to_s.empty?
  rescue JSON::ParserError, Net::OpenTimeout, Net::ReadTimeout, SocketError
    nil
  end

  def flickr_cache
    @flickr_cache ||= JSON.parse(File.read(FLICKR_CACHE_PATH))
  rescue Errno::ENOENT, JSON::ParserError
    @flickr_cache = {}
  end

  def cache_fresh?(entry, now: Time.now)
    return false unless entry.is_a?(Hash) && !entry["html"].to_s.empty?

    now - Time.iso8601(entry.fetch("fetched_at")) < FLICKR_CACHE_TTL
  rescue KeyError, ArgumentError
    false
  end

  def write_flickr_cache
    FileUtils.mkdir_p(File.dirname(FLICKR_CACHE_PATH))
    File.write(FLICKR_CACHE_PATH, JSON.pretty_generate(flickr_cache) << "\n")
  rescue SystemCallError
    nil
  end

  def wrap_flickr(html)
    return if html.to_s.empty?

    %(<div class="media-embed media-embed--flickr">\n#{html}\n</div>\n)
  end
  def refresh_flickr_cache(urls)
    urls.each do |url|
      html = fetch_flickr_html(url)
      next unless html

      flickr_cache[url] = { "fetched_at" => Time.now.utc.iso8601, "html" => html }
    end
    write_flickr_cache
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
