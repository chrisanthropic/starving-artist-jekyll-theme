[![Gem Version](https://img.shields.io/gem/v/image_optim_pack.svg?style=flat)](https://rubygems.org/gems/image_optim_pack)
[![Build Status](https://img.shields.io/travis/toy/image_optim_pack/master.svg?style=flat)](https://travis-ci.org/toy/image_optim_pack)
[![Code Climate](https://img.shields.io/codeclimate/github/toy/image_optim_pack.svg?style=flat)](https://codeclimate.com/github/toy/image_optim_pack)
[![Dependency Status](https://img.shields.io/gemnasium/toy/image_optim_pack.svg?style=flat)](https://gemnasium.com/toy/image_optim_pack)
[![Inch CI](https://inch-ci.org/github/toy/image_optim_pack.svg?branch=master&style=flat)](https://inch-ci.org/github/toy/image_optim_pack)

# image\_optim\_pack

Precompiled binaries for [`image_optim`](https://github.com/toy/image_optim).

Contains binaries for Mac OS X (>= 10.6, i386 and x86\_64), Linux (i686 and x86\_64), FreeBSD (i386 and amd64) and OpenBSD (i386 and amd64).

## Binaries and libraries

* [advpng](http://www.advancemame.it/doc-advpng.html) by Andrea Mazzoleni and Filipe Estima ([GNU GPLv3](acknowledgements/advancecomp.txt))
	* contains parts of [7z](http://7-zip.org) by Igor Pavlov with modifications by Andrea Mazzoleni ([license](acknowledgements/7z.txt))
	* and [zopfli](https://code.google.com/p/zopfli/) by Lode Vandevenne and Jyrki Alakuijala ([license](acknowledgements/zopfli.txt), [contributors](acknowledgements/zopfli-contributors.txt))
* [gifsicle](http://lcdf.org/gifsicle/) by Eddie Kohler ([GNU GPLv2](acknowledgements/gifsicle.txt))
* [jhead](http://sentex.net/~mwandel/jhead/) by Matthias Wandel ([public domain](acknowledgements/jhead.txt))
* [jpeg-recompress](https://github.com/danielgtaylor/jpeg-archive) by Daniel G. Taylor ([license](acknowledgements/jpeg-archive.txt))
	* includes [Image Quality Assessment (IQA)](http://tdistler.com/iqa/) by Tom Distler ([license](acknowledgements/iqa.txt))
	* includes [SmallFry](https://github.com/dwbuiten/smallfry) by Derek Buitenhuis ([license](acknowledgements/smallfry.txt))
	* statically linked against mozjpeg, see below
* [jpegoptim](http://www.kokkonen.net/tjko/projects.html) by Timo Kokkonen ([GNU GPLv2](acknowledgements/jpegoptim.txt) or later)
* [libjpeg and jpegtran](http://ijg.org/) by the Independent JPEG Group ([license](acknowledgements/libjpeg.txt))
* [libjpeg-turbo](http://www.libjpeg-turbo.org/) by libjpeg-turbo Project ([license](acknowledgements/libjpeg-turbo.txt))
	* based on libjpeg, see above
	* includes [x86 SIMD extension for IJG JPEG library](http://cetus.sakura.ne.jp/softlab/jpeg-x86simd/jpegsimd.html) by Miyasaka Masaru ([license](acknowledgements/libjpeg-x86-simd.txt))
* [libpng](http://libpng.org/pub/png/) by Guy Eric Schalnat, Andreas Dilger, Glenn Randers-Pehrson and others ([license](acknowledgements/libpng.txt))
* [mozjpeg](https://github.com/mozilla/mozjpeg) by Mozilla Research ([license](acknowledgements/mozjpeg.txt))
	* base on libjpeg and libjpeg-turbo, see above
* [optipng](http://optipng.sourceforge.net/) by Cosmin Truta ([license](acknowledgements/optipng.txt), [authors](acknowledgements/optipng-authors.txt))
	* contains code based in part on the work of Miyasaka Masaru for BMP support ([license](acknowledgements/bmp2png.txt))
	* and David Koblas for GIF support ([license](acknowledgements/gifread.txt))
* [pngcrush](http://pmt.sourceforge.net/pngcrush/) by Glenn Randers-Pehrson, portions by Greg Roelofs ([license](acknowledgements/pngcrush.txt))
	* contains [cexcept](http://www.nicemice.net/cexcept/) interface by Adam M. Costello and Cosmin Truta ([license](acknowledgements/cexcept.txt))
* [pngquant](http://pngquant.org/) by Kornel Lesiński based on code by Greg Roelofs and Jef Poskanzer after an idea by Stefan Schneider ([license](acknowledgements/pngquant.txt))
* [zlib](http://zlib.net/) by Jean-Loup Gailly and Mark Adler ([license](acknowledgements/zlib.txt))

**NOTE: On FreeBSD and OpenBSD `make` is not the GNU Make, so `gmake` should be used instead.**

You can download all source code using gnu make download target:

```sh
make download
```

## Installation

```sh
gem install image_optim image_optim_pack
```

Or add to your `Gemfile`:

```ruby
gem 'image_optim'
gem 'image_optim_pack'
```

## Development

Mac OS X binaries and libraries are built on host, others using [vagrant](https://www.vagrantup.com/).

Boxes for vagrant are built using [veewee](https://github.com/jedi4ever/veewee), check [boxes/Rakefile](boxes/Rakefile) and [boxes/definitions](boxes/definitions).

```sh
script/run # Build and test all for all oses and architectures
script/run NO_HALT=1 # Don't halt VMs after building

make # Build all tools and copy them to vendor/OS-ARCH for current OS and ARCH, then test
make all # same
make run # same

make livecheck # Check versions
make update-versions # Update versions in Makefile

make download # Download archives
make build # Build all without copying to output directory

make test # Test bins for current os/arch
make test -i # Continue if one of bins fail

make clean # Remove build and output directories for current os/arch
make clean-all # Remove build root and output root directories
make clobber # `clean-all` and remove download directory
```

## Copyright

Copyright (c) 2014-2016 Ivan Kuchin. See [LICENSE.txt](LICENSE.txt) for details.
