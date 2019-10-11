#!/bin/sh

set -e

dir=$1 ; shift

git clone -b master --depth 1 "git@github.com:${DEPLOY_REPO_SLUG}.git" "$dir"

# Create tags
vim -eu tools/maketags.vim

# install
rsync -rlptD --delete-after doc/ ${dir}/doc
rsync -rlptD --delete-after syntax/ ${dir}/syntax
rsync -rlptD --delete-after README-dist.md ${dir}/README.md

cd "$dir"
git add --all
if ! git diff --quiet HEAD ; then
  git config push.default simple
  git config user.email "$DEPLOY_USER_EMAIL"
  git config user.name "$DEPLOY_USER_NAME"
  git commit -m "Generated by Travis JOB $TRAVIS_JOB_NUMBER

https://travis-ci.org/$TRAVIS_REPO_SLUG/builds/$TRAVIS_BUILD_ID"
  git push
else
  echo "No changes"
fi
