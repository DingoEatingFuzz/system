#! /bin/sh

npm set prefix ~/.npm-global

# These are packages not available in nixos.packages
npm i -g @fsouza/prettierd
npm i -g @lifeart/ember-language-server
npm i -g ember-template-lint
npm i -g vscode-css-languageservice
