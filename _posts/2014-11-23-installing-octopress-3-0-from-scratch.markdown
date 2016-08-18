---
layout: post
title: "Installing Octopress 3.0 From Scratch"
date: 2014-11-23T16:44:01-08:00
---

I've been getting excited for the release of Octopress 3.0 and decided to try installing it today. I've never used Jekyll without Octopress so I struggled a little, but it was a relatively painless experience.

Listed below are the steps I took to get a brand new Octopress 3.0 install

## Assumptions
I'm assuming that you're not *migrating* from Octopress 2.0 but are starting completely from scratch in a new/empty directory.

## Install Jekyll
`gem install jekyll`

## Create Site scaffolding
`jekyll new SITENAME`
`cd SITENAME`


## Install Octopress

* Add a Gemfile to your directory with the following content:

```
source "https://rubygems.org"
gem 'octopress', '~> 3.0.0.rc.15'
gem 'rake'
gem 'octopress-deploy'
gem 'aws-sdk'
```

* Add these to your `.gitignore`
```
_deploy.yml
.bundle
bin
vendor
```
* Run `bundle install --binstubs --path=vendor`
  * This installs all of the required ruby gems to a subdirectory here, making it easier to manage per project.
* Run `bundle exec octopress init`
* Add this to your `_config.yml` so the Ruby stuff is ignored when builing your site
  `exclude: [.bundle, bin, vendor]`

## Set up Github deployment
1. Create your Github-pages repo via Github
2. Run `octopress deploy init git`
3. Add your git URL to `_deploy.yml` file

## CNAME
Create your CNAME file if you're using a custom URL with Github-pages

## Build your site
`octopress build`

## Preview your site

1. Run `octopress serve`
2. Visit `127.0.0.1:4000`

## Commit Source
1. Run `git init`
2. Run `git remote add origin GIT-REPO-URl`
3. Run
`git add .`
`git commit -m 'inital Octopress 3.0 install'`
`git checkout -b source`
4. Run `git push -u origin source`

## Deploy the Site
Run `octopress deploy` 
