## Process this file with automake to produce Makefile.in
## You probably want to run automake from the top-level directory, though
## Makefile.am for subdirectories of wm-icons package
## Copyright 1999, Julian Gilbey <jdg@debian.org>
## This file may be copied under the conditions of the GNU General
## Public License, version 2 or later.  NO warranty of any kind is
## given.

AUTOMAKE_OPTIONS = foreign

configdir = @datadir@/wm-icons/debian-menu-system

config_DATA = wm-icons.h wm-icons-data.h wm-icons-fvwm2rc-menu README

EXTRA_DIST = wm-icons.h.in wm-icons-data.h.in wm-icons-fvwm2rc-menu.in

CLEANFILES = wm-icons.h wm-icons-data.h wm-icons-fvwm2rc-menu

SUFFIXES = .in

at = @

editex = sed -e 's,$(at)icondir@,$(icondir),g' -e 's,$(at)userdir@,$(userdir),g'

.in:
	rm -f $@ $@.tmp
	$(editex) $< > $@.tmp && mv $@.tmp $@
