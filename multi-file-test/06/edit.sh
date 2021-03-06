_setup() {
  tmp=tmp.$$
}

_go() {
  \geany --new-instance \
    script.my \
    factor.lib \
    factor.api \
    factor.pkg \
    main.pkg \
    script.my \
  & local geanypid=$!
  lxterminal --command=" \
    /l/Linux/bin/sh/live/autotest.sh \"script.my\" --nodebug" &
  \wait $geanypid
}

_teardown() {
  \mkdir $tmp

  for i in \
    script.my \
    factor.lib \
    factor.api \
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
