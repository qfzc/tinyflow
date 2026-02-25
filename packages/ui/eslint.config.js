export default {
  extends: ['eslint:recommended'],
  ignore: [
    'dist/',
    'node_modules/',
    '*.config.js',
    '*.config.ts',
    'vite.config.*.js',
    'vite.config.*.ts'
  ],
  env: {
    browser: true,
    node: true,
    es2021: true
  },
  rules: {
    'no-console': 'off',
    'no-unused-vars': 'warn'
  }
}
