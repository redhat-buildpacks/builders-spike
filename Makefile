PACK_CMD?=pack

GIT_TAG := $(shell git tag --points-at HEAD)
VERSION_TAG := $(shell [ -z $(GIT_TAG) ] && echo 'tip' || echo $(GIT_TAG) )

BUILD_REPO := quay.io/boson/redhat-stack-build
RUN_REPO   := quay.io/boson/redhat-stack-run

NOOP_BUILDPACK_REPO      := quay.io/boson/redhat-noop-buildpack
NATIVE_BUILDER_REPO      := quay.io/boson/redhat-native-builder
INTERPRETED_BUILDER_REPO := quay.io/boson/redhat-interpreted-builder
JVM_BUILDER_REPO         := quay.io/boson/redhat-jvm-builder

.PHONY: stacks buildpack builders test

all: stacks buildpack builders test

stacks:
	./stacks/build-stack.sh -v $(VERSION_TAG) stacks/ubi8
	./stacks/build-stack.sh -v $(VERSION_TAG) stacks/native
	./stacks/build-stack.sh -v $(VERSION_TAG) stacks/interpreted
	./stacks/build-stack.sh -v $(VERSION_TAG) stacks/jvm

buildpack:
	$(PACK_CMD) buildpack package $(NOOP_BUILDPACK_REPO):$(VERSION_TAG) --config ./buildpacks/package.toml

builders:
	TMP_BLDRS=$(shell mktemp -d) && \
	sed "s/{{VERSION}}/$(VERSION_TAG)/g" ./builders/interpreted/builder.toml > $$TMP_BLDRS/interpreted.toml && \
	sed "s/{{VERSION}}/$(VERSION_TAG)/g" ./builders/native/builder.toml > $$TMP_BLDRS/native.toml && \
	sed "s/{{VERSION}}/$(VERSION_TAG)/g" ./builders/jvm/builder.toml > $$TMP_BLDRS/jvm.toml && \
	$(PACK_CMD) builder create $(NATIVE_BUILDER_REPO):$(VERSION_TAG) --config $$TMP_BLDRS/native.toml && \
	$(PACK_CMD) builder create $(INTERPRETED_BUILDER_REPO):$(VERSION_TAG) --config $$TMP_BLDRS/interpreted.toml && \
	$(PACK_CMD) builder create $(JVM_BUILDER_REPO):$(VERSION_TAG) --config $$TMP_BLDRS/jvm.toml && \
	rm -fr $$TMP_BLDRS

test:
	./test.sh
