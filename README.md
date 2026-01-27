# docker-osmedeus v5

## Description

Docker image for Osmedeus, a fully automated offensive security tool for reconnaissance and vulnerability scanning (<https://github.com/j3ssie/Osmedeus>). This image is built upon Kali Linux rolling image.

## How to use this image

The image launches Osmedeus' CLI tool without any arguments, so you have to provide your own to customise Osmedeus execution. Have a look at the inline help and the official documentation for basic and advanced usage examples.

This will show the inline help:

```bash
docker run -it --rm mablanco/osmedeus
```

You can also get all usage examples:

```bash
docker run -it --rm mablanco/osmedeus osmedeus --usage-example
```

This will start a fast analysis of domain `example.com` with logs on the console, deleting the container after finishing:

```bash
docker run -it --rm mablanco/osmedeus osmedeus run -f fast -t example.com
```

In case you want to add persistance to your Osmedeus analysis, create the required volumes and mount them appropiately:

```bash
docker volume create osmedeus_base
docker volume create osmedeus_workspaces
docker run -it --rm -v osmedeus_base:/root/osmedeus-base -v osmedeus_workspaces:/root/workspaces-osmedeus mablanco/osmedeus osmedeus run -t example.com
```

## Web UI

You can start the Web UI, as a daemonized process, with the following command:

```bash
docker run -d --name osmedeus-server -p 8002:8002 mablanco/osmedeus osmedeus server
```

Now the Web UI is accesible at `http://127.0.0.1:8002/`. You can access an already existing volume containing Osmedeus workspaces adding the volume parameters described above.

The credentials to access the Web UI can be obtained executing these commands while the serve is running:

```bash
docker exec -it osmedeus-server osmedeus config view server.username
docker exec -it osmedeus-server osmedeus config view server.password

```

## Building the image

Use the following command to build the image with the `latest` tag:

```bash
docker build -t mablanco/osmedeus --progress=plain .
```

In case you want to tag the image with a custom version, use this command:

```bash
docker build -t mablanco/osmedeus:<version> --progress=plain .
```
