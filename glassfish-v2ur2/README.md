# glassfish-v2ur2

## Purpose
This dockerfile provides a base Glassfish v2ur2 image with the following features:
* Base installation
* Administration console on http://localhost:4848, username/password: admin/adminadmin
* via the docker-entrypoint.sh it can run all .sh files contained on the /docker-entrypoint.d folder of the image prior to starting the glassfish server

## How to configure
If you need to further configure the app server follow these steps:
* Create a folder named i.e. `config`
* Inside this folder add `.sh` files which can use `/bin/sh` and will be run in sequence, i.e. `1.sh`, `2.sh`  
  * Either extend the image
```
FROM lamole73/glassfish-v2ur2
ADD config /docker-entrypoint.d
```
  * Or add config folder as a volume, i.e.
```
docker run -d -p 8080:8080 -p 4848:4848 \
  --name glassfish \
  --mount source=./config,target=/docker-entrypoint.d \
  lamole73/glassfish-v2ur2
```

## How to run ##
Assuming you just want the base glassish application server execute the following
```
docker run -d -p 8080:8080 -p 4848:4848 --name glassfish lamole73/glassfish-v2ur2
```

If you want to also run initialization scripts prior to application server start then add them as a volume with target /docker-entrypoint.d. For example if your scripts are on ./config folder execute the following:
```
docker run -d -p 8080:8080 -p 4848:4848 --name glassfish --mount source=./config,target=/docker-entrypoint.d lamole73/glassfish-v2ur2
```

## How to build
Assuming that we want to build image tag `1` which optionally can be the latest

```
git checkout glassfish-v2ur2-1
cd glassfish-v2ur2
docker build --rm --tag="lamole73/glassfish-v2ur2:1" ./
# to also tag as latest
docker tag lamole73/glassfish-v2ur2:1 lamole73/glassfish-v2ur2
# to also push to github
docker login
docker push lamole73/glassfish-v2ur2:1
docker push lamole73/glassfish-v2ur2
```
