---
layout: post
title: "Rakefile: Minimize Assets and Optimize Images"
date: 2014-12-04T16:38:13-08:00
sitemap:
  lastmod: 2014-12-04T16:38:13-08:00
  priority: 0.5
  changefreq: monthly
  exclude: 'no'
---

I used Octopress to build my wife's webcomic site [ShamseeComic](http://www.shamseecomic.com) and learning how to optimize everything has been fun.

Now that I'm starting on this site from scratch (with a better understanding of Jekyll) I figured I'd revisit my old method and update it.

Below are the steps I took to add a few optimization tasks to my blank Rakefile. Here's the tasks:

* Minify all HTML and CSS when the site is built
* Optimize all images when the site is built
* Notify Google and Yahoo when the site is deployed
  * This one took me a bit, but I was trying to reproduce the 'Ping Service' that's included in Wordpress

### _config.yml
Jekyll 2.0+ has full Sass support so we can use it to minify our CSS when Jekyll builds the site, just by adding a couple of lines to our _config.yml.

```
# Compress our CSS
  sass:
    style: :compressed
```

### Gemfile

* First I add some gems to my Gemfile since they're used for the minification and optimization
```
gem 'mini_magick'
gem 'html_compressor'
```
* Then install the new Gems by running `bundle install --binstubs --path=vendor`
* Next I create a Rakefile with the following:

```
require "html_compressor"

##############
#   Build    #
##############

# Generate the site
# Minify, optimize, and compress

desc "build the site"
task :build do
  system "bundle exec jekyll build"
  system "bundle exec rake minify_html"
  system "bundle exec rake optimizeimages"
end

##############
#   Deploy   #
##############

# Deploy the site
# Ping / Notify after site is deployed

desc "deploy the site"
task :deploy do
  system "bundle exec octopress deploy"
  system "bundle exec rake notify"
end

##############
# Optimizes  #
##############

# https://github.com/phobetron/image-optimizer 
# Using this to optimize our images. Dependencies are jpegtran, pngcrush and gifsicle

desc "Optimize GIF, JPG and PNG files"
task :optimizeimages => [ 'optimizeimages:find_tools', 'optimizeimages:run' ]

namespace :optimizeimages do
  desc "Test for presence of image optimization tools in the command path"
  task :find_tools do
    RakeFileUtils.verbose(false)
    tools = %w[jpegtran gifsicle pngcrush]
    puts "\nOptimizing images using the following tools:"
    tools.delete_if { |tool| sh('which', tool) rescue false }
    raise "The following tools must be installed and accessible from the execution path: #{ tools.join(', ') }" if tools.size > 0
  end

  task :run do
    RakeFileUtils.verbose(false)
    start_time = Time.now

    file_list = FileList.new '_site/**/*.{gif,jpeg,jpg,png}'

    last_optimized_path = '_site/.last_optimized'
    if File.exists? last_optimized_path
      last_optimized = File.new last_optimized_path
      file_list.exclude do |f|
        File.new(f).mtime < last_optimized.mtime
      end
    end

    puts "\nOptimizing #{ file_list.size } image files."

    proc_cnt = 0
    skip_cnt = 0
    savings = {:old => Array.new, :new => Array.new}

    file_list.each_with_index do |f, cnt|
      puts "Processing: #{cnt+1}/#{file_list.size} #{f.to_s}"

      extension = File.extname(f).delete('.').gsub(/jpeg/,'jpg')
      ext_check = `file -b #{f} | awk '{print $1}'`.strip.downcase
      ext_check.gsub!(/jpeg/,'jpg')
      if ext_check != extension
        puts "\t#{f.to_s} is a: '#{ext_check}' not: '#{extension}' ..skipping"
        skip_cnt = skip_cnt + 1
        next
      end

      case extension
      when 'gif'
        `gifsicle -O2 #{f} > #{f}.n`
      when 'png'
        `pngcrush -q -rem alla -reduce -brute  #{f} #{f}.n`
      when 'jpg'
        `jpegtran -copy none -optimize -perfect -progressive #{f} > #{f}.p`
        prog_size = File.size?("#{f}.p")

        `jpegtran -copy none -optimize -perfect #{f} > #{f}.np`
        nonprog_size = File.size?("#{f}.np")

        if prog_size < nonprog_size
          File.delete("#{f}.np")
          File.rename("#{f}.p", "#{f}.n")
        else
          File.delete("#{f}.p")
          File.rename("#{f}.np", "#{f}.n")
        end
      else
        skip_cnt = skip_cnt + 1
        next
      end

      old_size = File.size?(f).to_f
      new_size = File.size?("#{f}.n").to_f

      if new_size < old_size
        File.delete(f)
        File.rename("#{f}.n", f)
      else
        new_size = old_size
        File.delete("#{f}.n")
      end

      savings[:old] << old_size
      savings[:new] << new_size

      reduction = 100.0 - (new_size/old_size*100.0)

      puts "Output: #{sprintf "%0.2f", reduction}% | #{old_size.to_i} -> #{new_size.to_i}"
      proc_cnt = proc_cnt + 1
    end

    total_old = savings[:old].inject(0){|sum,item| sum + item}
    total_new = savings[:new].inject(0){|sum,item| sum + item}
    total_reduction = total_old > 0 ? (100.0 - (total_new/total_old*100.0)) : 0

    minutes, seconds = (Time.now - start_time).divmod 60
    puts "\nTotal run time: #{minutes}m #{seconds.round}s"

    puts "Files: #{file_list.size}\tProcessed: #{proc_cnt}\tSkipped: #{skip_cnt}"
    puts "\nTotal savings:\t#{sprintf "%0.2f", total_reduction}% | #{total_old.to_i} -> #{total_new.to_i} (#{total_old.to_i - total_new.to_i})"

    FileUtils.touch last_optimized_path
  end
