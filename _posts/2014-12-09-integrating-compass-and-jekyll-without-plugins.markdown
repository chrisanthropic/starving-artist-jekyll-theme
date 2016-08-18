---
layout: post
title: "Integrating Compass and Jekyll Without Plugins"
date: 2014-12-09T15:20:40-08:00
sitemap:
  lastmod: 2014-12-09T15:20:40-08:00
  priority: 0.5
  changefreq: monthly
  exclude: 'no'
---

I find myself getting closer to the point where I'm done with the scaffolding and can finally start with the design. The more fun stuff I look at the more I realize that integrating Compass is probably a good idea.

I don't like plugins unless absolutely necessarry so while I'm sure the jekyll-compass plugin is great, I decided to figure out how to add Compass to my Jekyll/Octopress 3 site without any plugins.

Here's what I did.

* Add compass to your gemfile
* Install compass
  `bundle install --binstubs --path=vendor`
* Run Compass for the first time so it generates a config file
  `bundle exec compass create --bare --sass-dir "_sass" --css-dir "css" --images-dir "images"`
  * This command creates a config.rb file wiht compass settings that are compatible with Jekyll
* Move the default Jekyll css/main.css to _sass/main.css
  * remove the yaml frontmatter from the file once you've moved it to the _sass directory
* Delete the css directory
* Update rakefile to run compass compile before building

```
desc "build the site"
task :build do
  system "bundle exec compass compile"
  system "bundle exec jekyll build"
  system "bundle exec rake minify_html"
  system "bundle exec rake optimizeimages"
end
```
* Run `bundle exec rake build`
* NOTE - compression settings are no longer set in _config.yml, you'll need to add the following line to `config.rb` in oroder to compress css
  `output_style = :compressed`

* Update rakefile to run compass watch and jekyll serve together

```
##############
#   Develop  #
##############

# Useful for development
# It watches for chagnes and updates when it finds them

desc "Watch the site and regenerate when it changes"
task :watch do
  puts "Starting to watch source with Jekyll and Compass."
  system "compass compile" unless File.exist?("css/main.css")
  system "jekyll build"
  jekyllPid = Process.spawn("jekyll serve --watch")
  compassPid = Process.spawn("compass watch")

  trap("INT") {
    [jekyllPid, compassPid].each { |pid| Process.kill(9, pid) rescue Errno::ESRCH }
    exit 0
  }

  [jekyllPid, compassPid].each { |pid| Process.wait(pid) }
end
```
* Now you can run `bundle exec rake watch` and it runs compass watch & jekyll serve together.

Now you can use Compass mixins and import partials by adding `@import compass/blahblahblah` to your _sass/main.scss file.
Running `bundle exec rake build` will then run `compass compile` to create your css/main.scss file, followed by `jekyll build` which will move that css/main.scss to _site/css/main.css

In short:

* you can store any partials you want to in the _sass directory (or subdirectories)
* you can import these partials via your main.scss file
* any partials imported will be compiled into a single file (css/main.scss) when you run `compass compile`
* the css/main.scss file will be built into _site/css/main.css when you run `jekyll build`
* any partials not imported by your _sass/main.scss file will not be used