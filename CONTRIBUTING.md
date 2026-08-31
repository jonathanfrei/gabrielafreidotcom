# Contributing — Gabriela Frei

Thanks for contributing to the Gabriela Frei site rebuild. This guide expands
`AGENTS.md:1` with human-oriented steps.

## Quick start

```sh
# Prerequisites: Ruby 3.3, Bundler, Node 20+ (for lint)
bundle install
npm install          # for eslint/prettier/stylelint (optional but recommended)
bundle exec ruby script/jekyll.rb serve   # http://localhost:4000
```

Edit `_config.yml`? Restart the server.

## Adding content

### Event

Create `_events/YYYY-MM-DD-my-event.md`:

```yaml
---
title: Acoustic Evening
event_date: 2026-10-15 19:30:00 -0400 # timezone required
location: Naples, FL
venue: Event venue
ticket_url: https://example.com/tickets
free_entry: false
sold_out: false
---
Optional description in Markdown.
```

Upcoming/past is split at build time in `events.md:7` — string comparison
against `site.time` with `timezone: America/New_York` (`_config.yml:5`). Include
`-0400`.

### Release

Create `_discography/my-release.md`:

```yaml
---
title: Release title
release_year: 2026
description: A short summary.
cover_image: /assets/images/albums/my-release.webp # local WebP/AVIF
spotify_url: https://open.spotify.com/...
apple_music_url: https://music.apple.com/...
tracks:
  - title: First song
    duration: "4:15"
---
Longer liner notes.
```

### Page / Journal post

- Pages in `_pages/*.md` render at `/:path` with `layout: page`
  (`_config.yml:14`). Root pages `music.md`, `events.md`, `journal.md`,
  `about.md` have explicit `permalink: /{music,events,journal,about}`.
- Posts in `_posts/*.md` use `layout: post`,
  `permalink: /:year/:month/:day/:title` (`_config.yml:27`). Migrated Blogger
  fields (`original_url`, `blogger_*`, `thumbnail`) are preserved for history —
  don't add `old_permalink`.
- Standalone YouTube/Vimeo/SoundCloud/Flickr URLs on their own line auto-embed
  via `_plugins/responsive_media_embeds.rb:1` — don't wrap them in a link.

Images: prefer local `assets/images/` WebP/AVIF with `width`/`height` +
meaningful `alt`. Avoid `blogger.googleusercontent.com` hotlinks (remaining hero
image is a known debt).

## Theme & style

- Tokens: `_sass/_tokens.scss:1` — brand `#970c00`, gold `#c29b38`,
  `color-scheme` light/dark, fonts `Playfair Display`/`Inter`. Change colors
  there only.
- Styles: currently `assets/main.scss:1` (planned split to
  `_sass/_base|_layout|_components.scss`). Use `clamp()`, `color-mix()`,
  `aspect-ratio`.
- JS: `assets/js/site.js:1` vanilla — keep it small (nav `is-open`, theme
  `localStorage.theme`, accordion `is-closed`, lightbox `dialog`).

## Checks before PR

```sh
bundle exec ruby test/content_behavior_test.rb   # → Content behavior checks passed
bundle exec ruby script/jekyll.rb build
npm run lint        # eslint + stylelint + prettier --check
npm run format      # if lint fails on formatting
```

The GitHub workflow `.github/workflows/jekyll.yml:1` runs these on every PR/push
to `main` and blocks deploy on failure. `bundle` is cached; Node lint runs in a
separate job (non-blocking for now).

## PR process

1. Branch from `main`, commit with clear messages.
2. Push → open PR → CI green (`build` job passes, artifact uploads).
3. Merge to `main` triggers deploy via `actions/deploy-pages@v5`.

## Syncing AI instructions

- Canonical: `AGENTS.md` — `.github/copilot-instructions.md` is a compressed
  mirror for Copilot. Keep them in sync when changing conventions.
- Editor: `.vscode/` recommends Ruby + Liquid + Stylelint + ESLint;
  `.editorconfig` enforces whitespace.

## Questions

Open an issue with label `question` or see the Phase 1–3 roadmap issues
(performance, a11y, modernization).
