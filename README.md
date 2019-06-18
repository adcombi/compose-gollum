# docker-compose-gollum
dockerized gollum (git backed wiki) server with an easy to use docker-compose.yml file.

## Docker Usage
Let's assume you have a git repo for your wiki in ~/git/wiki
Here's a script you could use to start the wiki server inside this docker image: `runWiki.sh`

```
#!/bin/bash

LOCAL_WIKI_DIR=~/git/wiki

docker stop wiki
docker rm wiki
docker run --name wiki -p 80:80 -d -v ${LOCAL_WIKI_DIR}:/wiki l3iggs/gollum
```

Then browse to:
http://localhost

The default user/password is gollum/gollum

Note that this example exposes the wiki both via http port 80.

**[Optional] Edit the default login credentials**
You can add `-e WIKI_USER=john -e WIKI_PASS=letmein` to the docker run command line to require the user/password john/letmein for login to your wiki.

## Docker Compose Usage
0. make sure you have a dockerized nginx proxy setup and working:
   recommended: https://github.com/evertramos/docker-compose-letsencrypt-nginx-proxy-companion

1. Clone this repo or copy the code below to a `docker-compose.yml` file.
2. Clone or copy your gollum files/repo to a folder in the same dir as the docker-compose file call it `knowledge-base`
3. Change the `docker-compose.yml` to fit your needs
4. cd into the dir that holds both the `docker-compose.yml` and the `knowledge-base` folder with the gollum repo/files in it.
5. run `docker-compose up -d`
6. visit your wiki at the corresponding url; of course you need a propper cname pointing at the server for this to work.

```yaml
version: "3.5"
services:
  web:
    image: l3iggs/gollum
    container_name: knowledge-base
    expose:
     - "80"
    volumes:
     - ./knowledge-base:/wiki
    environment:
     - WIKI_USER=john
     - WIKI_PASS=letmein
     - VIRTUAL_HOST=wiki.example.com
     - VIRTUAL_PORT=80
     - LETSENCRYPT_HOST=wiki.example.com
     - LETSENCRYPT_EMAIL=your@email.com
networks:
  default:
    external:
      name: webproxy
```
