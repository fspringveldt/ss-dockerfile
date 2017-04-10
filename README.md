# ss-dockerfile
My local Dockerfile for SilverStripe for use with Docker-Compose, complete with XDebug support :) 

## Setup via composer
`composer require fspringveldt/ss-dockerfile dev-master --dev`

## Docker-compose setup
* Edit your local hosts file to point db.local, dev.local and pma.local to docker vm ip address
* Create a file named .docker-compose.yml in your project's root directory and copy the below into it:
```yml
version: "2"

services:
  db:
    image: mysql:5.7
    container_name: mysql
    volumes:
      - db-data:/var/lib/mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: ${MYSQL_DATABASE}
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
      VIRTUAL_HOST: ${DB_VIRTUAL_HOST}
  ss:
    build: https://github.com/fspringveldt/ss-dockerfile.git#master
    container_name: ss-site
    links:
      - db
    depends_on:
      - db
    working_dir: /var/www/htdocs
    volumes:
      - ./:/var/www/htdocs
    environment:
      - VIRTUAL_HOST=${SS_VIRTUAL_HOST}
      - DATABASE_SERVER=db
      - XDEBUG_CONFIG=remote_host=${XDEBUG_REMOTE_HOST}
      - MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
      - MYSQL_DATABASE=${MYSQL_DATABASE}
      - MYSQL_USER=${MYSQL_USER}
      - MYSQL_PASSWORD=${MYSQL_PASSWORD}
      - SS_DEFAULT_ADMIN_USERNAME=${SS_ADMIN_USER}
      - SS_DEFAULT_ADMIN_PASSWORD=${SS_ADMIN_PASSWORD}
      - SS_ENVIRONMENT=${SS_ENVIRONMENT}
  nginx-proxy:
    image: jwilder/nginx-proxy
    container_name: nginx-proxy
    ports:
      - "80:80"
    volumes:
      - /var/run/docker.sock:/tmp/docker.sock:ro
      - ./ss-dockerfile/nginx-proxy.conf:/etc/nginx/conf.d/nginx-proxy.conf      
  phpmyadmin:
    container_name: phpmyadmin
    image: phpmyadmin/phpmyadmin
    links:
      - db:mysql
    depends_on:
      - db
    ports:
      - "8181:80"
    environment:
      PMA_HOST: mysql
      MYSQL_ROOT_PASSWORD: password
      VIRTUAL_HOST: ${PMA_VIRTUAL_HOST}
volumes:
  db-data:
```
