const js = require('@eslint/js');
const prettier = require('eslint-config-prettier');

module.exports = [
  js.configs.recommended,
  prettier,
  {
    files: ['**/*.js', '**/*.cjs', '**/*.mjs', '**/*.ts'],
    ignores: ['node_modules/', 'docs/_site/', 'dist/', 'vendor/', 'eslint.config.cjs'],
    languageOptions: {
      ecmaVersion: 'latest',
      sourceType: 'module',
    },
  },
];
