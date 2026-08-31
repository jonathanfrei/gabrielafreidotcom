// eslint flat config — vanilla JS only (Jekyll assets/js/site.js)
import globals from "globals";

export default [
  {
    ignores: [
      "_site/**",
      ".jekyll-cache/**",
      "vendor/**",
      "node_modules/**",
      "_posts/with-heart-wide-open-jekyll-content/**"
    ]
  },
  {
    files: ["assets/js/**/*.js", "script/**/*.js"],
    languageOptions: {
      ecmaVersion: 2022,
      sourceType: "script",
      globals: {
        ...globals.browser
      }
    },
    rules: {
      "no-unused-vars": ["warn", { argsIgnorePattern: "^_" }],
      "no-console": "off",
      eqeqeq: "error",
      curly: ["warn", "multi-line"],
      "prefer-const": "warn"
    }
  }
];
