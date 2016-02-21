**WORK-IN-PROGRESS**

## Introduction

<!-- (2016-02-19 16:38 CET) -->

This document explains how to build from sources the [GENIVI Demo Platform](http://projects.genivi.org/genivi-demo-platform/home) using Jenkins. 

Rather then performing the build inside a Jenkins slave, the build is done inside a Docker container.

This procedure may be used as a regression test suite for the [gmacario/easy-jenkins](https://github.com/gmacario/easy-jenkins) project.

The instructions inside this document were tested on

* Docker client: itm-gmacario-w7 (MS Windows 7 64-bit, Docker Toolbox 1.10.0)
* Docker engine: Oracle VirtualBox VM created by Docker Toolbox

## Preparation

Refer to [preparation.md](https://github.com/gmacario/easy-jenkins/blob/master/docs/preparation.md) for details.

## Step-by-step instructions

### Create project `build_gdp_ivi9_beta`

Browse `${DOCKER_URL}`, then click **New Item**

* Name: `build_gdp_ivi9_beta`
* Type: **Freestyle project**

then click **OK**. Inside the project configuration page, add the following information:

* Discard Old Builds: Yes
  - Strategy: Log Rotation
    - Days to keep build: (none)
    - Max # of builds to keep: 5
* Source Code Management: Git
  - Repositories
    - Repository URL: `git://git.projects.genivi.org/genivi-demo-platform.git`
    - Credentials: - none -
  - Branches to build
    - Branch Specifier (blank for 'any'): `*/qemux86-64-ivi9-beta`
  - Repository browser: (Auto)
* Build Environment
  - Build inside a Docker container: Yes
    - Docker image to use: Pull docker image from repository
      - Image id/tag: `ubuntu:14.04`
* Build
  - Execute shell
    - Command
```
# DEBUG
id
pwd
ls -la
printenv
```
  - Execute shell
    - Command
```
# Build Environment Preparation
# TODO: Move to Dockerfile

apt-get update && apt-get -y upgrade

# Install the following utilities (required by poky)
apt-get install -y build-essential chrpath curl diffstat gcc-multilib gawk git-core libsdl1.2-dev texinfo unzip wget xterm

# Additional host packages required by poky/scripts/wic
apt-get install -y parted dosfstools mtools syslinux

# Add "repo" tool (used by many Yocto-based projects)
curl http://storage.googleapis.com/git-repo-downloads/repo > /usr/local/bin/repo
chmod a+x /usr/local/bin/repo
```
  - Execute shell
    - Command
```
#!/bin/bash -xe

# Actual build steps

source init.sh

# Prevent error "Do not use Bitbake as root"
touch conf/sanity.conf

bitbake genivi-demo-platform
```

then click **Save**.

### Build project `build_gdp_ivi9_beta`

<!-- (2016-02-19 18:50 CET) -->

Browse `${JENKINS_URL}/job/build_gdp_ivi9_beta/`, then click **Build Now**

You may watch the build logs at `${JENKINS_URL}/job/build_gdp_ivi9_beta/lastBuild/console`

<!-- (2016-02-19 18:50 CET) -->

```
Started by user anonymous
[EnvInject] - Loading node environment variables.
Building on master in workspace /var/jenkins_home/jobs/GENIVI/jobs/build_gdp_ivi9_beta/workspace
 > git rev-parse --is-inside-work-tree # timeout=10
Fetching changes from the remote Git repository
 > git config remote.origin.url git://git.projects.genivi.org/genivi-demo-platform.git # timeout=10
Fetching upstream changes from git://git.projects.genivi.org/genivi-demo-platform.git
 > git --version # timeout=10
 > git -c core.askpass=true fetch --tags --progress git://git.projects.genivi.org/genivi-demo-platform.git +refs/heads/*:refs/remotes/origin/*
 > git rev-parse refs/remotes/origin/qemux86-64-ivi9-beta^{commit} # timeout=10
 > git rev-parse refs/remotes/origin/origin/qemux86-64-ivi9-beta^{commit} # timeout=10
Checking out Revision 6e50965700f98572eaa731e426d561b1b5031c87 (refs/remotes/origin/qemux86-64-ivi9-beta)
 > git config core.sparsecheckout # timeout=10
 > git checkout -f 6e50965700f98572eaa731e426d561b1b5031c87
 > git rev-list 6e50965700f98572eaa731e426d561b1b5031c87 # timeout=10
Docker container 873f985689c598580809352f064401354c9a6a13939103315e5b0ef6cf758361 started to host the build
$ docker exec --tty 873f985689c598580809352f064401354c9a6a13939103315e5b0ef6cf758361 env
[workspace] $ docker exec --tty --user 0:0 873f985689c598580809352f064401354c9a6a13939103315e5b0ef6cf758361 env affinity:container==e1d192d7db587826ac8fe8aa16904668acfa610aca385d3941c67924ea61154a 'BASH_FUNC_copy_reference_file%%=() {  f="${1%/}";
 b="${f%.override}";
 echo "$f" >> "$COPY_REFERENCE_FILE_LOG";
 rel="${b:23}";
 dir=$(dirname "${b}");
 echo " $f -> $rel" >> "$COPY_REFERENCE_FILE_LOG";
 if [[ ! -e /var/jenkins_home/${rel} || $f = *.override ]]; then
 echo "copy $rel to JENKINS_HOME" >> "$COPY_REFERENCE_FILE_LOG";
 mkdir -p "/var/jenkins_home/${dir:23}";
 cp -r "${f}" "/var/jenkins_home/${rel}";
 [[ ${rel} == plugins/*.jpi ]] && touch "/var/jenkins_home/${rel}.pinned";
 fi
}' BUILD_CAUSE=MANUALTRIGGER BUILD_CAUSE_MANUALTRIGGER=true BUILD_DISPLAY_NAME=#3 BUILD_ID=3 BUILD_NUMBER=3 BUILD_TAG=jenkins-GENIVI-build_gdp_ivi9_beta-3 CA_CERTIFICATES_JAVA_VERSION=20140324 CLASSPATH= COPY_REFERENCE_FILE_LOG=/var/jenkins_home/copy_reference_file.log EXECUTOR_NUMBER=0 GIT_BRANCH=origin/qemux86-64-ivi9-beta GIT_COMMIT=6e50965700f98572eaa731e426d561b1b5031c87 GIT_PREVIOUS_COMMIT=6e50965700f98572eaa731e426d561b1b5031c87 GIT_URL=git://git.projects.genivi.org/genivi-demo-platform.git HOME=/root HOSTNAME=23165c7ab151 HUDSON_HOME=/var/jenkins_home HUDSON_SERVER_COOKIE=53d719acc1b28b93 JAVA_DEBIAN_VERSION=8u66-b17-1~bpo8+1 JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 JAVA_VERSION=8u66 JENKINS_HOME=/var/jenkins_home JENKINS_SERVER_COOKIE=53d719acc1b28b93 JENKINS_SHA=6a0213256670a00610a3e09203850a0fcf1a688e JENKINS_SLAVE_AGENT_PORT=50000 JENKINS_UC=https://updates.jenkins-ci.org JENKINS_VERSION=1.642.1 JOB_NAME=GENIVI/build_gdp_ivi9_beta LANG=C.UTF-8 NODE_LABELS=master NODE_NAME=master PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin PWD=/ ROOT_BUILD_CAUSE=MANUALTRIGGER ROOT_BUILD_CAUSE_MANUALTRIGGER=true SHLVL=2 TERM=xterm TINI_SHA=066ad710107dc7ee05d3aa6e4974f01dc98f3888 WORKSPACE=/var/jenkins_home/jobs/GENIVI/jobs/build_gdp_ivi9_beta/workspace /bin/sh -xe /tmp/hudson8560520634677004851.sh
...
TODO
```

**NOTE**: A full build takes about 5 hours to complete on a dual-Xeon(R) CPU X5450 @3.00 GHz and 16 GB RAM.

Browse `${JENKINS_URL}/job/build_gdp_ivi9_beta/ws/gdp-src-build/tmp/deploy/images/qemux86-64/` to inspect the build results.

TODO: Attach screenshot

<!-- EOF -->