// Load all the components within this directory and all subdirectories.

const channels = require.context(".", true);
channels.keys().forEach(channels);
