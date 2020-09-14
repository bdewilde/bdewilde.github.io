#!/bin/sh
bundle exec jekyll serve \
  --watch \
  --trace \
  --host 0.0.0.0 \
  --open-url \
  --strict_front_matter
