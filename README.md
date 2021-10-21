 [![GitHub: fourdollars/trigger-resource](https://img.shields.io/badge/GitHub-fourdollars%2Ftrigger%E2%80%90resource-darkgreen.svg)](https://github.com/fourdollars/trigger-resource/) [![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT) [![Bash](https://img.shields.io/badge/Language-Bash-red.svg)](https://www.gnu.org/software/bash/) ![Docker](https://github.com/fourdollars/trigger-resource/workflows/Docker/badge.svg) [![Docker Pulls](https://img.shields.io/docker/pulls/fourdollars/trigger-resource.svg)](https://hub.docker.com/r/fourdollars/trigger-resource/)
# trigger-resource
[concourse-ci](https://concourse-ci.org/)'s trigger-resource to generate random digest everytime when it checks or puts.

![trigger-all-jobs](https://github.com/fourdollars/trigger-resource/blob/main/diagram.png?raw=true)
![chain-jobs](https://github.com/fourdollars/trigger-resource/blob/main/chain-jobs.png?raw=true)

## Config 

### Resource Type

```yaml
resource_types:
- name: trigger
  type: registry-image
  check_every: never
  source:
    repository: fourdollars/trigger-resource
    tag: latest
```

or

```yaml
resource_types:
- name: trigger
  type: registry-image
  check_every: never
  source:
    repository: ghcr.io/fourdollars/trigger-resource
    tag: latest
```

### Resource

```yaml
resources:
- name: trigger-all-jobs
  icon: restart
  type: trigger
  check_every: never
  webhook_token: secret
- name: trigger-job1
  icon: restart
  type: trigger
  check_every: never
  webhook_token: secret
- name: trigger-job2
  icon: restart
  type: trigger
  check_every: never
  webhook_token: secret
- name: trigger-job3
  icon: restart
  type: trigger
  check_every: never
  webhook_token: secret
```

### Example

![trigger-all-jobs](https://github.com/fourdollars/trigger-resource/blob/main/diagram.png?raw=true)

```yaml
jobs:
- name: job1
  disable_manual_trigger: true
  plan:
  - get: trigger-all-jobs
    trigger: true
  - task: check
    config:
      platform: linux
      image_resource:
        type: registry-image
        source:
          repository: alpine
          tag: latest
      run:
        path: sh
        args:
        - -exc
        - |
          echo "Job 1"
- name: job2
  disable_manual_trigger: true
  plan:
  - get: trigger-all-jobs
    trigger: true
  - task: check
    config:
      platform: linux
      image_resource:
        type: registry-image
        source:
          repository: alpine
          tag: latest
      run:
        path: sh
        args:
        - -exc
        - |
          echo "Job 2"
- name: job3
  disable_manual_trigger: true
  plan:
  - get: trigger-all-jobs
    trigger: true
  - task: check
    config:
      platform: linux
      image_resource:
        type: registry-image
        source:
          repository: alpine
          tag: latest
      run:
        path: sh
        args:
        - -exc
        - |
          echo "Job 3"
```

![chain-jobs](https://github.com/fourdollars/trigger-resource/blob/main/chain-jobs.png?raw=true)

```yaml
jobs:
- name: job1
  disable_manual_trigger: true
  plan:
  - get: trigger-job1
    trigger: true
  - task: check
    config:
      platform: linux
      image_resource:
        type: registry-image
        source:
          repository: alpine
          tag: latest
      run:
        path: sh
        args:
        - -exc
        - |
          echo "Job 1"
  - put: trigger-job2
- name: job2
  disable_manual_trigger: true
  plan:
  - get: trigger-job2
    trigger: true
    passed: [job1]
  - task: check
    config:
      platform: linux
      image_resource:
        type: registry-image
        source:
          repository: alpine
          tag: latest
      run:
        path: sh
        args:
        - -exc
        - |
          echo "Job 2"
  - put: trigger-job3
- name: job3
  disable_manual_trigger: true
  plan:
  - get: trigger-job3
    trigger: true
    passed: [job2]
  - task: check
    config:
      platform: linux
      image_resource:
        type: registry-image
        source:
           repository: alpine
           tag: latest
       run:
         path: sh
         args:
         - -exc
         - |
           echo "Job 3"
```
