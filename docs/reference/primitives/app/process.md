---
title: "Process"
draft: false
slug: Process
url: /reference/primitives/app/process
---
# Process

A Process is a running container that is created by running a command on a [Release](/reference/primitives/app/release).

Long-running Processes are created by [Services](/reference/primitives/app/service) and will be automatically recreated upon termination.

One-off Processes are created with `convox run`.

## Command Line Interface

### Running a One-off Process
```html
    $ convox run web bash -a myapp
    myapp@web-96x6s:/$
```
> You can run a one-off Process using any [Release](/reference/primitives/app/release) with the `--release` option.
 
### Listing Processes
```html
    $ convox ps -a myapp
    ID                    SERVICE  STATUS   RELEASE     STARTED       COMMAND
    web-0a1b2c3d4e-8wkjj  web      running  RABCDEFGHI  1 day ago     bin/web
    web-96x6s             web      running  RABCDEFGHI  1 minute ago  bash
```
### Getting Information about a Process
```html
    $ convox ps info web-6499468bf8-8wkjj -a myapp
    Id        web-6499468bf8-8wkjj
    App       myapp
    Command   bin/web
    Instance  node-0a1b2c3d4e
    Release   RABCDEFGHI
    Service   web
    Started   1 day ago
    Status    running
```
### Terminating a Process
```html
    $ convox ps stop web-6499468bf8-8wkjj -a myapp
    Stopping web-6499468bf8-8wkjj... OK
```
> Terminating a Process that is part of a [Service](/reference/primitives/app/service) will cause a new Process to be started to replace it.