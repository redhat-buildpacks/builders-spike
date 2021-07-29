## Unofficial Red Hat Builders

This repository contains the necessary code to create CNCF builders on Red Hat
UBI-based images. Due to the fact that the Buildpack specification does not
currently support writing system files during the build or detect phases by a
buildpack, we provide here two distinct builder images. One that can support
Java based applications, and the other that supports Node.js and Python.

We are tracking the Buildpack upstream RFC for Dockerfile support, which would
likely rectify this situation for us by allowing builders to apply Dockerfiles
to base build and run images after `detect` but before the `build` phase.

See: https://github.com/buildpacks/rfcs/pull/173
