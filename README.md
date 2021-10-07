# Docker Compose Remote Action

This actions deploys your docker-compose stack file to remote host where docker-compose does not even has to be installed.

## Inputs

### `ssh_host`
Remote host where docker is running

### `ssh_user`
SSH user on remote host

### `ssh_key`
SSH private key used to access to remote server. 
Better save it into repository secrets.

### `compose_file`
*Optional.* Docker compose filename. Default: `docker-compose.yml`

### `force_recreate`
*Optional.* Recreate containers even if compose file did not change.

## Example usage

```yaml
steps:
  # need checkout before using docker-compose-remote-action
  - uses: actions/checkout@v2
  - uses: chaplyk/docker-compose-remote-action@v1.0.0
    with:
      ssh_host: 127.0.0.1
      ssh_user: username
      ssh_key: ${{ secrets.SSH_KEY }}
      compose_file: 'docker-compose.yml'
      
```
