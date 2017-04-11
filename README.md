# ss-dockerfile
My local Dockerfile for SilverStripe for use with Docker-Compose, complete with XDebug support :) 

## Setup
1. Install docker by [following this guide.](https://docs.docker.com/engine/getstarted/step_one/) 
2. Create a file named **.env** as below in your project's root directory, adding values after the equals signs
```txt
MYSQL_ROOT_PASSWORD=
MYSQL_DATABASE=
MYSQL_USER=
MYSQL_PASSWORD=
XDEBUG_REMOTE_HOST=
SS_ADMIN_USER=
SS_ADMIN_PASSWORD=
SS_ENVIRONMENT=
PMA_VIRTUAL_HOST=
DB_VIRTUAL_HOST=
SS_VIRTUAL_HOST=
```

3. Edit your local hosts file to point values given for PMA_VIRTUAL_HOST, DB_VIRTUAL_HOST and SS_VIRTUAL_HOST (defined in .env file above) to docker vm ip address
4. Create a file named **docker-compose.yml** in your project's root directory and copy the below into it:
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
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      VIRTUAL_HOST: ${PMA_VIRTUAL_HOST}
volumes:
  db-data:
```
5. Run `docker-compose build` and then start your containers with `docker-compose up -d`. Use `docker-compose down` to stop them, and `docker-compose down -v` to remove mounted volumes.

At this stage, if all goes well, you can shell to your ss container `docker exec -ti ss-site /bin/bash`, from where you can run your  `composer create-project ...` commands.

##

## Additional resources:
1. Below is an exampler of a SilverStripe environment file **(_ss_environment.php)** syntax:
```php
<?php
    /**
     * Created by PhpStorm.
     * User: francospringveldt
     * Date: 2017/02/23
     * Time: 8:26 AM
     */
    /* What kind of environment is this: development, test, or live (i.e. production)? */
    define('SS_ENVIRONMENT_TYPE', getenv('SS_ENVIRONMENT') ?: 'live');
    /* Database connection */
    //NB: You can substitute getenv() with string values of your choice if you choose.
    define('SS_DATABASE_SERVER', getenv('DATABASE_SERVER'));
    define('SS_DATABASE_NAME', getenv('MYSQL_DATABASE'));
    define(
        'SS_DATABASE_USERNAME', getenv(
            'MYSQL_USER'
        )
    );
    define('SS_DATABASE_PASSWORD', getenv('MYSQL_PASSWORD'));
    /* Configure a default username and password to access the CMS on all sites in this environment. */
    define('SS_DEFAULT_ADMIN_USERNAME', getenv('SS_DEFAULT_ADMIN_USERNAME'));
    define('SS_DEFAULT_ADMIN_PASSWORD', getenv('SS_DEFAULT_ADMIN_PASSWORD'));
    $host = sprintf('http://%s', getenv('VIRTUAL_HOST'));
    global $_FILE_TO_URL_MAPPING;
    $_FILE_TO_URL_MAPPING['/var/www/html'] = $host;
```

