# docker-grpc-tools

[![](https://images.microbadger.com/badges/image/newtonsystems/tools-docker-grpc-tools:0.2.6.svg)](https://microbadger.com/images/newtonsystems/tools-docker-grpc-tools:0.2.6 "Get your own image badge on microbadger.com")

[![](https://images.microbadger.com/badges/version/newtonsystems/tools-docker-grpc-tools:0.2.6.svg)](https://microbadger.com/images/newtonsystems/tools-docker-grpc-tools:0.2.6 "Get your own version badge on microbadger.com")

Available from docker hub as [newtonsystems/tools/docker-grpc-tools](https://hub.docker.com/r/newtonsystems/tools-docker-grpc-tools/)

#### Supported tags and respective `Dockerfile` links

-    [`v0.2.6`,`v0.2.5`, `v0.2.4 (avoid)`, `v0.2.3`, `v0.2.2`, `v0.2.1`, `v0.2.0`, `latest` (/Dockerfile*)](https://github.com/newtonsystems/devops/blob/master/tools/docker-grpc-tools/Dockerfile)

# What is docker-grpc-tools?

A base docker image to be used for circleci for compiling and building grpc services.


## How to use with circleci

- Add image to `image:` in circleci config

``` yml
version: 2.0
jobs:
  build:
    docker:
      - image: newtonsystems/tools/docker-grpc-tools:0.0.1
```


## How to do a release
- Make sure you are using docker-utils
i.e.

```bash
export PATH="~/<LOCATION>/docker-utils/bin:$PATH"
```

```
build-tag-push-dockerfile.py  --image "newtonsystems/tools-docker-grpc-tools" --version 0.2.7 --dockerhub_release --github_release
```


## Future

- Keep an eye on: [grpc-docker-library](https://github.com/grpc/grpc-docker-library/tree/master/1.0)
- Get alpine version working
