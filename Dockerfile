# use Alpine Linux for build stage
FROM alpine:3.11.3 as build

# install build dependencies
RUN apk --no-cache add openjdk11

# build JDK with less modules
RUN /usr/lib/jvm/default-jvm/bin/jlink \
    --compress=2 \
    --module-path /usr/lib/jvm/default-jvm/jmods \
    --add-modules java.base,java.logging,java.sql,java.naming,java.management,java.instrument,java.desktop,java.security.jgss \
    --output /openjdk11-minimum

# prepare a fresh Alpine Linux with JDK
FROM alpine:3.11.3

# get result from build stage
COPY --from=build /openjdk11-minimum /opt/jdk/

# add java to path
ENV PATH=/opt/jdk/bin:$PATH
