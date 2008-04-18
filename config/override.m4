dnl Fix Autoconf-2.59 bugs: by overriding broken internal
dnl Autoconf macros with backports of the 2.60+ fix.
dnl - AC_CONFIG_SUBDIRS whitespace mangling,
dnl - more lenient precious variable checks
dnl
dnl This file should be a no-op for Autoconf versions != 2.59.
dnl It can be removed once the complete tree has moved to a
dnl newer Autoconf version.

dnl m4_PACKAGE_VERSION is an undocumented Autoconf macro.
dnl We use it because this fix is intended for 2.59 only.
dnl A feature test for the broken AC_CONFIG_SUBDIRS instead
dnl would be better but is tricky.
dnl
dnl Use ifdef/ifelse over m4_ifdef/m4_ifelse to be clean for 2.13.
dnl Redefine AC_CONFIG_SUBDIRS so aclocal pulls in this file
dnl when needed.

ifdef([m4_PACKAGE_VERSION],
[ifelse(m4_PACKAGE_VERSION, [2.59], [

dnl AC_DEFUN a commonly used macro so this file is picked up.
m4_copy([AC_PREREQ], [_AC_PREREQ])
AC_DEFUN([AC_PREREQ], [frob])
m4_copy([_AC_PREREQ], [AC_PREREQ])

dnl Override the broken macro.
# _AC_OUTPUT_SUBDIRS
# ------------------
# This is a subroutine of AC_OUTPUT, but it does not go into
# config.status, rather, it is called after running config.status.
m4_define([_AC_OUTPUT_SUBDIRS],
[
#
# CONFIG_SUBDIRS section, as fixed in confsubdir.m4.
#
if test "$no_recursion" != yes; then

  # Remove --cache-file and --srcdir arguments so they do not pile up.
  ac_sub_configure_args=
  ac_prev=
  eval "set x $ac_configure_args"
  shift
  for ac_arg
  do
    if test -n "$ac_prev"; then
      ac_prev=
      continue
    fi
    case $ac_arg in
    -cache-file | --cache-file | --cache-fil | --cache-fi \
    | --cache-f | --cache- | --cache | --cach | --cac | --ca | --c)
      ac_prev=cache_file ;;
    -cache-file=* | --cache-file=* | --cache-fil=* | --cache-fi=* \
    | --cache-f=* | --cache-=* | --cache=* | --cach=* | --cac=* | --ca=* \
    | --c=*)
      ;;
    --config-cache | -C)
      ;;
    -srcdir | --srcdir | --srcdi | --srcd | --src | --sr)
      ac_prev=srcdir ;;
    -srcdir=* | --srcdir=* | --srcdi=* | --srcd=* | --src=* | --sr=*)
      ;;
    -prefix | --prefix | --prefi | --pref | --pre | --pr | --p)
      ac_prev=prefix ;;
    -prefix=* | --prefix=* | --prefi=* | --pref=* | --pre=* | --pr=* | --p=*)
      ;;
    *)
      case $ac_arg in
      *\'*) ac_arg=`echo "$ac_arg" | sed "s/'/'\\\\\\\\''/g"` ;;
      esac
      ac_sub_configure_args="$ac_sub_configure_args '$ac_arg'" ;;
    esac
  done

  # Always prepend --prefix to ensure using the same prefix
  # in subdir configurations.
  ac_arg="--prefix=$prefix"
  case $ac_arg in
  *\'*) ac_arg=`echo "$ac_arg" | sed "s/'/'\\\\\\\\''/g"` ;;
  esac
  ac_sub_configure_args="$ac_arg $ac_sub_configure_args"

  ac_popdir=`pwd`
  for ac_dir in : $subdirs; do test "x$ac_dir" = x: && continue

    # Do not complain, so a configure script can configure whichever
    # parts of a large source tree are present.
    test -d "$srcdir/$ac_dir" || continue

    AC_MSG_NOTICE([configuring in $ac_dir])
    AS_MKDIR_P(["$ac_dir"])
    _AC_SRCPATHS(["$ac_dir"])

    cd "$ac_dir"

    # Check for guested configure; otherwise get Cygnus style configure.
    if test -f "$ac_srcdir/configure.gnu"; then
      ac_sub_configure=$ac_srcdir/configure.gnu
    elif test -f "$ac_srcdir/configure"; then
      ac_sub_configure=$ac_srcdir/configure
    elif test -f "$ac_srcdir/configure.in"; then
      # This should be Cygnus configure.
      ac_sub_configure=$ac_aux_dir/configure
    else
      AC_MSG_WARN([no configuration information is in $ac_dir])
      ac_sub_configure=
    fi

    # The recursion is here.
    if test -n "$ac_sub_configure"; then
      # Make the cache file name correct relative to the subdirectory.
      case $cache_file in
      [[\\/]]* | ?:[[\\/]]* ) ac_sub_cache_file=$cache_file ;;
      *) # Relative path.
	ac_sub_cache_file=$ac_top_builddir$cache_file ;;
      esac

      AC_MSG_NOTICE([running $SHELL $ac_sub_configure $ac_sub_configure_args --cache-file=$ac_sub_cache_file --srcdir=$ac_srcdir])
      # The eval makes quoting arguments work.
      eval "\$SHELL \"\$ac_sub_configure\" $ac_sub_configure_args \
	   --cache-file=\"\$ac_sub_cache_file\" --srcdir=\"\$ac_srcdir\"" ||
	AC_MSG_ERROR([$ac_sub_configure failed for $ac_dir])
    fi

    cd "$ac_popdir"
  done
