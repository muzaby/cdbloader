#!/bin/bash

# move this script to the root of your project and then run

TARGETS=(
    # add target directories
    "./src/"
    "./include/"
)

function remove_db
{
    rm tags
    rm cscope_files
    rm cscope.out
}

function make_cscope
{
    for i in ${!TARGETS[*]}; do
        find ${TARGETS[$i]} -name "*.[ch]" -o -name "*.[ch]pp" -o -name "*.java" >> cscope_files
    done
    cscope -i cscope_files
}

function make_ctags
{
    for i in ${!TARGETS[*]}; do
        targets=${targets}' '${TARGETS[$i]}
    done
    ctags -R ${targets}
}

remove_db
make_ctags
make_cscope
