#!/bin/zsh

# http://mythryl.org/my-Multi-file_Projects__Libraries_and_API_Definitions.html
# http://mythryl.org/my-Multi-file_Projects__Compiling_a_Stand-Alone_Executable.html
#./mythryl_build.sh factor.lib main::main

# Avoid "zsh: no matches found"
setopt NONOMATCH

if [ -z $1 ] || [ -z $2 ] || ! [ -z $3 ]; then
  \echo 'Syntax error.'
  \echo 'You want something like:'
  \echo "$0 factor.lib main::main"
  exit 1
fi

if ! [ -f $1 ]; then
  \echo "$1 does not exist"
  exit 1
fi

# Filename only, no extension.
f=${1:r}

# Once I know what to do with the various files after a failure, I could make this && so it doesn't do the cleanup if there's a failure.
# TODO:  Regular expressions, to "simplify" this?
\build-an-executable-mythryl-heap-image $@ \
  ; \
  \rm -f \
    ${f}.api.compiled \
    ${f}.pkg.compiled \
    main.pkg.compiled \
    ${f}.api.compile.log \
    ${f}.lib.compile.log \
    ${f}.pkg.compile.log \
    main.pkg.compile.log \
    .${f}.api.version \
    .${f}.pkg.version \
    .main.pkg.version \
    .${f}.api.module-dependencies-summary \
    .${f}.pkg.module-dependencies-summary \
    .main.pkg.module-dependencies-summary \
    ${f}.lib.index \
    mythryl.compile.log \
    unknown.log \
    main.log~ \
    ` # Some sort of pid is being used here, but it's not the pid of this script when it runs, it's +1.. but I don't know if it's always +1 so I can reliably work with that. ` \
    tmp-makelib-pid-*-export.lib \
    tmp-makelib-pid-*-export.lib.index \
    tmp-makelib-pid-*-export.lib.compile.log \
    tmp-makelib-pid-*-export.pkg \
    .tmp-makelib-pid-*-export.pkg.version \
    .tmp-makelib-pid-*-export.pkg.module-dependencies-summary \
    tmp-makelib-pid-*-export.pkg.compile.log \
    ` # On success, these are also built ` \
    load-compiledfiles.c.log \
    ` # These are pid-related ` \
    tmp-makelib-pid-*.COMPILED_FILES_TO_LOAD \
    tmp-makelib-pid-*-export.pkg.compiled \
    tmp-makelib-pid-*.LINKARGS \
  ` # `

#\ls --color -al
#exit 0
