## Process this file with automake to produce Makefile.in
## You probably want to run automake from the top-level directory, though
## Makefile.am for the subdirectory devel/bin of the wm-icons package
## Copyright 1999, Julian Gilbey <jdg@debian.org>
## This file may be copied under the conditions of the GNU General
## Public License, version 2 or later.  NO warranty of any kind is
## given.

AUTOMAKE_OPTIONS = foreign

EXTRA_DIST = create-wm-config.pl pack-symlinks unpack-symlinks

# The rest of this Makefile is only used if the maintainer mode has
# been requested
CLEANFILES = create-wm-config
SUFFIXES = .pl

mytrans = -e 's,^\#! */usr/bin/perl,\#! $(PERL),'

editpl = sed $(mytrans)

.pl:
	       rm -f $@ $@.tmp
	       $(editpl) $< > $@.tmp && chmod +x $@.tmp && mv $@.tmp $@

wm-configs: create-wm-config
	       ./create-wm-config fvwm1  wm-icons
	       ./create-wm-config fvwm2  wm-icons
	       ./create-wm-config fvwm95 wm-icons
	       ./create-wm-config scwm   wm-icons
	       ./create-wm-config fvwm2  compact-buttons

_pack-symlinks: pack-symlinks
	       ./pack-symlinks

_unpack-symlinks: unpack-symlinks
	       ./unpack-symlinks

