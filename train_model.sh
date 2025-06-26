#!/bin/bash
set -u

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <model_name> <config_name>"
    exit 1
fi

MODEL_NAME="$1"
CONFIG_NAME="$2"
CFG="./projects/calgary_campinas/configs/${CONFIG_NAME}"
EXPERIMENTS_DIR="../Weights/${MODEL_NAME}/"
DATA_ROOT_LOCAL="../data/Train/"
DATA_ROOT_LOCAL_VAL="../data/Val/"
NUM_GPUS=1
NUM_WORKERS=32

BASE_COMMAND="direct train \
    $EXPERIMENTS_DIR \
    --training-root $DATA_ROOT_LOCAL \
    --validation-root $DATA_ROOT_LOCAL_VAL \
    --cfg $CFG \
    --num-gpus $NUM_GPUS \
    --num-workers $NUM_WORKERS"

NUM_RUNS=1

# Generate slug
chars=abcdefghijklmnopqrstuvwxyz0123456789
slug=""
for i in {1..3}; do
    rand_index=$((RANDOM % ${#chars}))
    slug="${slug}${chars:$rand_index:1}"
done

for ((run_num=1; run_num<=NUM_RUNS; run_num++)); do
    timestamp=$(date +%m%d%H%M)
    RUN_NAME="${MODEL_NAME}_${slug}_${timestamp}"
    SEED=$((RANDOM % 1000000))
    COMMAND="${BASE_COMMAND} --name ${RUN_NAME} --seed ${SEED}"

    echo "Executing: $COMMAND"
    eval $COMMAND

    python3 pushover.py --message "Training complete for $RUN_NAME"
    echo "Training completed."
done
