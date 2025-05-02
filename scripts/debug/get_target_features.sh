#!/usr/bin/env bash

SCRIPT_DIR=$(realpath $(dirname $0)/..)
source ${SCRIPT_DIR}/ci/common.sh

while getopts "t:c:a:f:" arg; do
  case ${arg} in
    t)
      TRIPLE=${OPTARG}
      ;;
    c)
      CPU=${OPTARG}
      ;;
    a)
      ARCH=${OPTARG}
      ;;
    f)
      FPU=${OPTARG}
      ;;
    *)
      echo "Invalid option: ${OPTARG}"
      exit 1
  esac
done
TMP="$(mktemp).c"
ARGS="-c ${TMP} -###"
if [ ! -z ${TRIPLE} ]; then
  ARGS="${ARGS} -target ${TRIPLE}"
fi
if [ ! -z ${ARCH} ]; then
  ARGS="${ARGS} -march ${ARCH}"
fi
if [ ! -z ${CPU} ]; then
  ARGS="${ARGS} -cpu ${CPU}"
fi
if [ ! -z ${FPU} ]; then
  ARGS="${ARGS} -mfpu ${FPU}"
fi

## Get flags
clang ${ARGS} > ${TMP} 2>&1
if [ $? -ne 0 ]; then
  echo "Error running clang"
  cat ${TMP}
  rm -f ${TMP}
  exit 1
fi
#cat ${TMP}

## Get target triple
TARGET_TRIPLE=$(grep -Po '"-triple" ".+?"' ${TMP})
echo "Target triple: '${TRIPLE}' --> ${TARGET_TRIPLE}"

## Get target CPU
TARGET_CPU=$(grep -Po '"-target-cpu" ".+?"' ${TMP})
echo "Target CPU: '${CPU}' --> ${TARGET_CPU}"