fi
])# _AC_OUTPUT_SUBDIRS

# _AC_ARG_VAR_VALIDATE
# --------------------
# The code is the same as autoconf 2.59, but with a more lenient check
# on precious variables that has been added in autoconf 2.62.
m4_define([_AC_ARG_VAR_VALIDATE],
[# Check that the precious variables saved in the cache have kept the same
# value.
ac_cache_corrupted=false
for ac_var in `(set) 2>&1 |
	       sed -n 's/^ac_env_\([[a-zA-Z_0-9]]*\)_set=.*/\1/p'`; do
  eval ac_old_set=\$ac_cv_env_${ac_var}_set
  eval ac_new_set=\$ac_env_${ac_var}_set
  eval ac_old_val="\$ac_cv_env_${ac_var}_value"
  eval ac_new_val="\$ac_env_${ac_var}_value"
  case $ac_old_set,$ac_new_set in
    set,)
      AS_MESSAGE([error: `$ac_var' was set to `$ac_old_val' in the previous run], 2)
      ac_cache_corrupted=: ;;
    ,set)
      AS_MESSAGE([error: `$ac_var' was not set in the previous run], 2)
      ac_cache_corrupted=: ;;
    ,);;
    *)
      if test "x$ac_old_val" != "x$ac_new_val"; then
        # differences in whitespace do not lead to failure.
        ac_old_val_w=`echo x $ac_old_val`
        ac_new_val_w=`echo x $ac_new_val`
        if test "$ac_old_val_w" != "$ac_new_val_w"; then
          AS_MESSAGE([error: `$ac_var' has changed since the previous run:], 2)
          ac_cache_corrupted=:
        else
          AS_MESSAGE([warning: ignoring whitespace changes in `$ac_var' since the previous run:], 2)
          eval $ac_var=\$ac_old_val
        fi
        AS_MESSAGE([  former value:  `$ac_old_val'], 2)
        AS_MESSAGE([  current value: `$ac_new_val'], 2)
      fi;;
  esac
  # Pass precious variables to config.status.
  if test "$ac_new_set" = set; then
    case $ac_new_val in
dnl If you change this globbing pattern, test it on an old shell --
dnl it's sensitive.  Putting any kind of quote in it causes syntax errors.
[    *" "*|*"	"*|*[\[\]\~\#\$\^\&\*\(\)\{\}\\\|\;\<\>\?\"\']*)]
      ac_arg=$ac_var=`echo "$ac_new_val" | sed "s/'/'\\\\\\\\''/g"` ;;
    *) ac_arg=$ac_var=$ac_new_val ;;
    esac
    case " $ac_configure_args " in
      *" '$ac_arg' "*) ;; # Avoid dups.  Use of quotes ensures accuracy.
      *) ac_configure_args="$ac_configure_args '$ac_arg'" ;;
    esac
  fi
done
if $ac_cache_corrupted; then
  AS_MESSAGE([error: changes in the environment can compromise the build], 2)
  AS_ERROR([run `make distclean' and/or `rm $cache_file' and start over])
fi
])# _AC_ARG_VAR_VALIDATE
])])