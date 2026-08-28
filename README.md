# Gabriela Frei

A lightweight, responsive Jekyll site for Gabriela Frei’s music, events, reflections, and archive. The custom theme uses semantic HTML, modern CSS, and a small amount of vanilla JavaScript; no client-side framework is required.

## Local development

Prerequisites: Ruby 3.3 and Bundler.

```sh
bundle install
bundle exec ruby script/jekyll.rb serve
```

Open <http://localhost:4000>. Run the build and content checks with:

```sh
bundle exec ruby test/content_behavior_test.rb
bundle exec ruby script/jekyll.rb build
```

## Site configuration

Global settings, navigation links, social URLs, and home hero copy live in `_config.yml`. Restart the local server after changing that file. Reusable brand colors, fonts, shadows, and spacing are in `_sass/_tokens.scss`; the primary brand color is `#970c00`.

### Add an event

Create `_events/YYYY-MM-DD-name.md`:

```yaml
---
title: Acoustic Evening
event_date: 2026-10-15 19:30:00 -0400
location: Naples, FL
venue: Event venue
ticket_url: https://example.com/tickets
free_entry: false
sold_out: false
---

Optional event description.
```

The Events page automatically separates upcoming and past dates at build time.

### Add a release

Create `_discography/release-name.md`:

```yaml
---
title: Release title
release_year: 2026
description: A short summary.
cover_image: /assets/images/albums/release.jpg
spotify_url: https://open.spotify.com/...
apple_music_url: https://music.apple.com/...
tracks:
  - title: First song
    duration: "4:15"
---

Longer release notes.
```

Use optimized local WebP or AVIF images where possible and include useful alternative text.

## Theme behavior

- Responsive navigation becomes a keyboard-accessible menu below 760px.
- The color theme follows the device preference by default and persists a manual choice.
- Images in long-form content open in a native dialog lightbox.
- Release track lists use an accessible accordion.
- YouTube, Vimeo, SoundCloud, and Flickr URLs in migrated posts are converted to responsive embeds.

## Deployment

Pushes and pull requests targeting `main` are built and tested by `.github/workflows/jekyll.yml`. Pushes to `main` deploy through GitHub Pages. In **Settings → Pages**, set **Source** to **GitHub Actions**.
