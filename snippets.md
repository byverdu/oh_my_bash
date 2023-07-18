# Snippets

## Lighter and darker for CSS

`PostCSSPluginsOptions.js`

```js
// implementation for https://developer.mozilla.org/en-US/docs/Web/CSS/color_value/color
const color = require('css-color-function');

modules.exports = {
  variables: {
    sport: '#0cac0c',
  },
  functions: {
    darker: (value) => color.convert(`color(${value} shade(40%))`),
    lighter: (value) => color.convert(`color(${value} tint(60%))`)
  }
}
```

Webpack config for CSS

```js
const postcssAdvancedVariables = require('postcss-advanced-variables');
const postcssFunctions = require('postcss-functions');
const {variables, functions} = require('./postCSSPluginOpts');

const rules = {
  loader: 'postcss-loader',
  options: {
    postcssOptions: {
      plugins: [
        'autoprefixer',
        'postcss-nested',
        postcssAdvancedVariables({variables}),
        postcssFunctions({
          functions
        })
      ]
    },
    sourceMap: true
  }
}
```

Usage

```css
:global(.sport) {
  --border-color: darker($sport);
  --bg-color: lighter($sport);
  --color: $sport;
}

.container {
  background: currentColor;
  border-top: 4px solid;
  color: var(--color);
}

.newsletter {
  background-image: linear-gradient(to bottom, currentcolor 0%, var(--border-color) 100%);
  color: var(--color);
}
```
