#%define prefix %{_prefix}
%define prefix /usr

%define ver 0.4.0
%define rel 1
%define c_p --enable-all-sets
%define m_p CFLAGS="-O2"

%define _sourcedir /tmp

Summary:   Window Manager Icons, themable icon distribution
Name:      wm-icons
Version:   %{ver}
Release:   %{rel}
License:   GPL
Group:     X11/Window Managers
Source:    %{name}-%{version}.tar.gz
URL:       http://wm-icons.sourceforge.org/
BuildRoot: %{_tmppath}/%{name}-%{version}-root
Packager:  FVWM Themes Developers <fvwm-themes-devel@lists.sourceforge.net>
Autoreq:   1

#Requires:  perl >= 5.002
#Provides:  wm-icons

Docdir:    %{prefix}/share/doc

%description
The Window Manager Icons is an efficient icon distribution designed to
be standardized and configurable.  Includes several themed icon sets,
scripts and configurations for several window managers.

%prep
%setup

%build
./configure --prefix=%{prefix} --mandir='${prefix}'/share/man %{c_p}
make %{m_p}

%install
rm -rf $RPM_BUILD_ROOT
make prefix=$RPM_BUILD_ROOT%{prefix} ROOT_PREFIX=$RPM_BUILD_ROOT install

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-, root, root)

%doc AUTHORS COPYING INSTALL NEWS README TODO
%doc doc/FAQ doc/README.3dpixmaps doc/README.martys doc/README.penguins
%doc doc/icons.lst doc/wm-icons.lsm

%{prefix}/bin/*
%{prefix}/share/wm-icons
%{prefix}/share/icons/wm-icons
%{prefix}/share/man/*/*

%define date%(env LC_ALL=C date +"%a %b %d %Y")
%changelog
* %{date} Window Manager Icons Developers <wm-icons-devel@lists.sourceforge.net>
  - Auto building %{PACKAGE_VERSION}
* Sat Sep 07 2000 Mikhael Goikhman <migo@cpan.org>
  - First try at making the package
