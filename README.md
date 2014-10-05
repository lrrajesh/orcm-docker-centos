## Docker context for Open RCM

### Boot2Docker (docker for mac)
see mac instruction at [http://docs.docker.com/installation/mac/](http://docs.docker.com/installation/mac/)
only needed first time: `boot2docker init`
start boot2docker: `boot2docker start`
`export  DOCKER_HOST=tcp://192.168.59.103:2375` (IP could change, use `boot2docker ip` to get IP)

### Basic Idea
`docker run -it benmcclelland/centos-orcm-git orcmd`

### Dockerhub:
[https://registry.hub.docker.com/repos/benmcclelland/](https://registry.hub.docker.com/repos/benmcclelland/)
