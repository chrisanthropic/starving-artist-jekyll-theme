run : all

# ====== VERSIONS ======

ADVANCECOMP_VER := 1.19
GIFSICLE_VER := 1.88
JHEAD_VER := 3.00
JPEGARCHIVE_VER := 2.1.1
JPEGOPTIM_VER := 1.4.3
LIBJPEG_VER := 9a
LIBMOZJPEG_VER := 3.1
LIBPNG_VER := 1.6.19
LIBZ_VER := 1.2.8
OPTIPNG_VER := 0.7.5
PNGCRUSH_VER := 1.7.88
PNGQUANT_VER := 2.5.2

# ====== CONSTANTS ======

OS := $(shell uname -s | tr A-Z a-z)
ARCH := $(shell uname -m)

IS_DARWIN := $(findstring darwin,$(OS))
DLEXT := $(if $(IS_DARWIN),.dylib,.so)
HOST := $(ARCH)-$(if $(IS_DARWIN),apple,pc)-$(OS)

DL_DIR := $(CURDIR)/download
BUILD_ROOT_DIR := $(CURDIR)/build
BUILD_DIR := $(BUILD_ROOT_DIR)/$(OS)/$(ARCH)
OUTPUT_ROOT_DIR := $(CURDIR)/vendor
OUTPUT_DIR := $(OUTPUT_ROOT_DIR)/$(OS)/$(ARCH)

# ====== HELPERS ======

downcase = $(shell echo $1 | tr A-Z a-z)

mkpath := mkdir -p
ln_s := ln -sf

# lock using %.lock dir, download to %.tmp rename to %, remove %.lock
define download
	while ! mkdir $2.lock 2> /dev/null; do sleep 1; done
	wget -q -O $2.tmp $1
	mv $2.tmp $2
	rm -r $2.lock
endef

# ====== ARCHIVES ======

$(shell $(mkpath) $(DL_DIR)) # just create dl dir

ARCHIVES :=

# $1 - name of archive
# $2 - url of archive with [VER] for replace with version
# $3 - optional addition to version string
define archive
$1_URL := $(subst [VER],$($1_VER)$(strip $3),$(strip $2))
$1_DIR := $(BUILD_DIR)/$(call downcase,$1)
$1_TGZ := $(DL_DIR)/$(call downcase,$1)-$($1_VER)$(strip $3).tar.gz
ARCHIVES += $1
# download archive from url
$$($1_TGZ) :; $$(call download,$$($1_URL),$$@)
livecheck-$(call downcase,$1) :; @script/livecheck $(call downcase,$1) $($1_VER)
endef

