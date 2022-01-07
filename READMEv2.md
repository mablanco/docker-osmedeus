# docker-osmedeus v2

Docker image for Osmedeus, a fully automated offensive security tool for reconnaissance and vulnerability scanning (<https://github.com/j3ssie/Osmedeus>). This image is built upon Debian's Buster slim image.

In early September 2019, Osmedeus' main developer (j3ssie) launched a beta of the new 2.0 version, which includes a new architecture based on Django and a new API. This README file covers both the 1.5 and the 2.x versions.

## v2.x

The image launches Osmedeus' CLI tool without any arguments, so you have to provide your own to modify Osmedeus execution. Have a look at the inline help and the official documentation for basic and advanced usage examples.

From v2.1 on, the Docker image `latest` tag references the newest 2.x available version.

### How to use this image

This will show Osmedeus inline help:

    $ docker run -it --rm mablanco/osmedeus

This will start an analysis on domain `example.com` with logs on the console:

    $ docker run -it --rm --name osmedeus -p 8000:8000 mablanco/osmedeus ./osmedeus.py -t example.com

In case you want to persist the results of your analysis, you can create a volume for that purpose:

    $ docker volume create osmedeus_workspaces
    $ docker run -it --rm --name osmedeus -v osmedeus_workspaces:/root/.osmedeus/workspaces -p 8000:8000 mablanco/osmedeus ./osmedeus.py -t example.com

### Server-client architecture (as in v1.5)

In case you'd like to work like in v1.5, i.e. launching separate server and client instances, you can do so modifying the running parameters.

This will start a server instance listening on port 8000 using an existing data volume:

    $ docker run -d --rm --name osmedeus-server -v osmedeus_workspaces:/root/.osmedeus/workspaces -p 8000:8000 mablanco/osmedeus python3 server/manage.py runserver 0.0.0.0:8000

Use `-it` instead of `-d` if you want logs to debug the server. The API is now ready at 8000. You can also launch new scans against the server instance like this:

    $ docker run -it --rm --name osmedeus-scan mablanco/osmedeus ./osmedeus.py --remote http://<server_ip>:8000 --client -t example.com

Remember not to use `localhost` as the server IP when running both containers in the same machine as the client one will then try to access the server instance inside itself. In order to improve this connection, you could use advanced Docker networking capabilities, like a private network, the legacy `--link` parameter or the more modern `--alias` parameter.

This architecture is useful for e.g. running an Osmedeus central server or for accessing the results of previous scans without launching a new one.

### Web UI

The Web UI is accesible at `http://127.0.0.1:8000/`, thanks to the `-p 8000:8000` parameter. Omit it if you don't want the UI to be accessible.

The password to access the Web UI can be obtained executing this command:

    $ docker exec -it osmedeus grep password /root/.osmedeus/client.conf

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

## Building the image

Use the following command to build the image with the `latest` tag:

    $ docker build -t mablanco/osmedeus .

It will fetch from the source code repository the release version specified in the OSMEDEUS_VERSION variable inside the Dockerfile. In case you want to build a different version, browse the available releases from <https://github.com/j3ssie/Osmedeus/releases> and then use this command:

    $ docker build --build-arg OSMEDEUS_VERSION=<release> -t mablanco/osmedeus:<release> .

If you want to build the bleeding edge code, use `master` as value for the OSMEDEUS_VERSION variable in the previous command.
