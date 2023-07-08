#!/bin/sh

# check if required paramethers provided
if [ -z "$INPUT_PROJECT_NAME" ]; then
  echo "Input project_name is required!"
  exit 1
fi

# check if required paramethers provided
if [ -z "$INPUT_SSH_KEY" ]; then
  echo "Input ssh_key is required!"
  exit 1
fi

if [ -z "$INPUT_SSH_USER" ]; then
  echo "Input ssh_user is required!"
  exit 1
fi

if [ -z "$INPUT_SSH_HOST" ]; then
  echo "Input ssh_host is required!"
  exit 1
fi

if [ -z "$INPUT_KNOWN_HOST_KEY" ]; then
  echo "Input known_host_key is required!"
  exit 1
fi

# set correct values to paramethers
if [ "$INPUT_BUILD" == 'true' ]; then
  INPUT_BUILD='--build'
else
  INPUT_BUILD=''
fi

if [ "$INPUT_FORCE_RECREATE" == 'true' ]; then
  INPUT_FORCE_RECREATE='--force-recreate'
else
  INPUT_FORCE_RECREATE=''
fi

# set INPUT_SSH_PORT variable if not provided
if [ -z "$INPUT_SSH_PORT" ]; then
  INPUT_SSH_PORT=22
fi

mkdir -p $HOME/.ssh

# add host to known hosts
echo $INPUT_KNOWN_HOST_KEY > "$HOME/.ssh/known_hosts"

# create private key and add it to authentication agent
printf '%s\n' "$INPUT_SSH_KEY" > "$HOME/.ssh/private_key"
chmod 600 "$HOME/.ssh/private_key"
eval $(ssh-agent)
ssh-add "$HOME/.ssh/private_key"

# create remote context in docker and switch to it
docker context create remote --docker "host=ssh://$INPUT_SSH_USER@$INPUT_SSH_HOST:$INPUT_SSH_PORT"
docker context use remote

# pull latest images if paramether provided
if [ "$INPUT_PULL" == 'true' ]; then
  docker-compose -p $INPUT_PROJECT_NAME pull $INPUT_SERVICE
fi

# deploy stack
docker-compose -p $INPUT_PROJECT_NAME up -d $INPUT_BUILD $INPUT_FORCE_RECREATE $INPUT_OPTIONS $INPUT_SERVICE

# cleanup context
docker context use default 
docker context rm remote
