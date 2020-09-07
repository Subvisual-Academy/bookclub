// Load all the components within this directory and all subdirectories.

const components = require.context(".", true);
components.keys().forEach(components);
