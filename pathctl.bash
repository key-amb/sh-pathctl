#!bash

PATHCTL_VERBOSE=""
PATHCTL_VERSION="0.9.1"

# Vars for check and test
__pathctl_changed=""
__pathctl_contains=""

_pathctl_verbose() {
  if [[ $PATHCTL_VERBOSE ]]; then
    echo "$@"
  fi
}

_pathctl_check_contain() {
  local target=$1
  __pathctl_contains=""
  case ":${PATH}:" in
    *:"${target}":*)
      __pathctl_contains="true"
      ;;
    *)
      ;;
  esac
  if [[ $__pathctl_contains ]]; then
    _pathctl_verbose "\$PATH contains '$target'"
  else
    _pathctl_verbose "\$PATH doesn't contain '$target'"
  fi
}

pathctl_show() {
  local ifs=$IFS
  IFS=":"
  printf "%s\n" $PATH
  IFS=$ifs
}

pathctl_unshift() {
  local _path=$1
  __pathctl_changed=""
  _pathctl_check_contain $_path
  if [[ -z $__pathctl_contains ]]; then
    PATH=$_path:$PATH
    __pathctl_changed="true"
  fi
  if [[ $__pathctl_changed ]]; then
    _pathctl_verbose "unshift '$_path' to \$PATH"
  else
    _pathctl_verbose "Do nothing"
  fi
}

pathctl_push() {
  local _path=$1
  __pathctl_changed=""
  _pathctl_check_contain $_path
  if [[ -z $__pathctl_contains ]]; then
    PATH=$PATH:$_path
    __pathctl_changed="true"
  fi
  if [[ $__pathctl_changed ]]; then
    _pathctl_verbose "push '$_path' to \$PATH"
  else
    _pathctl_verbose "Do nothing"
  fi
}

pathctl_pop() {
  PATH=${PATH%:*}
}

pathctl_shift() {
  PATH=${PATH#*:}
}

: <<'__EOF__'

=encoding utf8

=head1 NAME

B<pathctl.bash> - Utility for PATH management

=head1 SYNOPSYS

    #!bash
    source pathctl.bash
    pathctl_show    # show each entry per line
    pathctl_push    /path/to/your-bin
    pathctl_unshift /path/to/your-bin
    pathctl_pop     # removes last entry
    pathctl_shift   # removes first entry

    # show verbose messages
    PATHCTL_VERBOSE=1

=head1 DESCRIPTION

Add functions to manage PATH variable.

=head1 AUTHORS

YASUTAKE Kiyoshi E<lt>yasutake.kiyoshi@gmail.comE<gt>

=head1 LICENSE

The MIT License (MIT)

Copyright (c) 2016 YASUTAKE Kiyoshi

=cut

__EOF__

