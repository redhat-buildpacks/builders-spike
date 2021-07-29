ARG version=tip
FROM quay.io/boson/faas-stack-build:ubi8-${version}

ARG stack_id
ENV CNB_STACK_ID=${stack_id}
LABEL io.buildpacks.stack.id=${stack_id}

USER root
COPY ./nodejs.module /etc/dnf/modules.d
COPY ./python.module /etc/dnf/modules.d
RUN dnf install --nodocs -y nodejs python38 tar git
USER cnb

