dnl                               -*- Autoconf -*-
dnl Process this file with autoconf to produce a configure script
dnl or use autogen.sh (recommended)
dnl
dnl Copyright (C) 2012-2015 SUSE Linux GmbH
dnl
dnl Authors:
dnl Frank Sundermeyer <fsundermeyer at opensuse dot org>
dnl Thomas Schraitle  <toms at opensuse dot org>
dnl

m4_define(daps_version_major, 2)
m4_define(daps_version_minor, 0)
m4_define(daps_version_micro, [0-rc6])
# API version
m4_define([daps_api_version],[daps_version_major])

m4_define([daps_version], [daps_version_major.daps_version_minor.daps_version_micro])

AC_PREREQ([2.68])
AC_INIT([DAPS], [daps_version], [https://github.com/openSUSE/daps], [daps], [http://opensuse.github.io/daps])
AC_CONFIG_MACRO_DIR([m4])

DAPS_VERSION_MAJOR=daps_version_major
DAPS_VERSION_MINOR=daps_version_minor
DAPS_VERSION_MICRO=daps_version_micro
DAPS_VERSION=daps_version
DAPS_API_VERSION=daps_api_version
AC_SUBST(DAPS_VERSION)
AC_SUBST(DAPS_VERSION_MAJOR)
AC_SUBST(DAPS_VERSION_MINOR)
AC_SUBST(DAPS_VERSION_MICRO)
AC_SUBST(PACKAGE_VERSION)
AC_SUBST([DAPS_API_VERSION],daps_api_version)
dnl https://stackoverflow.com/questions/18769770/user-of-autotools-generated-tarball-gets-error-message-aclocal-1-13-command-no
AM_MAINTAINER_MODE([disable])

AC_MSG_NOTICE([

 Configuring DAPS $DAPS_VERSION, the DocBook Authoring and Publishing Suite...

])

AC_CONFIG_SRCDIR([Makefile.am])
AM_INIT_AUTOMAKE([1.10])
AC_PREFIX_DEFAULT(/usr)

dnl Some constants
root_catalog="/etc/xml/catalog"
AC_SUBST(root_catalog)
db4_xslt_url="http://docbook.sourceforge.net/release/xsl/current/"
AC_SUBST(db4_xslt_url)
DB5_XSLT_URL="http://docbook.sourceforge.net/release/xsl-ns/current/"
daps_xsl="/usr/share/xml/docbook/stylesheet/daps2012"
AC_SUBST(daps_xsl)
FONT_DIR="/usr/share/fonts"

dnl -------------------------
dnl Debug mode switch
dnl $DEBUG is used with bin/daps
dnl $Q is the quiet switch for the Makefile

AC_ARG_ENABLE([debug],
    [AC_HELP_STRING([--enable-debug], [Enable debug mode])],
      [debug="--debug"], [quiet="@"])
eval "eval DEBUG=$debug Q=$quiet"


dnl -------------------------
dnl Switch for disabling xml root catalog editing
dnl Needs to be disabled when creating real packages, because
dnl this needs to be done with the package's post-install
dnl commands

AC_ARG_ENABLE([edit-rootcatalog],
    [AC_HELP_STRING([--disable-edit-rootcatalog], [Disable editing the XML root catalog. Use this switch when running make install from a package generating script (such as a spec file).])],
      [if test "yes" = $enableval; then cat_edit=1; else cat_edit=0; fi],
      [cat_edit=1])
AM_CONDITIONAL([CATALOG_EDIT], [test 1 = $cat_edit])

AC_SUBST(DEBUG)
AC_SUBST(Q)

dnl -------------------------
dnl Checks for programs.
AC_PROG_MKDIR_P
AC_PROG_LN_S
AC_PROG_SED
AC_PROG_GREP
AC_PROG_INSTALL

dnl bash
dnl Taken from https://github.com/Schischu/ptxdist_sh/blob/master/configure.ac
dnl
dnl unset BASH # bash sets this itself!
dnl AC_PATH_PROG(BASH, bash)

dnl BEWARE: There is a distinct possibility that we are currently running under
dnl bash in this configure script (/bin/sh being a symlink to /bin/bash). Even
dnl though the result /could/ be available to us directly as $BASH_VERSION we
dnl don't want to use, or trust it, incase the user is specifying a different
dnl bash executable.

dnl AC_MSG_CHECKING([for bash version])

dnl if `$BASH -c '[[ "$BASH_VERSION" \< "4.0" ]]'` ; then
dnl    AC_MSG_ERROR([DAPS requires at least version 4.0 of bash.])
dnl else
dnl    AC_MSG_RESULT([$BASH_VERSION])
dnl fi


dnl make
AC_PATH_PROG([MAKE], [make], [0])
if test 0 = "$MAKE"; then
   AC_MSG_ERROR([make not found]) 
fi

dnl tar
AC_PATH_PROG([TAR], [tar], [0])

dnl bzip2
AC_PATH_PROG([BZIP], [bzip2], [0])

dnl epubcheck
AC_PATH_PROG([EPUBCHECK], [epubcheck], [0])

dnl checkbot
AC_PATH_PROG([CHECKBOT], [checkbot], [0])

dnl remake
AC_PATH_PROG([REMAKE], [remake], [0])

dnl w3m
AC_PATH_PROG([W3M], [w3m], [0])

dnl -------------------------------------------------------------------------
AC_MSG_NOTICE([===== Checking for XML tools... ])

AC_PATH_PROG([XMLLINT], [xmllint], [0])
if test 0 = "$XMLLINT"; then
   AC_MSG_ERROR([xmllint not found])
fi

AC_PATH_PROG([XSLTPROC], [xsltproc], [0])
if test 0 = "$XSLTPROC"; then
   AC_MSG_ERROR([xsltproc (libxslt) not found]) 
fi

AC_PATH_PROG([XMLCATALOG], [xmlcatalog], [0])
if test 0 = "$XMLCATALOG"; then
   AC_MSG_ERROR([xmlcatalog not found]) 
fi

AC_PATH_PROGS([PDFFORMATTER], [fop xep], [0])

dnl recommendation, only needed for Docbook5
AC_PATH_PROG([JING], [jing], [0])

AC_CHECK_FILE([$root_catalog], [CATALOG=$root_catalog], [CATALOG=0])
if test 0 = "$CATALOG"; then
  AC_MSG_ERROR([Catalog $root_catalog not found])
fi

dnl -------------------------------------------------------------------------
AC_MSG_NOTICE([===== Checking for Image conversion tools...])
                     
dnl convert (ImageMagick)
AC_PATH_PROG([CONVERT], [convert], [0])
if test 0 = "$CONVERT"; then
   AC_MSG_ERROR([convert (ImageMagick) not found]) 
fi

dnl dia
AC_PATH_PROG([DIA], [dia], [0])

dnl exiftool
AC_PATH_PROG([EXIFTOOL], [exiftool], [0])

dnl ghostscript
AC_PATH_PROG([GS], [gs], [0])

dnl inkscape
AC_PATH_PROG([INKSCAPE], [inkscape], [0])

dnl optipng
AC_PATH_PROG([OPTIPNG], [optipng], [0])

dnl pdffonts
AC_PATH_PROG([PDFFONTS], [pdffonts], [0])

dnl xfig
AC_PATH_PROG([XFIG], [xfig], [0])

dnl svg DTD
for SVG_DTD in "-//W3C//DTD SVG 1.0//EN" \
               "-//W3C//DTD SVG 1.1 Basic//EN" ; do
  AC_MSG_CHECKING([for $SVG_DTD])
  if AC_RUN_LOG([$XMLCATALOG --noout "$root_catalog" "$SVG_DTD" >&2]); then
    AC_MSG_RESULT([yes])
    HAVE_SVGDTD=1
  else
    AC_MSG_RESULT([no])
  fi
done
if test -z "$HAVE_SVGDTD"; then
  HAVE_SVGDTD=0
fi               

dnl -------------------------------------------------------------------------
AC_MSG_NOTICE([===== Checking for Python modules...])

dnl python
dnl We require Python3
dnl AM_PATH_PYTHON([3.2])
AM_PATH_PYTHON([2.6])

dnl Variables HAVE_PYMOD_* are filled with "yes" or "no"
AC_PYTHON_MODULE([xml], [fatal])
AC_SUBST(HAVE_PYMOD_XML)

dnl AC_PYTHON_MODULE([lxml], [fatal])
dnl AC_SUBST(HAVE_PYMOD_LXML)


dnl --------------------------------------------------------------------------
AC_MSG_NOTICE([===== Checking for DocBook...])

for XML_DTD in "-//OASIS//DTD DocBook XML V4.1.2//EN" \
               "-//OASIS//DTD DocBook XML V4.2//EN" \
               "-//OASIS//DTD DocBook XML V4.3//EN" \
               "-//OASIS//DTD DocBook XML V4.4//EN" \
               "-//OASIS//DTD DocBook XML V4.5//EN" ; do
  AC_MSG_CHECKING([for $XML_DTD])
  if AC_RUN_LOG([$XMLCATALOG --noout "$root_catalog" "$XML_DTD" >&2]); then
    AC_MSG_RESULT([yes])
    HAVE_DOCBOOK=1
  else
    AC_MSG_RESULT([no])
  fi
done
if test -z "$HAVE_DOCBOOK"; then
  AC_MSG_ERROR([No DocBook 4 DTD not found])
fi

dnl Docbook 5
for XML_SCHEMA in "http://docbook.org/xml/5.0/rng/docbookxi.rng" \
                  "http://docbook.org/xml/5.0/rng/docbookxi.rnc" \
                  "http://docbook.org/xml/5.0/rng/docbook.rng" \
                  "http://docbook.org/xml/5.0/rng/docbook.rnc" ; do
  AC_MSG_CHECKING([for $XML_SCHEMA])
  if AC_RUN_LOG([$XMLCATALOG --noout "$root_catalog" "$XML_DTD" >&2]); then
    AC_MSG_RESULT([yes])
    HAVE_DOCBOOK_5=1
  else
    AC_MSG_RESULT([no])
  fi
done
if test -z "$HAVE_DOCBOOK_5"; then
  HAVE_DOCBOOK_5=0
fi

dnl -------------------------------------------------------------------------
AC_MSG_NOTICE([===== Checking for DocBook XSL Stylesheets...])

dnl DocBook4
for XSLT in "${db4_xslt_url}common/common.xsl" \
            "${db4_xslt_url}epub/docbook.xsl" \
            "${db4_xslt_url}fo/docbook.xsl" \
            "${db4_xslt_url}html/chunk.xsl" \
            "${db4_xslt_url}html/docbook.xsl" \
            "${db4_xslt_url}lib/lib.xsl" \
            "${db4_xslt_url}manpages/docbook.xsl" \
            "${db4_xslt_url}profiling/profile.xsl" \
            "${db4_xslt_url}xhtml/chunk.xsl" \
            "${db4_xslt_url}xhtml/docbook.xsl"; do
  AC_MSG_CHECKING([for $XSLT])
  if AC_RUN_LOG([$XMLCATALOG --noout "$root_catalog" "$XSLT" >&2]); then
    AC_MSG_RESULT([yes])
    HAVE_DOCBOOK_STYLESHEETS=1
  else
    AC_MSG_RESULT([no])
  fi
done
if test -z "$HAVE_DOCBOOK_STYLESHEETS"; then
  AC_MSG_ERROR([DocBook 4 stylesheets not found])
fi

dnl DocBook5
for XSLT in "${DB5_XSLT_URL}common/common.xsl" \
            "${DB5_XSLT_URL}epub/docbook.xsl" \
            "${DB5_XSLT_URL}fo/docbook.xsl" \
            "${DB5_XSLT_URL}html/chunk.xsl" \
            "${DB5_XSLT_URL}html/docbook.xsl" \
            "${DB5_XSLT_URL}lib/lib.xsl" \
            "${DB5_XSLT_URL}manpages/docbook.xsl" \
            "${DB5_XSLT_URL}profiling/profile.xsl" \
            "${DB5_XSLT_URL}xhtml/chunk.xsl" \
            "${DB5_XSLT_URL}xhtml/docbook.xsl"; do
  AC_MSG_CHECKING([for $XSLT])
  if AC_RUN_LOG([$XMLCATALOG --noout "$root_catalog" "$XSLT" >&2]); then
    AC_MSG_RESULT([yes])
    HAVE_DOCBOOK_5_STYLESHEETS=1

  else
    AC_MSG_RESULT([no])
  fi
done
if test -z "$HAVE_DOCBOOK_5_STYLESHEETS"; then
  HAVE_DOCBOOK_5_STYLESHEETS=0
fi

dnl -------------------------------------------------------------------------
dnl Check which Stylesheets to use
AM_CONDITIONAL([HAS_DAPS_XSL], [test -d $daps_xsl])

dnl -------------------------------------------------------------------------
dnl Add more distributions if needed
AM_CONDITIONAL([DIST_REDHAT], [egrep -iq "^NAME=\"?(fedora|redhat)\"?" /etc/os-release])
AM_CONDITIONAL([DIST_SUSE], [egrep -iq "^NAME=\"?(opensuse|sles|sled)\"?" /etc/os-release])
AM_CONDITIONAL([DIST_UBUNTU], [egrep -iq "^NAME=\"?(ubuntu|debian)\"?" /etc/os-release])

dnl No distribution-specific info in the BuildService 
dnl /var/adm/fillup-templates is SUSE-specific
AM_CONDITIONAL([DIST_SUSEBS], [test -d /var/adm/fillup-templates])
dnl -------------------------------------------------------------------------
AC_OUTPUT([Makefile])
AC_OUTPUT([doc/xml/entity-decl.ent])

AC_MSG_RESULT([
dnl ###########################################################################
DAPS $DAPS_VERSION is configured as follows.  Please verify that this configuration matches
your expectations.

Supported features
------------------
* DocBook 4 support                  * man pages output
* HTML/single HTML output            * webhelp output (experimental)
* ePUB output                        * png and jpg images

Optional features
-----------------
Feature                          | Enabled | Action to enable
..............................................................................])
dnl DocBook 5
test 0 = "$HAVE_DOCBOOK_5" && DB5=0
test 0 = "$HAVE_DOCBOOK_5_STYLESHEETS" && DB5=0
test 0 = "$HAVE_JING" && DB5=0

if test 0 = "$DB5"; then
  AC_MSG_RESULT([DocBook 5 support                |    no   | install DocBook 5, the
                                 |         | DocBook 5 XSL stylesheets,
                                 |         | and jing
])
else
  AC_MSG_RESULT([DocBook 5 support                |   yes   |])
fi

dnl Create ASCII (w3m)
if test 0 = "$W3M"; then
  AC_MSG_RESULT([Create ASCII txt output          |    no   | install w3m])
else
  AC_MSG_RESULT([Create ASCII txt output          |   yes   |])
fi

dnl Create PDFs (fop, xep)
if test 0 = "$PDFFORMATTER"; then
  AC_MSG_RESULT([Create PDF output                |    no   | install a formatter (fop or xep)
])
else
  AC_MSG_RESULT([Create PDF output                |   yes   |])
fi

dnl DIA support
if test 0 = "$DIA"; then
  AC_MSG_RESULT([Support for .dia images          |    no   | install dia])
else
  AC_MSG_RESULT([Support for .dia images          |   yes   |])
fi

dnl SVG support
if test 0 = "$INKSCAPE" -o 0 = "$HAVE_SVGDTD"; then
  AC_MSG_RESULT([Support for .svg images          |    no   | install inkscape and/or the SVG DTD])
else
  AC_MSG_RESULT([Support for .svg images          |   yes   |])
fi

dnl XFIG support
if test 0 = "$XFIG"; then
  AC_MSG_RESULT([Support for .fig images          |    no   | install xfig (transfig)])
else
  AC_MSG_RESULT([Support for .fig images          |   yes   |])
fi

dnl Optimize PNGs (optipng)
if test 0 = "$OPTIPNG" -o 0 = "$EXIFTOOL"; then
  AC_MSG_RESULT([Size optimization for .png       |    no   | install optipng and/or exiftool
])
else
  AC_MSG_RESULT([Size optimization for .png       |   yes   |])
fi

dnl Linkchecker (checkbot)
if test 0 = "$CHECKBOT"; then
  AC_MSG_RESULT([Check links in XML sources       |    no   | install checkbot])
else
  AC_MSG_RESULT([Check links in XML sources       |   yes   |])
fi

dnl Create archives (tar, bzip2)
if test 0 = "$TAR" -o 0 = "$BZIP"; then
  AC_MSG_RESULT([Create distributable archives    |    no   | install tar and/or bzip2])
else
  AC_MSG_RESULT([Create distributable archives    |   yes   |])
fi

dnl Validate ePUBs (epubcheck)
if test 0 = "$EPUBCHECK"; then
  AC_MSG_RESULT([Validate generated ePUB files    |    no   | install epubcheck])
else
  AC_MSG_RESULT([Validate generated ePUB files    |   yes   |])
fi

dnl PDF font summary (pdffonts)
if test 0 = "$PDFFONTS"; then
  AC_MSG_RESULT([Show fonts not embedded in PDFs  |    no   | install poppler utilities/tools
])
else
  AC_MSG_RESULT([Show fonts not embedded in PDFs  |   yes   |])
fi

dnl Enhanced Debugging (remake)
if test 0 = "$REMAKE"; then
  AC_MSG_RESULT([Enhanced debugging               |    no   | install remake])
else
  AC_MSG_RESULT([Enhanced debugging               |   yes   |])
fi


AC_MSG_RESULT([
Experimental features
---------------------
Feature                          | Enabled | Action to enable
..............................................................................])
dnl PDF/EPS images support(ghostscript (gs))
if test 0 = "$GS"; then
  AC_MSG_RESULT([Support for .pdf and .eps images |    no   | install ghostscript])
else
  AC_MSG_RESULT([Support for .pdf and .eps images |   yes   |])
fi

dnl Evil magic

eval "eval SYSCONFDIR=$sysconfdir/daps"
eval "eval DATADIR=$datadir/daps"
eval "eval BINDIR=$bindir"
eval "eval DOCDIR=$docdir"

AC_MSG_RESULT([

DAPS will be installed into the following paths:
------------------------------------------------
Executables             : $BINDIR
System wide config files: $SYSCONFDIR
Documentation           : $DOCDIR
Everything else         : $DATADIR
])
