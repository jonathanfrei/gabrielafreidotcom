// stylelint — SCSS tokens + single stylesheet (assets/main.scss) for now
export default {
  extends: "stylelint-config-standard-scss",
  ignoreFiles: [
    "_site/**",
    ".jekyll-cache/**",
    "vendor/**",
    "node_modules/**",
    "_posts/with-heart-wide-open-jekyll-content/**"
  ],
  rules: {
    // Project uses custom props & modern CSS; relax overly strict rules
    "selector-class-pattern": null,
    "custom-property-pattern": null,
    "scss/dollar-variable-pattern": null,
    "declaration-block-no-redundant-longhand-properties": null,
    "shorthand-property-no-redundant-values": null,
    "color-function-notation": null,
    "alpha-value-notation": null,
    "color-hex-length": null,
    "media-feature-range-notation": null,
    "value-keyword-case": null,
    "declaration-block-single-line-max-declarations": null,
    "at-rule-empty-line-before": null,
    "scss/at-rule-no-unknown": null,
    "selector-pseudo-class-no-unknown": [true, { ignorePseudoClasses: ["is-open", "is-closed"] }],
    // Single-file stylesheet is intentionally not modular yet
    "no-descending-specificity": null,
    "declaration-no-important": null,
    "rule-empty-line-before": null,
    "custom-property-empty-line-before": null
  }
};
