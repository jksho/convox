---
title: "Changes"
draft: false
slug: Changes
url: /help/changes
---
# Changes

This document outlines the changes from Version 2 (date-based version) Racks to Version 3.x Racks.

## Racks

### Generation 1

Generation 1 Apps are no longer supported

### Infrastructure Providers

#### Version 2

* AWS (ECS)

#### Version 3

* AWS (EKS)
* Digital Ocean
* Google Cloud
* Microsoft Azure

## Apps

### Agent Ports

Agent ports are now defined at the service level instead of underneath the `agent:` block:

#### Version 2
```html
    services:
      datadog:
        agent:
          ports:
            - 8125/udp
            - 8126/tcp
```
#### Version 3
```html
    services:
      datadog:
        agent: true
        ports:
          - 8125/udp
          - 8126/tcp
```

### Scaling

On v3 Racks, the `convox scale {service}` CLI command can be used to update the count value only.  Changes to CPU or Memory values will not be enacted.  These values should be changed in the `convox.yml` directly.

### Sticky Sessions

App services are no longer sticky by default. Sticky sessions can be enabled in `convox.yml`:
```html
    services
      web:
        sticky: true
```
### Timer Syntax

Timers no longer follow the AWS scheduled events syntax where you must have a `?` in either day-of-week or day-of-month column. 

Timers now follow the standard [cron syntax](https://www.freebsd.org/cgi/man.cgi?query=crontab&sektion=5)

As an example a Timer that runs every hour has changed as follows:

#### Version 2
```html
    timers:
      hourlyjob:
        schedule: 0 * * ? *
```
#### Version 3
```html
    timers:
      hourlyjob:
        schedule: 0 * * * *
```

You can read more in the [Timer](/reference/primitives/app/timer) documentation section