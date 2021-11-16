#!/bin/bash

set -e

DOCCLASS_PREFIX='\\documentclass[a4paper,en,print'
DOCCLASS_SUFFIX=']{adcv-template/adcv}'

OUTNAME_PREFIX='gara'
OUTNAME_SUFFIX='.pdf'

ONLINE_NAMES=(
  ''
  '-online'
)
ONLINE_OPTS=(
  ''
  ',online'
)

COLOR_NAMES=(
  ''
  '-color'
  '-bw'
)
COLOR_OPTS=(
  ',colorbar,colorlinks'
  ',colorlinks'
  ''
)

CONTENT_NAMES=(
  '-resume'
  '-resume-pubs'
  '-cv'
)

CONTENT_OPTS=(
  ''
  ',forcepublist'
  ',extended'
)

for o in $(seq "${#ONLINE_NAMES[@]}"); do
  online_name="${ONLINE_NAMES[$((o - 1))]}"
  online_opt="${ONLINE_OPTS[$((o - 1))]}"
  for c in $(seq "${#COLOR_NAMES[@]}"); do
    color_name="${COLOR_NAMES[$((c - 1))]}"
    color_opt="${COLOR_OPTS[$((c - 1))]}"
    for k in $(seq "${#CONTENT_NAMES[@]}"); do
      content_name="${CONTENT_NAMES[$((k - 1))]}"
      content_opt="${CONTENT_OPTS[$((k - 1))]}"

      outname="${OUTNAME_PREFIX}${online_name}${color_name}${content_name}${OUTNAME_SUFFIX}"
      documentclass="${DOCCLASS_PREFIX}${online_opt}${color_opt}${content_opt}${DOCCLASS_SUFFIX}"

      echo "=> Building $outname"
      sed -i "s#^\\\\documentclass.*#${documentclass}#" main.tex
      make # &>/dev/null
      make # &>/dev/null
      mkdir -p cvs
      cp main.pdf "cvs/$outname"
    done
  done
done
documentclass="${DOCCLASS_PREFIX}${DOCCLASS_SUFFIX}"
sed -i "s#^\\\\documentclass.*#${documentclass}#" main.tex
