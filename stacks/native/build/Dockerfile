ARG version=tip
FROM quay.io/boson/redhat-ubi8-build:ubi8-${version}

ARG stack_id
ENV CNB_STACK_ID=${stack_id}
LABEL io.buildpacks.stack.id=${stack_id}

USER root
RUN dnf install -y --nodocs golang rust cargo \
    && dnf update -y \
    && dnf clean all -y

USER cnb
