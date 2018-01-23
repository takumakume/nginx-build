function test_openssl_version() {
  actual="$(nginx -V |& grep OpenSSL | grep -o ${OPENSSL_VERSION})"
  expected="${OPENSSL_VERSION}"

  if [ "x$actual" == "x$expected" ]; then
    pass "${FUNCNAME[0]}"
  else
    fail "${FUNCNAME[0]}" "$expected" "$actual"
  fi
}

function test_header_module() {
  actual="$(nginx -V |& grep -o '/usr/local/src/headers-more-nginx-module')"
  expected="/usr/local/src/headers-more-nginx-module"

  if [ "x$actual" == "x$expected" ]; then
    pass "${FUNCNAME[0]}"
  else
    fail "${FUNCNAME[0]}" "$expected" "$actual"
  fi
}
