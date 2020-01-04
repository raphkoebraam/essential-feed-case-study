#!/bin/bash

RBENV_HOME=/usr/local/bin:$HOME/.rbenv/bin:$HOME/.rbenv/shims
[[ ":$PATH:" != *":$RBENV_HOME:"* ]] && PATH="${RBENV_HOME}:${PATH}"

eval "$(rbenv init -)"

rbenv local `cat .ruby-version`

gem install bundler

bundle install
