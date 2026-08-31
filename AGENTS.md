# AGENTS.md — Gabriela Frei Site

> Source of truth for humans and AI agents working in this repo. Keep this file
> in sync with `.github/copilot-instructions.md` and `CONTRIBUTING.md`.

## 1. Project identity

- **What:** Jekyll site for musician Gabriela Frei — music, events,
  journal/archive, about. Lightweight responsive theme, semantic HTML, modern
  CSS, vanilla JS only.
- **Stack:** Ruby `3.3` (`.ruby-version:1`), `github-pages ~>232` → Jekyll
  `3.10.0` (`Gemfile:3`, `Gemfile.lock:24`), `webrick`, `tzinfo-data`. Deploys
  to GitHub Pages via Actions.
- **Design:** Brand `#970c00` (dark `#e64a3a`) in `_sass/_tokens.scss:1`, fonts
  `Playfair Display` + `Inter` via Google Fonts (`_includes/head.html:6`),
  accent gold `#c29b38`. No JS framework.

## 2. Commands — always use these (don't invent alternatives)

```sh
bundle install
bundle exec ruby script/jekyll.rb serve   # NOT `bundle exec jekyll serve` — see script/jekyll.rb:1
bundle exec ruby test/content_behavior_test.rb   # must pass before commit
bundle exec ruby script/jekyll.rb build          # production: adds --baseurl from Pages action
npm run lint          # eslint + stylelint + prettier --check
npm run format        # prettier --write
```

- Restart local server after editing `_config.yml:1`.
- Run `test/content_behavior_test.rb:1` before every push — it builds the full
  site in a tmpdir and checks permalinks, embeds, and CSS compilation.

## 3. Repo layout (where to look)

| Area                | Path                                                                            | Notes                                                                                                              |
| ------------------- | ------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------ |
| Global config       | `_config.yml:1`                                                                 | navigation, `social.youtube`, `hero.*`, `collections`, `defaults`, `exclude`                                       |
| Tokens              | `_sass/_tokens.scss:1`                                                          | CSS variables — edit colors/shadows/fonts here only                                                                |
| Styles              | `assets/main.scss:1`                                                            | single stylesheet (planned split to `_sass/_base                                                                   | _layout | _components.scss`) |
| JS                  | `assets/js/site.js:1`                                                           | nav toggle `.nav-toggle`/`is-open`, theme toggle `localStorage.theme` + `data-theme`, accordion, lightbox `dialog` |
| Layouts             | `_layouts/{default,home,page,post,event,release}.html`                          | `home.html:1` = hero + quick-grid + latest 3 posts                                                                 |
| Includes            | `_includes/{head,header,footer}.html`                                           | `header.html:7` brand + nav + theme button                                                                         |
| Content collections | `_discography/*.md`, `_events/YYYY-MM-DD-slug.md`, `_pages/*.md`, `_posts/*.md` | see §4                                                                                                             |
| Plugin              | `_plugins/responsive_media_embeds.rb:1`                                         | transforms standalone YouTube/Vimeo/SoundCloud/Flickr lines → `.media-embed`                                       |
| Workflow            | `.github/workflows/jekyll.yml:1`                                                | checkout → ruby 3.3 → bundle → test → Pages → build → upload-artifact → deploy on `main`                           |

## 4. Content rules

### Add an event (`_events/YYYY-MM-DD-name.md`)

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
Optional description (Markdown).
```

- `event_date` must include timezone offset (`-0400`) — `events.md:7` compares
  `site.time | date: "%Y-%m-%d"` with `timezone: America/New_York`.
- Collection permalink `permalink: /appearances/:name` (`_config.yml:17`) so
  `/events` index doesn't collide with detail pages.
- `events.md:12` splits upcoming/past at build time; string comparison is
  timezone-sensitive (see open Issue: events timezone drift).

### Add a release (`_discography/slug.md`)

```yaml
---
title: Release title
release_year: 2026
description: Short summary.
cover_image: /assets/images/albums/release.jpg # local WebP/AVIF preferred
spotify_url: https://open.spotify.com/...
apple_music_url: https://music.apple.com/...
tracks:
  - title: First song
    duration: "4:15"
