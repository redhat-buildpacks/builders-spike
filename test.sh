#!/usr/bin/env sh

EXPECTED="Hello from the Noop buildpack"

for builder  in interpreted native jvm ; do
  echo "----> Testing ${builder}"
  pack build test/${builder} --builder quay.io/boson/redhat-${builder}-builder:tip -v --trust-builder --pull-policy never
  GOT=$(docker run --rm test/${builder})
  if [[ $GOT != $EXPECTED ]] ; then
    echo "----> Expected ${EXPECTED}\nGot ${GOT}"
    exit 100
  fi
  docker rmi test/${builder}
done

echo "----> Success"
