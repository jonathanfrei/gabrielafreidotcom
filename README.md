# gabrielafreidotcom

Jekyll source for the Gabriela Frei website, including content migrated from the original Blogger site.

## Local development

```sh
bundle install
bundle exec jekyll serve
```

The local preview is available at <http://localhost:4000>.

## Deployment

Pushes to `main` are built and deployed to GitHub Pages by the workflow in `.github/workflows/jekyll.yml`. In the repository's **Settings → Pages**, set **Source** to **GitHub Actions**.
