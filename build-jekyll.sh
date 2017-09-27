#!/bin/bash

# skip if build is triggered by pull request
if [ $TRAVIS_PULL_REQUEST == "true" ]; then
  echo "This is PULL REQUEST, exiting."
  exit 0
fi

# enable error reporting to the console
set -e

# Build PDF
#!/bin/bash
pandoc \
	--latex-engine=xelatex \
	--toc \
	--toc-depth=4 \
	--filter pandoc-citeproc \
	--bibliography=./_bibliography/references.bib \
	--metadata date="`date '+%d %B %Y'`" \
	--template=./template/default.latex \
	-o cff-specifications.pdf \
	index.md

mv ./cff-specifications.pdf ./assets/pdf/cff-specifications.pdf

# cleanup "_site"
rm -rf _site
mkdir _site

# clone remote repo to "_site"
git clone https://${GITHUB_TOKEN}@github.com/sdruskat/citation-file-format.git --branch gh-pages _site

# build with Jekyll into "_site"
gem install jekyll-pandoc
gem install jekyll-scholar
bundle exec jekyll build

# push
cd _site
git config user.email "travis-ci@sdruskat.net"
git config user.name "Travis CI"
git add --all
git commit -a -m "Travis #$TRAVIS_BUILD_NUMBER"
git push --force origin gh-pages
