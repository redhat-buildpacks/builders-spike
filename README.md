# Unofficial Red Hat Builders

This project is an experiment. It does not in any way reflect an actual Red Hat product.

This repository contains the necessary code to create CNCF builders on Red Hat
UBI-based images. Due to the fact that the Buildpack specification does not
currently support writing system files during the build or detect phases by a
buildpack, we provide here three distinct builder images. 

* `quay.io/boson/redhat-interpreted-builder` which supports Node.js 14 and Python 3.8 based buildpacks
* `quay.io/boson/redhat-jvm-builder` which supports OpenJDK 11 based buildpacks
* `quay.io/boson/redhat-native-builder` which supports Go and Rust based buildpacks

There is an upstream RFC for Dockerfile support, which would resolve this
situation for us by allowing builders to apply Dockerfiles
to base build and run images after the `detect` phase in the buildpack
lifecycle.

:rfc: See: https://github.com/buildpacks/rfcs/pull/173

A change like this is likely to take a while to complete upstream. In the meantime,
we need to move forward with some kind of approach for buildpacks that allows us
to minimize the proliferation of builder images and stacks that we must produce -
effectively one for each runtime (and this doesn't even take into consideration the
different versions). For now, this is a stake in the ground as one approach to be
a target of discussion.

## Drawbacks
* Large builder images, ranging from 400+MB to over 1GB
* Not as large, but still large run images from 120MB to 390MB (this isn't as large as I thought they would be actually)
* Customers still need to know to choose one of these three builders
* CI/CD needs to be parameterized to support builder images
* Only a single version of a given runtime is supported - which makes me wonder if it's possible to have multiple simultaneous versions of a given runtime installed, and be able to choose between them during the `build` phase - would this alter system files?

## Alternatives
* Stacks and builder images for multiple versions of each runtime currently supported (Node.js, Quarkus, Python, Rust, etc.) - this would be a LOT of images
* A single builder image that contains everything in these three images combined - this would be pretty LARGE
* Modification to Red Hat RPM packages, so that they can be installed in an arbitrary directory and do not update system files - this is likely to take a lot of TIME to complete
* Publish independently installable compressed archives of supported runtimes, for example, https://access.redhat.com/registry/runtimes/redhat-nodejs-14.tgz - this is also likely to take a lot of TIME to complete

## Building

Run `make` on the command line. This will create the stacks, builder images and a noop buildpack. A simple shell script uses the `pack` binary (prerequisite on your system!) to create an image with the noop buildpack, using each of the three builders, testing the output.
