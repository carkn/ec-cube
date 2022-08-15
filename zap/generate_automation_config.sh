#!/bin/bash

cd $(dirname $0)

while getopts "t:c:b:n:" OPT
do
    case $OPT in
        t) TARGET=${OPTARG} ;;
        c) CONTEXT=${OPTARG} ;;
        b) BEFORE_SCRIPT=${OPTARG} ;;
        n) THREAD_PER_HOST=${OPTARG} ;;
    esac
done

THREAD_PER_HOST=${THREAD_PER_HOST:-10}

if [[ -z "${CONTEXT}" ]]; then
    if [[ ${TARGET} =~ 'admin' ]]; then
        CONTEXT=admin
        CONTEXT_USER=admin
    else
        CONTEXT=default
    fi
fi

BEFORE_SCRIPT=$(echo ${BEFORE_SCRIPT} | sed 's/ //g')

echo "
CONTEXT: ${CONTEXT}
CONTEXT_USER: ${CONTEXT_USER}
THREAD_PER_HOST: ${THREAD_PER_HOST}
TARGET: ${TARGET}
BEFORE_SCRIPT: ${BEFORE_SCRIPT}
"


if [[ -n ${BEFORE_SCRIPT} ]]; then
    REPLACE_COMMENT="s/#//g"
else
    REPLACE_COMMENT="s/^#.*$//g"
fi

cat automation/template.yml | \
    sed "s/__TARGET__/${TARGET}/g" | \
    sed "s/__BEFORE_SCRIPT__/${BEFORE_SCRIPT}/g" | \
    sed "s/__THREAD_PER_HOST__/${THREAD_PER_HOST}/g" | \
    sed "s/__CONTEXT__/${CONTEXT}/g" | \
    sed "s/__USER__/${CONTEXT_USER}/" | \
    sed ${REPLACE_COMMENT} \
    > automation/${TARGET}.yml