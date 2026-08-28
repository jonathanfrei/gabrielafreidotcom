# frozen_string_literal: true

# The github-pages gem does not reliably auto-load local `_plugins` files.
# Load the media transform explicitly before handing control to Jekyll's CLI.
require "jekyll"
require_relative "../_plugins/responsive_media_embeds"

load Gem.bin_path("jekyll", "jekyll")
