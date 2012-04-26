_setup() {
  tmp=tmp.$$
}

_go() {
  \geany \
    script.my \
    factor.api \
    factor.lib \
    factor.pkg \
    main.pkg \
  & local geanypid=$!
  # To switch to that tab.
  \sleep 2
  \geany script.my
  \wait $geanypid
}

_teardown() {
  \mkdir $tmp

  for i in \
    script.my \
    factor.api \
    factor.lib \
    factor.pkg \
    main.pkg \
    edit.sh \
  ; do
    \mv $i $tmp/
  done

  for i in * .*; do
    if [ -f $i ]; then
      \rm --force $i
    fi
  done
  \mv $tmp/* .
  \rmdir $tmp/
}


_setup
_go
_teardown
