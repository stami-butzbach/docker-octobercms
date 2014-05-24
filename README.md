# docker-octobercms-nginx-ssh

A Dockerfile that installs the latest [octobercms](https://github.com/octobercms/october), nginx, mysql, ssh, php-apc and php-fpm.

This is a forked version from [eugeneware](https://github.com/eugeneware/docker-wordpress-nginx). All credits go to him.

## Installation

```
$ git clone https://github.com/alexeymasolov/docker-octobercms-nginx-ssh.git
$ cd docker-octobercms-nginx-ssh
$ sudo docker build -t="docker-octobercms-nginx-ssh" .
```

## Usage

To spawn a new instance of octobercms with name **myoctober**:

```bash
$ sudo docker run --name="myoctober" -p 80 -p 22 -d docker-octobercms-nginx-ssh
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
