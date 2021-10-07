#!/bin/sh

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

# rename compose file if not docker-compose.yaml
if ! [ -z "$INPUT_COMPOSE_FILE" ]; then
  mv $INPUT_COMPOSE_FILE docker-compose.yaml
fi

# create private key and add it to authentication agent
mkdir -p $HOME/.ssh
printf '%s\n' "$INPUT_SSH_KEY" > "$HOME/.ssh/private_key"
chmod 600 "$HOME/.ssh/private_key"
eval $(ssh-agent)
ssh-add "$HOME/.ssh/private_key"

# create remote context in docker and switch to it
docker context create remote --docker "host=ssh://$INPUT_SSH_USER@$INPUT_SSH_HOST"
docker context use remote

# pull latest images if paramether provided
if [ $INPUT_PULL == 'true' ]; then
  docker-compose pull
fi

# deploy stack
docker-compose up -d $INPUT_BUILD $INPUT_FORCE_RECREATE $INPUT_OPTIONS $INPUT_SERVICE
