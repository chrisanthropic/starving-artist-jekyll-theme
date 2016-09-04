[![Gem Version](https://img.shields.io/gem/v/in_threads.svg?style=flat)](https://rubygems.org/gems/in_threads)
[![Build Status](https://img.shields.io/travis/toy/in_threads/master.svg?style=flat)](https://travis-ci.org/toy/in_threads)
[![Code Climate](https://img.shields.io/codeclimate/github/toy/in_threads.svg?style=flat)](https://codeclimate.com/github/toy/in_threads)
[![Dependency Status](https://img.shields.io/gemnasium/toy/in_threads.svg?style=flat)](https://gemnasium.com/toy/in_threads)
[![Inch CI](http://inch-ci.org/github/toy/in_threads.svg?branch=master&style=flat)](http://inch-ci.org/github/toy/in_threads)

# in_threads

Easily execute ruby code in parallel.

## Installation

    gem install in_threads

## Usage

By default there is maximum of 10 simultaneous threads

    urls.in_threads.map do |url|
      url.fetch
    end

    urls.in_threads.each do |url|
      url.save_to_disk
    end

    numbers.in_threads(2).map do |number|
      # whery long and complicated formula
      # using only 2 threads
    end

You can use any Enumerable method, but some of them can not use threads (`inject`, `reduce`) or don't use blocks (`to_a`, `entries`, `drop`, `take`, `first`, `include?`, `member?`) or have both problems depending on usage type (`min`, `max`, `minmax`, `sort`)

    urls.in_threads.any?(&:ok?)
    urls.in_threads.all?(&:ok?)
    urls.in_threads.none?(&:error?)
    urls.in_threads.grep(/example\.com/, &:fetch)

## Copyright

Copyright (c) 2010-2015 Ivan Kuchin. See LICENSE.txt for details.
