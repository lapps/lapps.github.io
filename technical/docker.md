---
layout: slate
title: Creating Docker Images
---

# {{ page.title }}

In Docker lingo it is important to distinguish between an **image** and a **container**.
A Docker **image** is what we make when we get when we run the `docker build` command. A 
Docker **container** is a running instance of an **image**, that is, what we get when we
run the `docker run` command. 

It is possible to have many running *containers* of the
same *image*. 

Docker uses a *copy on write* strategy

## Common Commands

**FROM**

Explain inheritance.

**ADD**<br/>
**COPY**

Explain ADD and COPY

**ENV**

What does ENV do?



