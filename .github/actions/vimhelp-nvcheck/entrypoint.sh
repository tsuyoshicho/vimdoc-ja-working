#!/bin/sh

cd "$GITHUB_WORKSPACE"

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

find doc -name \*.jax -print0 | xargs -0 nvcheck                \
   | reviewdog -efm="%f:%l: %m" -name="nvcheck"                 \
               -reporter="${INPUT_REPORTER:-'github-pr-check'}" \
               -level="${INPUT_LEVEL}"