---
Longer liner notes (Markdown).
```

- Permalink `/releases/:name` (`_config.yml:20`). Keep images local under
  `assets/images/albums/` with useful `alt` — `release.html:6` renders
  `alt="{{ page.title }} cover artwork"`.

### Pages & posts

- Root pages use `permalink: /:path` via `collections.pages` (`_config.yml:14`);
  files in `_pages/` map to `/welcome`, `/on-demand`, etc. Root `about.md:6`,
  `music.md:3`, `events.md:3`, `journal.md:3` have `permalink: /about` etc.
  explicitly.
- Posts: `defaults: layout: post, permalink: /:year/:month/:day/:title`
  (`_config.yml:27`). Migrated Blogger posts carry `original_url`, `blogger_*`,
  `old_permalink`, `thumbnail` (external Blogger hotlinks) — preserve
  `original_url` for canonical history, don't reintroduce `old_permalink`.
- Standalone media URLs on their own line become responsive embeds — don't wrap
  them in `<a>` or inline text (`_plugins/responsive_media_embeds.rb:8`
  `STANDALONE_URL`).

## 5. Theme behavior contracts (don't break)

- Nav collapses <760px: `.nav-toggle` toggles `aria-expanded` +
  `.site-nav.is-open` (`assets/main.scss:35`, `site.js:1`).
- Theme: `head.html:4`
  `documentElement.dataset.theme = localStorage.theme||"auto"` +
  `_tokens.scss:2`
  `@media(prefers-color-scheme:dark):root:not([data-theme="light"])` and
  `site.js:4` toggle. Persist `localStorage.theme`.
- Lightbox: `.prose img` → `role=button` + `dialog.lightbox` (`default.html:7`,
  `site.js:11`).
- Accordion: `.accordion button` toggles `aria-expanded` + `is-closed`
  (`site.js:7`).
- `journal.md:7` lists `site.pages` sorted by `date` then `site.posts` —
  pagination planned, don't paginate without configuring `jekyll-paginate`.

## 6. Guardrails — what agents MUST NOT do

1. **Don't upgrade `github-pages`/`Jekyll`/`Ruby`** without approval — pinned
   for GH Pages (`Gemfile:3` `~>232`, `.ruby-version:1` `3.3`). Doing so breaks
   `actions/deploy-pages@v5` artifact contract.
2. **Don't call `jekyll` directly** — always
   `bundle exec ruby script/jekyll.rb {serve,build}` (loads
   `_plugins/responsive_media_embeds` explicitly, `script/jekyll.rb:6`).
3. **Don't add new remote image hotlinks** — vendor to `assets/images/`
   WebP/AVIF with `width`/`height`; current `hero.image` (`_config.yml:64`) is
   last external (`blogger.googleusercontent.com`).
4. **Don't add live `Net::HTTP` calls** without cache —
   `responsive_media_embeds.rb:97` `flickr_embed` hits
   `flickr.com/services/oembed` at build time; mirror pattern with file cache in
   `_data/` if extended.
5. **Don't edit `_posts/with-heart-wide-open-jekyll-content/` in place** — it's
   imported archive pending move to `_archive/` (see Issue: archive
   duplication).
6. **Don't commit to `main` without green CI** —
   `.github/workflows/jekyll.yml:1` requires `test/content_behavior_test.rb` +
   build + artifact upload.
7. **Don't change `site.time` event comparison** without adding `UTC`/`timezone`
   tests.

## 7. Workflow — how to land changes

1. Branch from `main` → edit →
   `bundle exec ruby test/content_behavior_test.rb` +
   `bundle exec ruby script/jekyll.rb build` locally.
2. Optionally `npm run lint` / `npm run format` for JS/SCSS.
3. Open PR against `main` — `jekyll.yml` runs on `pull_request` and `push`.
   `concurrency.cancel-in-progress:false` means pushes queue.
4. Merge only when `build` job passes; `deploy` job runs only on
   `refs/heads/main`.
5. Keep `AGENTS.md` / `.github/copilot-instructions.md` / `CONTRIBUTING.md` in
   sync when changing conventions — script `script/sync-agent-docs.rb`
   (planned).

## 8. Verification checklist before PR

- [ ] `bundle exec ruby test/content_behavior_test.rb` →
      `Content behavior checks passed`
- [ ] `bundle exec ruby script/jekyll.rb build` renders
      `destination/assets/main.css` with `.media-embed--video` and
      `aspect-ratio: 16/9`
- [ ] `destination/index.html` contains hero
      `Songs from the heart, offered with grace.` +
      `aria-label="Main navigation"` + `class="theme-toggle"`
- [ ] No new `blogger.googleusercontent.com` URLs in diff
      (`rg blogger.googleusercontent`)
- [ ] Event `event_date` includes timezone; release `cover_image` is local if
      new

## 9. For AI tooling (OpenCode / Muse)

- Prefer `opencode.json` tasks: `serve`, `test`, `build`, `lint` (see
  `package.json:6` scripts).
- Read `AGENTS.md:1` first token budget > `README.md:1`; `README.md:7` is
  quickstart, this file is canonical.
- Use `rg` / `read` for pattern checks, don't `sed -i` tokens blindly — validate
  color changes in light + dark (`_tokens.scss:1` both roots).
- Sync instruction drift: propose edits here rather than silently diverging in
  `.github/copilot-instructions.md`.
