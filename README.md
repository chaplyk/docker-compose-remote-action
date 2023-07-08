# Docker Compose Remote Action

This actions deploys your docker-compose stack file to remote host where docker-compose does not even have to be installed.

## Inputs

### `project_name`
Project name of the compose project

### `ssh_host`
Remote host where docker is running

### `known_host_key`
Remote host key information for `known_hosts` file
Example: `"170.64.163.217 ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAABIKvgeZ/twOBTN2B2MY/f931XhbW0p0zXjBZgL+R1IW7D"`

### `ssh_port`
SSH port on remote host

### `ssh_user`
SSH user on remote host

### `ssh_key`
SSH private key used to access to remote server. 
Better save it into repository secrets.

### `compose_file`
*Optional.* Docker compose filename. Default: `docker-compose.yml`

### `service`
*Optional.* Name of service to be deployed. By default all services are deployed.

### `force_recreate`
*Optional.* Recreate containers even if compose file did not change. Default: false

### `pull`
*Optional.* Pull docker images before deploying. Default: false

### `build`
*Optional.* Build docker images before deploying. Default: false

### `options`
*Optional.* Pass additional options to docker-compose. For example: `--no-deps`

## Example usage

```yaml
steps:
  # need checkout before using docker-compose-remote-action
  - uses: actions/checkout@v2
  - uses: chaplyk/docker-compose-remote-action@v1.1
    with:
      project_name: projectX
      ssh_host: 127.0.0.1
      known_host_key: ${{ secrets.KNOWN_HOST_KEY }}
      ssh_user: username
      ssh_key: ${{ secrets.SSH_KEY }}
      pull: true
      build: true
```
