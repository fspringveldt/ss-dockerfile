# ss-dockerfile
My local Dockerfile for SilverStripe for use with Docker-Compose :)

##Setup via composer
`composer require fspringveldt/ss-dockerfile dev-master --dev`

##Docker-compose setup
*Edit your local hosts file to point db.local, dev.local and pma.local to docker vm ip address
*Create a file named .docker-compose.yml in your project's root directory and copy the below into it:
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
      MYSQL_ROOT_PASSWORD: password
      MYSQL_DATABASE: ss-site
      MYSQL_USER: root
      MYSQL_PASSWORD: password
      VIRTUAL_HOST: 'db.local'
  ss:
    build: ./ss-dockerfile/
    container_name: ss-site
    links:
      - db
    depends_on:
      - db
    working_dir: /var/www/html
    volumes:
      - ./:/var/www/html
    environment:
      - VIRTUAL_HOST=dev.local
  nginx-proxy:
    image: jwilder/nginx-proxy
    container_name: nginx-proxy
    ports:
      - "80:80"
    volumes:
      - /var/run/docker.sock:/tmp/docker.sock:ro
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
      VIRTUAL_HOST: 'pma.local'
volumes:
  db-data:
```
