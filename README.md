# docker-octobercms based on debian

A Dockerfile that installs the latest [octobercms](https://github.com/octobercms/october), nginx, mysql, ssh, php-apc and php-fpm on a debian installation.

This is a forked version from [eugeneware](https://github.com/alexeymasolov/docker-octobercms-nginx-ssh.git). All credits go to him.

## Installation

```
$ git clone https://github.com/stami-butzbach/docker-octobercms.git
$ cd docker-octobercms
$ sudo docker build -t="docker-octobercms" .
```

.. or with docker-composer

```bash
$ git clone https://github.com/stami-butzbach/docker-octobercms.git
$ cd docker-octobercms
$ sudo docker-composer up
```

## Usage

To spawn a new instance of octobercms with name **myoctober**:

```bash
$ sudo docker run --name="myoctober" -p 80 -p 22 -d docker-octobercms
```

Use this name to check the port it's on:
```bash
$ sudo docker port myoctober 80 # Make sure to change the name to yours!
```

This command returns the container external port, which you can use to access OctoberCMS from your host machine:

```bash
$ sudo docker port myoctober 80
0.0.0.0:49160
```

You can the visit the following URL in a browser on your host machine to get started:

```
http://127.0.0.1:<port>
```
