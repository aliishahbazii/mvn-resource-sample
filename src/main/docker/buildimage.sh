#!/bin/sh

# if container exist stop it
#[[ -n "$(docker ps -a | grep "@docker.build.image@")" ]] && docker stop "@docker.build.image@" >/dev/null && echo Stopped container "@docker.build.image@" && docker rm "@docker.build.image@" 2>/dev/null

#if image exist remove it
#[[ -n "$(docker images -q @docker.build.image@:@docker.build.tag@ 2>/dev/null)" ]] && echo "Remove exists image " && docker rmi -f @docker.build.image@:@docker.build.tag@

printf "===== build new image ===== \n"
docker build --tag @docker.image.name@:@docker.image.tag@ .
