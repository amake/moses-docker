#!/bin/sh

set -e

if [ -z "${SOURCE_LANG}" ] || [ -z "${TARGET_LANG}" ]; then
    echo "The source and target languages must be set!"
    exit 1
fi

mkdir -p ${WORK_HOME}/tune
cd ${WORK_HOME}/tune
tmx2corpus ${TUNE_TMX_DIR}

# # Tokenize
# ${MOSES_HOME}/scripts/tokenizer/tokenizer.perl -l ${SOURCE_LANG} \
# 	< ${DATA_HOME}/tune/bitext.${SOURCE_LANG} \
# 	> ${DATA_HOME}/tune/bitext.tok.${SOURCE_LANG}
# ${MOSES_HOME}/scripts/tokenizer/tokenizer.perl -l ${TARGET_LANG} \
# 	< ${DATA_HOME}/tune/bitext.${TARGET_LANG} \
# 	> ${DATA_HOME}/tune/bitext.tok.${TARGET_LANG}

# Tune
${MOSES_HOME}/scripts/training/mert-moses.pl \
	${WORK_HOME}/tune/bitext.tok.${SOURCE_LANG} \
    ${WORK_HOME}/tune/bitext.tok.${TARGET_LANG} \
	${MOSES_HOME}/bin/moses ${WORK_HOME}/train/model/moses.ini \
    --mertdir ${MOSES_HOME}/bin/ \
	--decoder-flags="-threads $(nproc)" > mert.out

