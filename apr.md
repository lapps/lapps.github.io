---
title: Apache Portable Runtime
layout: default
---

The Apache Portable Runtime (APR) and Tomcat Native Libraries are optional components
that give Tomcat access to the Apache's socket implementation and random number generator;
both crucial for efficient SSL/TLS. 

Installing the APR is relatively simple and should be seriously considered on any 
production Tomcat server.

1. Downlaod, make and install the APR libraries.
1. Download, make and install the Tomcat Native libraries.
1. Configure Tomcat to use the new libraries.
1. Tweak the server.xml file since the Connector attributes are slightly different.

### Install APR Libraries

Installing the APR consists of downloading the source code, compiling and installing.

```bash
> wget http://www.anc.org/downloads/apr-1.5.1.tar.gz
> tar -xzf apr-1.5.1.tar.gz
> cd ./apr-1.5.1
> sudo ./configure
> sudo make
> sudo make install
```

### Install Tomcat Native Libraries

The process for installing the Tomcat libraries is almost identical, except we need to 
tell the configure script where:

1. the APR libraries are installed,
1. where Java is installed (JAVA_HOME) and,
1. where Tomcat is installed (CATALINA_HOME).

```bash
> wget http://www.anc.org/downloads/tomcat-native-1.1.31-src.tar.gz
> tar -xzf tomcat-native-1.1.31-src.tar.gz
> cd tomcat-native-1.1.31-src
> ./configure --with-apr=/usr/local/lib/apr/apr-1-config \
            --with-java-home=$JAVA_HOME \
            --with-ssl=yes \
            --prefix=$CATALINA_HOME
> make
> make install
```

<span class="red">NOTE</span> On my system (Ubuntu 12.04 LTS) the APR libraries were installed
to <tt>/usr/local/lib/apr</tt>.  

### Export the Libraries

Edit (or create) $CATALINA_HOME/bin/setenv.sh and add the following two lines:

```bash
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CATALINA_HOME/lib
export LD_LIBRARY_PATH
```

### Modify server.xml

TBD.