$(eval $(call archive,ADVANCECOMP, http://prdownloads.sourceforge.net/advancemame/advancecomp-[VER].tar.gz?download))
$(eval $(call archive,GIFSICLE,    http://www.lcdf.org/gifsicle/gifsicle-[VER].tar.gz))
$(eval $(call archive,JHEAD,       http://www.sentex.net/~mwandel/jhead/jhead-[VER].tar.gz))
$(eval $(call archive,JPEGARCHIVE, https://github.com/danielgtaylor/jpeg-archive/archive/[VER].tar.gz))
$(eval $(call archive,JPEGOPTIM,   http://www.kokkonen.net/tjko/src/jpegoptim-[VER].tar.gz))
$(eval $(call archive,LIBJPEG,     http://www.ijg.org/files/jpegsrc.v[VER].tar.gz))
$(eval $(call archive,LIBMOZJPEG,  https://github.com/mozilla/mozjpeg/archive/v[VER].tar.gz))
$(eval $(call archive,LIBPNG,      http://prdownloads.sourceforge.net/libpng/libpng-[VER].tar.gz?download))
$(eval $(call archive,LIBZ,        http://prdownloads.sourceforge.net/libpng/zlib-[VER].tar.gz?download))
$(eval $(call archive,OPTIPNG,     http://prdownloads.sourceforge.net/optipng/optipng-[VER].tar.gz?download))
$(eval $(call archive,PNGCRUSH,    http://prdownloads.sourceforge.net/pmt/pngcrush-[VER]-nolib.tar.gz?download))
$(eval $(call archive,PNGQUANT,    https://github.com/pornel/pngquant/archive/[VER].tar.gz))

# ====== PRODUCTS ======

$(shell $(mkpath) $(OUTPUT_DIR)) # just create output dir

PRODUCTS :=

# $1 - product name
# $2 - archive name ($1 if empty)
# $3 - basename ($1 if empty)
define target-build
$1_BASENAME := $(or $3,$(call downcase,$1))
$1_DIR := $($(or $2,$1)_DIR)
$1_TGZ := $($(or $2,$1)_TGZ)
$1_TARGET := $$($1_DIR)/$$($1_BASENAME)
# first dependency on archive
$$($1_TARGET) $$($1_DIR)/__$$(notdir $$($1_TGZ))__ : $$($1_TGZ)
# second dependency on check file
$$($1_TARGET) : $$($1_DIR)/__$$(notdir $$($1_TGZ))__
endef

# $1 - product name
# $2 - archive name ($1 if empty)
# $3 - basename ($1 if empty)
define target
$(call target-build,$1,$2,$3)
PRODUCTS += $1
# copy product to output dir
$$(OUTPUT_DIR)/$$($1_BASENAME) : $$($1_TARGET)
	strip $$< -Sx -o $$@
# short name target
$(call downcase,$1) : | $$(OUTPUT_DIR)/$$($1_BASENAME)
endef

$(eval $(call target,ADVPNG,ADVANCECOMP))
$(eval $(call target,GIFSICLE))
$(eval $(call target,JHEAD))
$(eval $(call target,JPEG-RECOMPRESS,JPEGARCHIVE))
$(eval $(call target,JPEGOPTIM))
$(eval $(call target,JPEGTRAN,LIBJPEG))
$(eval $(call target,LIBJPEG,,libjpeg$(DLEXT)))
$(eval $(call target-build,LIBMOZJPEG,,libjpeg.a))
$(eval $(call target,LIBPNG,,libpng$(DLEXT)))
$(eval $(call target,LIBZ,,libz$(DLEXT)))
$(eval $(call target,OPTIPNG))
$(eval $(call target,PNGCRUSH))
$(eval $(call target,PNGQUANT))

# ====== TARGETS ======

all : $(call downcase,$(PRODUCTS))
	$(MAKE) test

download : $(foreach archive,$(ARCHIVES),$($(archive)_TGZ))
download-tidy-up :
	rm -f $(filter-out $(foreach archive,$(ARCHIVES),$($(archive)_TGZ)),$(wildcard $(DL_DIR)/*.*))

build : $(foreach product,$(PRODUCTS),$($(product)_TARGET))

define check_bin
	@test -f $(OUTPUT_DIR)/$1 || (echo "no $1"; false)
	@# if bin exists check architecture
	@test ! -f $(OUTPUT_DIR)/$1 || \
		file -b $(OUTPUT_DIR)/$1 | grep -q '$(ARCH_STRING)' || \
		(echo "Expected $(ARCH_STRING), got $$(file -b $(OUTPUT_DIR)/$1)"; false)
	@# if bin exists check and output version
	@test ! -f $(OUTPUT_DIR)/$1 || \
		$(OUTPUT_DIR)/$1 $2 | fgrep --color $3 || \
		(echo "Expected $3, got $$($(OUTPUT_DIR)/$1 $2)"; false)
endef

ifdef IS_DARWIN
test : ARCH_STRING := $(ARCH)
else ifeq (i686,$(ARCH))
test : ARCH_STRING := Intel 80386
else ifeq (x86_64,$(ARCH))
test : ARCH_STRING := x86-64
endif
test :
	$(if $(ARCH_STRING),,@echo Detecting 'ARCH $(ARCH) for OS $(OS) undefined'; false)
	$(call check_bin,advpng,--version 2>&1,$(ADVANCECOMP_VER))
	$(call check_bin,gifsicle,--version,$(GIFSICLE_VER))
	$(call check_bin,jhead,-V,$(JHEAD_VER))
	$(call check_bin,jpeg-recompress,--version,$(JPEGARCHIVE_VER))
	$(call check_bin,jpegoptim,--version,$(JPEGOPTIM_VER))
	$(call check_bin,jpegtran,-v - 2>&1,$(LIBJPEG_VER))
	$(call check_bin,optipng,--version,$(OPTIPNG_VER))
	$(call check_bin,pngcrush,-version 2>&1,$(PNGCRUSH_VER))
	$(call check_bin,pngquant,--help,$(PNGQUANT_VER))

livecheck : $(foreach archive,$(ARCHIVES),livecheck-$(call downcase,$(archive)))

update-versions :
	cat Makefile | script/update_versions > Makefile.tmp
	mv Makefile.tmp Makefile

# ====== CLEAN ======

clean :
	rm -rf $(BUILD_DIR)
	rm -rf $(OUTPUT_DIR)

clean-all :
	rm -rf $(BUILD_ROOT_DIR)
	rm -rf $(OUTPUT_ROOT_DIR)

clobber : clean-all
	rm -rf $(DL_DIR)

# ====== BUILDING ======

# $1 - name of product
# $2 - list of dependency products
define depend-build
# depend this product on every specified product
$$($1_TARGET) : $(foreach dep,$2,$$($(dep)_TARGET))
# add dependent product dir to CPATH, LIBRARY_PATH and PKG_CONFIG_PATH
$($1_TARGET) : export CPATH := $(subst $(eval) ,:,$(foreach dep,$2,$$($(dep)_DIR)))
$($1_TARGET) : export LIBRARY_PATH := $$(CPATH)
$($1_TARGET) : export PKG_CONFIG_PATH := $$(CPATH)
endef

# $1 - name of product
# $2 - list of dependency products
define depend
$(call depend-build,$1,$2)
# depend output of this product on output of every specified product
$$(OUTPUT_DIR)/$$($1_BASENAME) : $(foreach dep,$2,$$(OUTPUT_DIR)/$$($(dep)_BASENAME))
endef

define clean_untar
	rm -rf $(@D)
	$(mkpath) $(@D)
	tar -C $(@D) --strip-components=1 -m -xzf $<
	touch $(@D)/__$(notdir $<)__
endef

pkgconfig_pwd = perl -pi -e 's/(?<=dir=).*/$$ENV{PWD}/'

libtool_target_soname = cd $(@D) && perl -pi -e 's/(?<=soname_spec=)".*"/"$(@F)"/' -- libtool

chrpath_origin = $(if $(IS_DARWIN),,chrpath -r '$$ORIGIN' $1)

XORIGIN := -Wl,-rpath,XORIGIN
XORIGIN := $(if $(IS_DARWIN),,$(XORIGIN))

export CC = gcc
export CXX = g++

GCC_FLAGS := -O3
ifdef IS_DARWIN
GCC_FLAGS += -arch $(ARCH)
else
GCC_FLAGS += -s
endif
export CFLAGS := $(GCC_FLAGS)
export CXXFLAGS := $(GCC_FLAGS)
export CPPFLAGS := $(GCC_FLAGS)
export LDFLAGS := $(GCC_FLAGS)

ifdef IS_DARWIN
export MACOSX_DEPLOYMENT_TARGET=10.6
endif

## advpng
$(eval $(call depend,ADVPNG,LIBZ))
$(ADVPNG_TARGET) :; $(clean_untar)
	cd $(@D) && ./configure LDFLAGS="$(XORIGIN)"
	cd $(@D) && $(MAKE) advpng
	$(call chrpath_origin,$@)

## gifsicle
$(GIFSICLE_TARGET) :; $(clean_untar)
	cd $(@D) && ./configure
	cd $(@D) && $(MAKE) gifsicle
	cd $(@D) && $(ln_s) src/gifsicle .

## jhead
$(JHEAD_TARGET) :; $(clean_untar)
	cd $(@D) && $(MAKE) jhead CC="$(CC) $(GCC_FLAGS)"

## jpeg-recompress
$(eval $(call depend-build,JPEG-RECOMPRESS,LIBMOZJPEG))
$(JPEG-RECOMPRESS_TARGET) :; $(clean_untar)
	cd $(@D) && $(MAKE) jpeg-recompress CC="$(CC) $(GCC_FLAGS)" LIBJPEG=$(LIBMOZJPEG_TARGET)

## jpegoptim
$(eval $(call depend,JPEGOPTIM,LIBJPEG))
$(JPEGOPTIM_TARGET) :; $(clean_untar)
	cd $(@D) && ./configure LDFLAGS="$(XORIGIN)" --host $(HOST)
	cd $(@D) && $(MAKE) jpegoptim
	$(call chrpath_origin,$@)

## jpegtran
$(eval $(call depend,JPEGTRAN,LIBJPEG))
$(JPEGTRAN_TARGET) :; # built in $(LIBJPEG_TARGET)

## libjpeg
$(LIBJPEG_TARGET) :; $(clean_untar)
	cd $(@D) && ./configure CC="$(CC) $(GCC_FLAGS)"
	$(libtool_target_soname)
ifdef IS_DARWIN
	cd $(@D) && $(MAKE) libjpeg.la LDFLAGS="-Wl,-install_name,@loader_path/$(@F)"
else
	cd $(@D) && $(MAKE) libjpeg.la
endif
	cd $(@D) && $(MAKE) jpegtran LDFLAGS="$(XORIGIN)"
	cd $(@D) && $(ln_s) .libs/libjpeg$(DLEXT) .libs/jpegtran .
	$(call chrpath_origin,$(JPEGTRAN_TARGET))

## libmozjpeg
$(LIBMOZJPEG_TARGET) :; $(clean_untar)
	cd $(@D) && autoreconf -fiv
	cd $(@D) && ./configure --host $(HOST)
	cd $(@D)/simd && $(MAKE)
	cd $(@D) && $(MAKE) libjpeg.la
	cd $(@D) && $(ln_s) .libs/libjpeg.a .

## libpng
$(eval $(call depend,LIBPNG,LIBZ))
$(LIBPNG_TARGET) :; $(clean_untar)
	cd $(@D) && ./configure CC="$(CC) $(GCC_FLAGS)"
	cd $(@D) && $(pkgconfig_pwd) -- *.pc
	cd $(@D) && perl -pi -e 's/(?<=lpng)\d+//g' -- *.pc # %MAJOR%%MINOR% suffix
	$(libtool_target_soname)
ifdef IS_DARWIN
	cd $(@D) && $(MAKE) libpng16.la LDFLAGS="-Wl,-install_name,@loader_path/$(@F)"
else
	cd $(@D) && $(MAKE) libpng16.la LDFLAGS="$(XORIGIN)"
endif
	cd $(@D) && $(ln_s) .libs/libpng16$(DLEXT) libpng$(DLEXT)
	$(call chrpath_origin,$@)

## libz
ifdef IS_DARWIN
$(LIBZ_TARGET) : export LDSHARED = $(CC) -dynamiclib -install_name @loader_path/$(@F) -compatibility_version 1 -current_version $(LIBZ_VER)
else
$(LIBZ_TARGET) : export LDSHARED = $(CC) -shared -Wl,-soname,$(@F),--version-script,zlib.map
endif
$(LIBZ_TARGET) :; $(clean_untar)
	cd $(@D) && ./configure
	cd $(@D) && $(pkgconfig_pwd) -- *.pc
	cd $(@D) && $(MAKE) placebo

## optipng
$(eval $(call depend,OPTIPNG,LIBPNG LIBZ))
$(OPTIPNG_TARGET) :; $(clean_untar)
	cd $(@D) && ./configure -with-system-libs
	cd $(@D) && $(MAKE) all LDFLAGS="$(XORIGIN) $(GCC_FLAGS)"
	cd $(@D) && $(ln_s) src/optipng/optipng .
	$(call chrpath_origin,$@)

## pngcrush
$(eval $(call depend,PNGCRUSH,LIBPNG LIBZ))
$(PNGCRUSH_TARGET) :; $(clean_untar)
	cd $(@D) && rm -f png.h pngconf.h
	cd $(@D) && $(MAKE) -f Makefile pngcrush \
		LIBS="-lpng -lz -lm" \
		CFLAGS="$(GCC_FLAGS)" \
		LDFLAGS="$(XORIGIN) $(GCC_FLAGS)"
	$(call chrpath_origin,$@)

## pngquant
$(eval $(call depend,PNGQUANT,LIBPNG LIBZ))
$(PNGQUANT_TARGET) :; $(clean_untar)
	cd $(@D) && ./configure --without-cocoa --extra-ldflags="$(XORIGIN)"
	cd $(@D) && $(MAKE) pngquant
	$(call chrpath_origin,$@)
