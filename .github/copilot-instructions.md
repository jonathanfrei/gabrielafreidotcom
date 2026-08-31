# Copilot Instructions — Gabriela Frei (jekyll)

> Copied from `AGENTS.md:1` (canonical). If they diverge, AGENTS.md wins — open
> a PR to resync.

## Stack

Ruby 3.3 + `github-pages ~>232` → Jekyll 3.10.0, GH Pages. Theme: semantic HTML,
`_sass/_tokens.scss` (`#970c00`), `Playfair Display`/`Inter`, vanilla
`assets/js/site.js`. Plugin `_plugins/responsive_media_embeds.rb` converts
standalone YouTube/Vimeo/SoundCloud/Flickr lines → `.media-embed` at
`pre_render`.

## Commands

```sh
bundle install
bundle exec ruby script/jekyll.rb serve   # never `jekyll serve`
bundle exec ruby test/content_behavior_test.rb
bundle exec ruby script/jekyll.rb build
npm run lint && npm run format
```

## Where things live

- Config: `_config.yml` (nav, social.youtube, hero, collections `pages:/:path`,
  `events:/appearances/:name`, `discography:/releases/:name`)
- Styles: tokens `_sass/_tokens.scss`, bundle `assets/main.scss`
- Layouts: `_layouts/{default,home,page,post,event,release}.html`
- Content: `_discography/`, `_events/YYYY-MM-DD-*.md`, `_pages/`, `_posts/`,
  root `music.md`/`events.md`/`journal.md`/`about.md`

## Content schemas

- Event frontmatter:
  `title, event_date: "YYYY-MM-DD HH:MM:SS -0400", location, venue, ticket_url, free_entry, sold_out`
- Release frontmatter:
  `title, release_year, description, cover_image (/assets/images/albums/*.webp), spotify_url, apple_music_url, tracks: [{title, duration}]`
- Blog posts keep `original_url` + `blogger_*` from Blogger import — don't add
  `old_permalink`.

## Don't break

- Call `script/jekyll.rb` always (loads plugin explicitly).
- Don't upgrade `github-pages`/Ruby without approval.
- No new `blogger.googleusercontent.com` hotlinks — use local WebP/AVIF +
  width/height + alt.
- No new live `Net::HTTP` without cache (`responsive_media_embeds.rb:97` flickr
  oembed is flaky).
- Nav: `aria-expanded` + `.is-open`, theme: `data-theme` + `localStorage.theme`,
  lightbox: `dialog.lightbox`, accordion: `is-closed`.

## Before you push

`test/content_behavior_test.rb` must say `Content behavior checks passed`,
`script/jekyll.rb build` must emit `.media-embed--video` CSS, `index.html` has
hero text + `Main navigation` + `theme-toggle`, CI
`.github/workflows/jekyll.yml` green. Keep this file in sync with `AGENTS.md`.
