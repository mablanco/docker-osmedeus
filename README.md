# docker-osmedeus v4

## Description

Docker image for Osmedeus, a fully automated offensive security tool for reconnaissance and vulnerability scanning (<https://github.com/j3ssie/Osmedeus>). This image is built upon Debian's Bullseye slim image.

On 1st January 2022, Osmedeus' main developer (j3ssie) launched a beta of the new 4.0 version, which superseeds the previous v2 based on Django. While README file covers v4, the READEMv2 file covers both the 1.5 and the 2.x versions.

From v4.0.0 on, the Docker image `latest` tag references the newest 4.x available version.

## How to use this image

The image launches Osmedeus' CLI tool without any arguments, so you have to provide your own to modify Osmedeus execution. Have a look at the inline help and the official documentation for basic and advanced usage examples.

This will show Osmedeus inline help:

    $ docker run -it --rm mablanco/osmedeus

This will start an analysis on domain `example.com` with logs on the console and deleting the container after finishing:

    $ docker run -it --rm mablanco/osmedeus osmedeus scan -t example.com

In case you want to persist the results of your analysis, you can create a volume for that purpose:

    $ docker volume create osmedeus_workspaces
    $ docker run -it --rm -v osmedeus_workspaces:/root/.osmedeus/workspaces mablanco/osmedeus osmedeus scan -t example.com

## Web UI

You can start the Web UI, as a daemonized process, with the following command:

    $ docker run -d --name osmedeus-server -p 8000:8000 mablanco/osmedeus osemdeus server

Now the Web UI is accesible at `https://127.0.0.1:8000/`. You can access an already existing volume containing Osmedeus workspaces adding the above volume parameters.

The password to access the Web UI can be obtained executing this command:

    $ docker exec -it osmedeus grep password  /root/.osmedeus/config.yaml

## Building the image

Use the following command to build the image with the `latest` tag:

    $ docker build -t mablanco/osmedeus .

In case you want to tag the image with a different version, use this command:

    $ docker build -t mablanco/osmedeus:<release> .
