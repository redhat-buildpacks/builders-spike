#!/usr/bin/env bash
set -e

ID_PREFIX="dev.boson.stacks"

REPOSITORY=quay.io/boson
DEFAULT_PREFIX=redhat-ubi8

REPO_PREFIX=${REPOSITORY}/${DEFAULT_PREFIX}

VERSION=tip

usage() {
  echo "Usage: "
  echo "  $0 [-p <prefix>] [-v <version>] <dir>"
  echo "    -p    prefix to use for images      (default: ${DEFAULT_PREFIX})"
  echo "   <dir>  directory of stack to build"
  exit 1;
}


while getopts "v:p:" o; do
  case "${o}" in
    p)
      REPO_PREFIX=${REPOSITORY}/${OPTARG}
      ;;
    v)
      VERSION=${OPTARG}
      ;;
    \?)
      echo "Invalid option: -$OPTARG" 1>&2
      usage
      ;;
    :)
      usage
      ;;
  esac
done

STACK_DIR=${@:$OPTIND:1}

if [[ -z ${REPO_PREFIX} ]]; then
  echo "Prefix cannot be empty"
  echo
  usage
  exit 1
fi

if [[ -z ${STACK_DIR} ]]; then
  echo "Must specify stack directory"
  echo
  usage
  exit 1
fi

DIR=$(cd $(dirname $0) && pwd)
IMAGE_DIR=$(realpath "${STACK_DIR}")
TAG=$(basename "${IMAGE_DIR}")-${VERSION}
STACK_ID="${ID_PREFIX}.$(basename "${IMAGE_DIR}")"
RUN_IMAGE=${REPO_PREFIX}-run:${TAG}
BUILD_IMAGE=${REPO_PREFIX}-build:${TAG}

echo "BUILDING ${BUILD_IMAGE}..."
docker build --build-arg "stack_id=${STACK_ID}" --build-arg "version=${VERSION}" -t "${BUILD_IMAGE}"  "${IMAGE_DIR}/build"

echo "BUILDING ${RUN_IMAGE}..."
docker build --build-arg "stack_id=${STACK_ID}" --build-arg "version=${VERSION}" -t "${RUN_IMAGE}" "${IMAGE_DIR}/run"

echo
echo "STACK BUILT!"
echo
echo "Stack ID: ${STACK_ID}"
echo "Images:"
echo "    ${BUILD_IMAGE}"
echo "    ${RUN_IMAGE}"
