FROM python:3.11-slim-bullseye

# Set ARG variables for versioning
ARG JAVA_VERSION=openjdk-11-jdk-headless
ARG ALLURE_VERSION=2.20.1

# Set environment variables
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:/opt/allure/bin:$PATH

# Install essential dependencies, build tools, and Java
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        wget \
        build-essential \
        python3-dev \
        zlib1g-dev \
        android-tools-adb \
        libgmp-dev \
        libssl-dev \
        libffi-dev \
        ${JAVA_VERSION} && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Allure CLI
RUN wget --no-check-certificate https://repo.maven.apache.org/maven2/io/qameta/allure/allure-commandline/${ALLURE_VERSION}/allure-commandline-${ALLURE_VERSION}.tgz && \
    tar xzf allure-commandline-${ALLURE_VERSION}.tgz && \
    mv allure-${ALLURE_VERSION} /opt/allure && \
    ln -s /opt/allure/bin/allure /usr/local/bin/allure && \
    rm allure-commandline-${ALLURE_VERSION}.tgz

# Copy Python requirements and install
COPY requirements.txt /tmp/requirements.txt
RUN pip3 install --no-cache-dir --upgrade pip wheel setuptools build && \
    pip3 install --no-cache-dir -r /tmp/requirements.txt && \
    rm /tmp/requirements.txt

# Create non-root user and prepare home directory
RUN useradd -m -d /home/tmpuser -s /bin/bash tmpuser

# Switch to non-root user
USER tmpuser

# Set the working directory (default for the container)
WORKDIR /home/tmpuser
