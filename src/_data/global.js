const eleventyPackage = require('../../node_modules/@11ty/eleventy/package.json');

module.exports = {
  random() {
    const segment = () => {
      return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
    };
    return `${segment()}-${segment()}-${segment()}`;
  },
  now: Date.now(),
  environment: process.env.ELEVENTY_ENV ? process.env.ELEVENTY_ENV : 'production',
  eleventyVersion: eleventyPackage.version
};
