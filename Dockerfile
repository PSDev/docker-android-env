FROM openjdk:8-jdk

ARG ANDROID_COMPILE_SDK=28
ARG ANDROID_BUILD_TOOLS="28.0.3"
ARG ANDROID_SDK_TOOLS="4333796"

ENV ANDROID_HOME "/sdk"
ENV PATH "$PATH:${ANDROID_HOME}/tools"
ENV DEBIAN_FRONTEND noninteractive


RUN apt-get update -qq && \
    apt-get install -qqy --no-install-recommends curl tar unzip lib32stdc++6 lib32z1 locales && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN locale-gen en_US.UTF-8
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

RUN rm -f /etc/ssl/certs/java/cacerts; \
    /var/lib/dpkg/info/ca-certificates-java.postinst configure

RUN curl -s https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_TOOLS}.zip > /sdk.zip && \
    unzip /sdk.zip -d /sdk && \
    rm -v /sdk.zip

RUN echo y | ${ANDROID_HOME}/tools/bin/sdkmanager "tools" >/dev/null && \
    echo y | ${ANDROID_HOME}/tools/bin/sdkmanager "platform-tools" >/dev/null && \
    echo y | ${ANDROID_HOME}/tools/bin/sdkmanager "platforms;android-${ANDROID_COMPILE_SDK}" >/dev/null && \
    echo y | ${ANDROID_HOME}/tools/bin/sdkmanager "build-tools;${ANDROID_BUILD_TOOLS}" >/dev/null

RUN yes | ${ANDROID_HOME}/tools/bin/sdkmanager --licenses