end

##############
#   Minify   #
##############

desc "Minify HTML"
task :minify_html do
  puts "## Minifying HTML"
  compressor = HtmlCompressor::HtmlCompressor.new
  Dir.glob("_site/**/*.html").each do |name|
    puts "Minifying #{name}"
    input = File.read(name)
    output = File.open("#{name}", "w")
    output << compressor.compress(input)
    output.close
  end
end

desc "Minify static assets"
task :minify => [:minify_css, :minify_html] do
end

##############
#   Notify   #
##############

# Ping Google and Yahoo to let them know you updated your site

site = "www.chrisanthropic.com"

desc 'Notify Google of the new sitemap'
task :sitemapgoogle do
  begin
    require 'net/http'
    require 'uri'
    puts '* Pinging Google about our sitemap'
    Net::HTTP.get('www.google.com', '/webmasters/tools/ping?sitemap=' + URI.escape('#{site}/sitemap.xml'))
  rescue LoadError
    puts '! Could not ping Google about our sitemap, because Net::HTTP or URI could not be found.'
  end
end

desc 'Notify Bing of the new sitemap'
task :sitemapbing do
  begin
    require 'net/http'
    require 'uri'
    puts '* Pinging Bing about our sitemap'
    Net::HTTP.get('www.bing.com', '/webmaster/ping.aspx?siteMap=' + URI.escape('#{site}/sitemap.xml'))
  rescue LoadError
    puts '! Could not ping Bing about our sitemap, because Net::HTTP or URI could not be found.'
  end
end

desc "Notify various services about new content"
task :notify => [:sitemapgoogle, :sitemapbing] do
end
```
Now I build my site with the `bundle exec rake build` command and it automatically builds my site, minifies the assets, and optimizes all images.

When I deploy my site with `bundle exec rake deploy` it deploys it to S3 and then notifies Google and Bing about my updated sitemap.xml file.

Pretty cool.