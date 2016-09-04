[![Gem Version](https://img.shields.io/gem/v/progress.svg?style=flat)](https://rubygems.org/gems/progress)
[![Build Status](https://img.shields.io/travis/toy/progress/master.svg?style=flat)](https://travis-ci.org/toy/progress)
[![Code Climate](https://img.shields.io/codeclimate/github/toy/progress.svg?style=flat)](https://codeclimate.com/github/toy/progress)
[![Dependency Status](https://img.shields.io/gemnasium/toy/progress.svg?style=flat)](https://gemnasium.com/toy/progress)
[![Inch CI](https://inch-ci.org/github/toy/progress.svg?branch=master&style=flat)](https://inch-ci.org/github/toy/progress)

# progress

Show progress during console script run.

## Installation

    gem install progress

## Usage

    1000.times_with_progress('Counting to 1000') do |i|
      # do something with i
    end

or without title:

    1000.times_with_progress do |i|
      # do something with i
    end

With array:

    [1, 2, 3].with_progress('1…2…3').each do |i|
      # still counting
    end

`.each` is optional:

    [1, 2, 3].with_progress('1…2…3') do |i|
      # =||=
    end

Nested progress

    (1..10).with_progress('Outer').map do |a|
      (1..10).with_progress('Middle').map do |b|
        (1..10).with_progress('Inner').map do |c|
          # do something with a, b and c
        end
      end
    end

You can also show note:

    [1, 2, 3].with_progress do |i|
      Progress.note = i
      sleep 5
    end

You can use any enumerable method:

    [1, 2, 3].with_progress.map{ |i| 'do stuff' }
    [1, 2, 3].with_progress.each_cons(3){ |i| 'do stuff' }
    [1, 2, 3].with_progress.each_slice(2){ |i| 'do stuff' }
    # …

Any enumerable will work:

    (1..100).with_progress('Wait') do |i|
      # ranges are good
    end

    Dir.new('.').with_progress do |path|
      # check path
    end

NOTE: progress gets number of objects using `length`, `size`, `to_a.length` or just `inject` and if used on objects which needs rewind (like opened File), cycle itself will not work.

Use simple blocks:

    symbols = []
    Progress.start('Input 100 symbols', 100) do
      while symbols.length < 100
        input = gets.scan(/\S/)
        symbols += input
        Progress.step input.length
      end
    end

or just

    symbols = []
    Progress('Input 100 symbols', 100) do
      while symbols.length < 100
        input = gets.scan(/\S/)
        symbols += input
        Progress.step input.length
      end
    end

NOTE: you will get WRONG progress if you use something like this:

    10.times_with_progress('A') do |time|
      10.times_with_progress('B') do
        # code
      end
      10.times_with_progress('C') do
        # code
      end
    end

But you can use this:

    10.times_with_progress('A') do |time|
      Progress.step 5 do
        10.times_with_progress('B') do
          # code
        end
      end
      Progress.step 5 do
        10.times_with_progress('C') do
          # code
        end
      end
    end

Or if you know that B runs 9 times faster than C:

    10.times_with_progress('A') do |time|
      Progress.step 1 do
        10.times_with_progress('B') do
          # code
        end
      end
      Progress.step 9 do
        10.times_with_progress('C') do
          # code
        end
      end
    end

## Copyright

Copyright (c) 2010-2016 Ivan Kuchin. See LICENSE.txt for details.
