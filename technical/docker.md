---
layout: default
title: Creating Docker Images
---

# {{ page.title }}

In Docker lingo it is important to distinguish between an *image* and a *container*.
A Docker *image* is what we make when we get when we run the `docker build` command. A 
Docker *container* is a running instance of an *image*, that is, what we get when we
run the `docker run` command. It is possible to have many running *containers* started from a single *image*. 

## Other Documentation

* [Docker reference](https://docs.docker.com/engine/reference/builder/)
* [Docker explained](https://www.digitalocean.com/community/tutorials/docker-explained-using-dockerfiles-to-automate-building-of-images)
* [Docker tutorial](https://rominirani.com/docker-tutorial-series-writing-a-dockerfile-ce5746617cd#.i175iiq0a)

## Common Directives

#### FROM

The *FROM* directive specifies the base image that will be used for the current image. 
In the LAPPS Grid all images will either be based on one of the `lappsgrid/*` images or one 
of the Galaxy images (typically in the `bgruening/*` namespace).

The following Lappsgrid images are available:

* *lappsgrid/ubuntu* - Ubuntu 14.04 with:
  1. JDK 1.7
  1. PostgreSQL 9.3
  1. emacs, nano, curl, wget, zip, and unzip
* *lappsgrid/tomcat* - Extends the *lappsgrid/ubuntu* image and adds Tomcat 7.

#### COPY

The *COPY* directive takes two parameters, a source and a destination, and as the name
suggests, copies the source file to the destination in the image being built.

**Example**

```
	COPY ./file.txt /usr/local/share/file.txt
```
The above copies file.txt to the /usr/local/share directory in the image being created.

**Note**

Docker will only copy files from the current directory. You cannot specify an arbitrary 
path as the *source*.

#### ADD

The *ADD* directive is the same as the *COPY* directive except it does some extra magic.
In particular, the *ADD* directive will decompress any files when it copies them to the target.

The *ADD* directive's *source* parameter can also be a URL, in which case Docker will download
the file pointed to by the URL and copy it to the target image.

```bash
	ADD http://example.com/file.tgz /usr/share
```


#### RUN

The *RUN* directive can be used to execute arbitrary commands when building the image,

```
	RUN chmod ug+x /usr/local/share/file.txt
```

Long commands can be be split into several lines with the line continuation character \ and
multiple commands can be run in sequence by joining them with the AND (&&) operator.  

```bash
	RUN apt-get update && apt-get upgrade -y && \
	    apt-get install package1 package2 pacakge3 && \
		chmod u+x /usr/bin/startup.sh	    		
```

#### USER

The *USER* directive specifies the user account subsequent command will be *RUN* as.

```bash
	USER joe
	RUN echo 'some data' > /home/joe/file.txt && \
	    chmod a+r /home/joe/file.txt
	    
	USER root
	RUN apt-get install -y package1 package2 package3
```

#### CMD

The **CMD** directive specifies the command that will be run when the container is launched.
When this command terminates the Docker container will exit.

```bash
	CMD /usr/bin/startup.sh
```
