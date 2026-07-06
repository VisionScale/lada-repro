#!/bin/bash
# Run LADA on Office-31 using the published Docker image.
# Usage: ./run_office31.sh [host_data_dir] [gpu_id]

set -e

IMAGE="svtter/lada:cuda126"
HOST_DATA_DIR="${1:-$HOME/data}"
GPU_ID="${2:-0}"
CONTAINER_DATA_DIR="/workspace/LADA/data"

echo "Pulling image ${IMAGE} ..."
docker pull "${IMAGE}"

echo "Checking Office-31 data in ${HOST_DATA_DIR}/office31 ..."
if [[ ! -d "${HOST_DATA_DIR}/office31/amazon" || ! -d "${HOST_DATA_DIR}/office31/webcam" || ! -d "${HOST_DATA_DIR}/office31/dslr" ]]; then
    echo "Office-31 data not found. Please download it from:"
    echo "  https://faculty.cc.gatech.edu/~judy/domainadapt/"
    echo "and extract it so that the following directories exist:"
    echo "  ${HOST_DATA_DIR}/office31/amazon"
    echo "  ${HOST_DATA_DIR}/office31/webcam"
    echo "  ${HOST_DATA_DIR}/office31/dslr"
    exit 1
fi

mkdir -p "${HOST_DATA_DIR}/LADA_logs"

echo "Running LADA (LAS + LAA) on Office-31, GPU ${GPU_ID} ..."
docker run --rm \
    --gpus "device=${GPU_ID}" \
    --shm-size=8g \
    -v "${HOST_DATA_DIR}/office31:${CONTAINER_DATA_DIR}/office31" \
    -v "${HOST_DATA_DIR}/LADA_logs:/workspace/LADA/log" \
    "${IMAGE}" \
    python main.py --cfg configs/office31.yaml --gpu 0 --log log/office31/LADA ADA.AL LAS ADA.DA LAA

echo "Done. Logs saved to ${HOST_DATA_DIR}/LADA_logs"
