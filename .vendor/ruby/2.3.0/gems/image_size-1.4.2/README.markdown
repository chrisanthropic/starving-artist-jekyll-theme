# image_size

measure image size using pure Ruby
formats: `bmp`, `cur`, `gif`, `jpeg`, `ico`, `pbm`, `pcx`, `pgm`, `png`, `ppm`, `psd`, `swf`, `tiff`, `xbm`, `xpm`

[![Build Status](https://travis-ci.org/toy/image_size.png?branch=master)](https://travis-ci.org/toy/image_size)

## Download

The latest version of image\_size can be found at http://github.com/toy/image_size

## Installation

    gem install image_size

## Examples

    require 'image_size'

    p ImageSize.path('spec/test.jpg').size

    open('spec/test.jpg', 'rb') do |fh|
      p ImageSize.new(fh).size
    end


    require 'image_size'
    require 'open-uri'

    open('http://www.rubycgi.org/image/ruby_gtk_book_title.jpg', 'rb') do |fh|
      p ImageSize.new(fh).size
    end

    open('http://www.rubycgi.org/image/ruby_gtk_book_title.jpg', 'rb') do |fh|
      data = fh.read
      p ImageSize.new(data).size
    end

## Licence

This code is free to use under the terms of the Ruby's licence.

## Contact

Original author: "Keisuke Minami": mailto:keisuke@rccn.com
