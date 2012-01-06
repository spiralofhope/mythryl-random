variable=$(cat <<'SETVAR'
api List_Lib {
    list_length:  List(String) -> Int;
};
SETVAR)
\echo $variable > list-lib.api

# --

variable=$(cat <<'SETVAR'
package list_lib: List_Lib {

    # Private helper function for computing
    # list length.  Its second argument
    # counts the number of list elements
    # seen so far.  This is a common MythryL idiom:
    #
    fun length_helper (rest_of_list, nodes_seen)
        =
        if (rest_of_list == [])    nodes_seen;                                              # Done, return count. 
        else                       length_helper( tail(rest_of_list), nodes_seen + 1 );     # Count rest of list recursively.
        fi;

    fun list_length a_list
        =
        length_helper (a_list, 0);
};
SETVAR)
\echo $variable > list-lib.pkg

# --

variable=$(cat <<'SETVAR'
LIBRARY_EXPORTS

        api List_Lib
        pkg list_lib
        pkg main

LIBRARY_COMPONENTS

        $ROOT/src/lib/std/standard.lib

        list-lib.api
        list-lib.pkg

        main.pkg
SETVAR)
\echo $variable > list-lib.lib

#\echo "A heredoc doesn't work"
#\my<<HEREDOC
#make "list-lib.lib";
#list_lib::list_length( ["abc", "def", "ghi"] );
#HEREDOC
:<<OUTPUT
stdin:2.1-2.22 Error: unbound pkg: list_lib in path list_lib::list_length
OUTPUT

## --

#\echo "Heredocs one at a time doesn't work"
#\my<<'HEREDOC'
#make "list-lib.lib";
#HEREDOC

#\my<<'HEREDOC'
#list_lib::list_length( ["abc", "def", "ghi"] );
#HEREDOC
:<<OUTPUT
                           makelib-g.pkg:   Making   library        list-lib.lib
                    libfile-parser-g.pkg:   Reading  library file   list-lib.lib                                        on behalf of <toplevel>
                      thawedlib-tome.pkg:   Parsing   source file   list-lib.api
                      thawedlib-tome.pkg:   Parsing   source file   list-lib.pkg
       compile-in-dependency-order-g.pkg:   Compiling source file   list-lib.api                                      
       compile-in-dependency-order-g.pkg:   Loading                 list-lib.api.compiled
       compile-in-dependency-order-g.pkg:   Compiling source file   list-lib.pkg                                      
       compile-in-dependency-order-g.pkg:   Loading                 list-lib.pkg.compiled
                           makelib-g.pkg:   New names added.

stdin:1.1-1.22 Error: unbound pkg: list_lib in path list_lib::list_length
OUTPUT


# --

#\echo "I know I can do one single command"
#\mythryld -x 'print "hello world\n";'

#\echo "But I cannot get this to work"
#\my -x '
  #make "list-lib.lib";
  #list_lib::list_length( ["abc", "def", "ghi"] );
#'
:<<OUTPUT
<Input_Stream>:3.3-3.24 Error: unbound pkg: list_lib in path list_lib::list_length
/usr/bin/my: Fatal error:  Uncaught exception COMPILE_ERROR with 0
 raised at src/lib/compiler/toplevel/interact/read-eval-print-loop-g.pkg:204.26-204.44
OUTPUT

\echo "Using mythryld"
my_path=/mnt/ssd/projects/mythryl/archive/source/6.0/mythryl7.110.58
mythryld  $my_path/src/lib/core/mythryl-compiler-compiler/mythryl-compiler-compiler-for-intel32-posix.lib  << EOF
  make "list-lib.lib";
  list_lib::list_length( ["abc", "def", "ghi"] );
EOF
:<<OUTPUT
Using mythryld
                           makelib-g.pkg:   Making   library        /mnt/ssd/projects/mythryl/archive/source/6.0/mythryl7.110.58/src/lib/core/mythryl-compiler-compiler/mythryl-compiler-compiler-for-intel32-posix.lib
                           makelib-g.pkg:   New names added.
stdin:2.3-2.24 Error: unbound pkg: list_lib in path list_lib::list_length
OUTPUT

#\echo "or this"
#\my -x 'make "list-lib.lib"; list_lib::list_length( ["abc", "def", "ghi"] );'
:<<OUTPUT
<Input_Stream>:1.22-1.43 Error: unbound pkg: list_lib in path list_lib::list_length
/usr/bin/my: Fatal error:  Uncaught exception COMPILE_ERROR with 0
 raised at src/lib/compiler/toplevel/interact/read-eval-print-loop-g.pkg:204.26-204.44
OUTPUT

#\echo "or even this"
#\my -x 'make "list-lib.lib"' -x 'list_lib::list_length( ["abc", "def", "ghi"] );'
# (only the first command is run)
:<<OUTPUT
/mnt/ssd/projects/mythryl/multi-file-test > \my -x 'make "list-lib.lib"' -x 'list_lib::list_length( ["abc", "def", "ghi"] );'
                           makelib-g.pkg:   Making   library        list-lib.lib
                    libfile-parser-g.pkg:   Reading  library file   list-lib.lib                                        on behalf of <toplevel>
       compile-in-dependency-order-g.pkg:   Loading                 list-lib.api.compiled
       compile-in-dependency-order-g.pkg:   Loading                 list-lib.pkg.compiled
                           makelib-g.pkg:   New names added.
TRUE
OUTPUT


## --

# Cleaning up, so that future runs are "pure"
# I don't think I need to / should do this..
#\rm --force \
  #list-lib.*.compiled \
  #list-lib.*.log \
  #main.log~

#\echo '------------------'
#\echo 'here'

#                                      lib          <the .pkg filename> :: <the package api>
#build-an-executable-mythryl-heap-image list-lib.lib main::main
#build-an-executable-mythryl-heap-image list-lib.lib list_lib::list_lib
