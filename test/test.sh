#!/bin/bash

CLR_PASS="\\033[0;32m"
CLR_FAIL="\\033[0;31m"
CLR_WARN="\\033[0;33m"
CLR_INFO="\\033[0;34m"
CLR_RESET="\\033[0;39m"
ALL_PASSED=0

function pass() {
  echo -e "[${CLR_PASS}PASS${CLR_RESET}] octopass::$(echo $1 | sed -e "s/test_//")"
}

function fail() {
  ALL_PASSED=1
  echo -e "[${CLR_FAIL}FAIL${CLR_RESET}] octopass::$(echo $1 | sed -e "s/test_//")"
  echo -e "${CLR_INFO}Expected${CLR_RESET}:"
  echo -e "$2"
  echo -e "${CLR_WARN}Actual${CLR_RESET}:"
  echo -e "$3"
}

function test_install_path() {
  actual="$(test -e /sbin/nginx; echo $?)"
  expected="0"

  if [ "x$actual" == "x$expected" ]; then
    pass "${FUNCNAME[0]}"
  else
    fail "${FUNCNAME[0]}" "$expected" "$actual"
  fi
}

function test_version() {
  actual="$(nginx -v |& grep -o ${NGINX_VERSION})"
  expected="${NGINX_VERSION}"

  if [ "x$actual" == "x$expected" ]; then
    pass "${FUNCNAME[0]}"
  else
    fail "${FUNCNAME[0]}" "$expected" "$actual"
  fi
}

# extend script
[[ -f "roles/${ROLE_NAME}/test.sh" ]] && source roles/${ROLE_NAME}/test.sh

function run_test() {
  self=$(cd $(dirname $0) && pwd)/$(basename $0)
  tests="$(grep "^function test_" $self | sed -E "s/function (.*)\(\) \{/\1/g")"
  for t in $(echo $tests); do
    $t
  done
}

nginx -V

run_test
exit $ALL_PASSED
