# docker-osmedeus

Docker image for Osmedeus, a fully automated offensive security tool for reconnaissance and vulnerability scanning (<https://github.com/j3ssie/Osmedeus>). This image is built upon Debian's Buster slim image.

In early September 2019, Osmedeus' main developer (j3ssie) launched a beta of the new 2.0 version, which includes a new architecture based on Django and a new API. This README file covers both the 1.5 and the 2.x versions.

## v1.5

The image launches Osmedeus' Web UI and API server using Python's development mode on port 5000 through SSL and a self generated certificated.

### How to use this image

This will start an Osmedeus instance listening on port 5000:

    $ docker run -d -p 5000:5000 --name osmedeus mablanco/osmedeus:1.5-20190812

In case you want to persist the results of your analysis, you can create a volume for that purpose:

    $ docker volume create osmedeus_workspaces
    $ docker run -d -p 5000:5000 --name osmedeus -v osmedeus_workspaces:/root/.osmedeus/workspaces mablanco/osmedeus:1.5-20190812

Now you can interact with Osmedeus from the CLI using the `--client` parameter. For example:

    $ docker exec -it osmedeus ./osmedeus.py --client -t example.com

Once you launch the first analysis, a password for the Web UI will be automatically generated, stored in the `core/config.conf` file inside the container. You can get it this way:

    $ docker exec -it osmedeus cat /root/.osmedeus/config.conf | grep password

You can now access the Web UI with a web browser at port 5000 using HTTPS. Remember that the certificate is self generated, so you will have to instruct your web browser to accept it.

### Note

Osmedeus v1.5 has changed the location of the working directory and now lives at `.osmedeus` under the home directory of the running user.

## v2.x

The image launches Osmedeus' CLI tool without any arguments, so you have to provide your own to modify Osmedeus execution. Have a look at the inline help and the official documentation for basic and advance usage examples.

From v2.1 on, the Docker image `latest` tag references the newest 2.x avaliable version.

### How to use this image

This will show Osmedeus inline help:

    $ docker run -it --rm mablanco/osmedeus

This will start an analysis on domain `example.com` with logs on the console:

    $ docker run -it --rm --name osmedeus --net host mablanco/osmedeus ./osmedeus.py -t example.com

In case you want to persist the results of your analysis, you can create a volume for that purpose:

    $ docker volume create osmedeus_workspaces
    $ docker run -it --rm --name osmedeus -v osmedeus_workspaces:/root/.osmedeus/workspaces --net host mablanco/osmedeus ./osmedeus.py -t example.com

### Note

The Web UI is accesible at `http://127.0.0.1:8000/`, thanks to the `--net host` parameter. Omit it if you don't want the UI to be accessible.

## Building the image

Use the following command to build the image with the `latest` tag:

    $ docker build -t mablanco/osmedeus .

It will fetch the release version specified in the OSMEDEUS_VERSION variable inside the Dockerfile from the source code repository. In case you want to build a different version, first browse the available releases from https://github.com/j3ssie/Osmedeus/releases and then use this command:

   $ docker build --build-arg OSMEDEUS_VERSION=<release> -t mablanco/osmedeus:<release> .

If you want to build the bleeding edge code, use `master` as value for the OSMEDEUS_VERSION variable in the previous command.
