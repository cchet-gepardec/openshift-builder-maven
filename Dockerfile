FROM centos:8

ENV BUILDER_CONTEXT_DIR="" \
    BUILDER_MVN_MIRROR="" \
    BUILDER_MVN_MIRROR_ALLOW_FALLBACK=false \
    BUILDER_MVN_OPTIONS=""
    
ARG S2IDIR="/home/s2i"
ARG APPDIR="/deployments"
ARG JAVA_VERSION="java-11-openjdk"
ARG MAVEN_VERSION="3.5.4"

LABEL io.k8s.description="S2I Maven Builder (Java: ${JAVA_VERSION}, Maven: ${MAVEN_VERSION})" \
      io.k8s.display-name="S2I Maven Builder" \
      io.openshift.tags="builder,java,maven" \
      io.openshift.s2i.scripts-url="image://${S2IDIR}/bin" \
      maintainer="Clemens Kaserer <clemens.kaserer@gepardec.com>"

RUN mkdir -p ${APPDIR}/target && \
    yum install -y \
        ${JAVA_VERSION} \
        maven-${MAVEN_VERSION} && \
    yum clean all && \
    chgrp -R 0 ${APPDIR} /etc/maven && \ 
    chmod -R g+rwX ${APPDIR} /etc/maven

COPY s2i ${S2IDIR}
RUN chgrp -R 0 ${S2IDIR} && \
    chmod -R g+rwX ${S2IDIR}

USER 1001

WORKDIR ${APPDIR}

CMD ["${S2IDIR}/bin/run"]
