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

# rename stack file if not docker-compose.yaml
if ! [ -z "$INPUT_STACK_FILENAME" ]; then
  mv $INPUT_STACK_FILENAME docker-compose.yaml
fi

# create private key and add it to authentication agent
printf '%s\n' "$INPUT_SSH_KEY" > "$HOME/.ssh/private_key"
chmod 600 "$HOME/.ssh/private_key"
eval $(ssh-agent)
ssh-add "$HOME/.ssh/private_key"

# create remote context in docker and switch to it
docker context create remote --docker "host=ssh://$INPUT_SSH_USER@$INPUT_SSH_HOST"
docker context use remote

# pull latest images if paramether provided
if [ $INPUT_PULL = 'true' ]; then
  docker-compose pull
fi

# deploy stack
docker-compose up -d $INPUT_BUILD $INPUT_FORCE_RECREATE $INPUT_OPTIONS $INPUT_SERVICE
