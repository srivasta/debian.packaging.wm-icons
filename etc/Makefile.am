## Process this file with automake to produce Makefile.in
## You probably want to run automake from the top-level directory, though
## Makefile.am for subdirectories of wm-icons package
## Copyright 1999, Julian Gilbey <jdg@debian.org>
## This file may be copied under the conditions of the GNU General
## Public License, version 2 or later.  NO warranty of any kind is
## given.

AUTOMAKE_OPTIONS = foreign

configdir = @datadir@/wm-icons

config_DATA = fvwm2rc-compact-buttons fvwm95rc-wm-icons \
	fvwm1rc-wm-icons fvwm2rc-wm-icons scwmrc-wm-icons

EXTRA_DIST = fvwm2rc-compact-buttons.in fvwm95rc-wm-icons.in \
	fvwm1rc-wm-icons.in fvwm2rc-wm-icons.in scwmrc-wm-icons.in

CLEANFILES = $(config_DATA)
SUFFIXES = .in

at = @

editex = sed -e 's,$(at)icondir@,$(icondir),g' -e 's,$(at)userdir@,$(userdir),g'

.in:
	rm -f $@ $@.tmp
	$(editex) $< > $@.tmp && mv $@.tmp $@

