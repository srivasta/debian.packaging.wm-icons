## Process this file with automake to produce Makefile.in
## Makefile.am for wm-icons package
## Copyright 1999, Julian Gilbey <jdg@debian.org>
## This file may be copied under the conditions of the GNU General
## Public License, version 2 or later.  NO warranty of any kind is
## given.

AUTOMAKE_OPTIONS = foreign

SUBDIRS = bin doc icons etc devel rpm

# We need to specify --user-dir here in case the prefix (=> datadir
# => icondir) is different for the build and install phases, as it
# is for a distribution package building.
install-data-local:
	# set the default icon set aliases (symlinks)
	$(bindir)/wm-icons-config --user-dir="$(icondir)" --defaults --quiet

wm-configs _pack-symlinks _unpack-symlinks:
	cd devel/bin && $(MAKE) $(AM_MAKEFLAGS) $@

## ---------------------------------------------------------------------------
## Manage bzip2 archive together with gzip archive
#  Usage:
#    make dist2       # instead of make dist
#    make distcheck2  # instead of make distcheck
#    make distclean2  # instead of make distclean

dist2: dist
	gzip -dc $(distdir).tar.gz | bzip2 -9c >$(distdir).tar.bz2

distcheck2: dist2 distcheck
	@banner="$(distdir).tar.bz2 - ready for distribution"; \
	dashes=`echo "$$banner" | sed s/./=/g`; \
	echo "$$banner"; \
	echo "$$dashes"

distclean2: distclean

## ---------------------------------------------------------------------------
## Produce an rpm package using dist or from the given tarball
#  Usage:
#    make rpm-dist
#    make release=1 rpm-dist
#    make rpm-this
#    make version=2.3.22 release=2 rpm-this
#    make rpm-dist cparams='--enable-kanji --quiet' mparams='CFLAGS="-O2 -g"'

rpm-dist: dist rpm-this

rpm-this:
	(cd rpm && $(MAKE) $(AM_MAKEFLAGS) rpm) || exit 1
