# docker-osmedeus

Docker image for Osmedeus, a fully automated offensive security tool for reconnaissance and vulnerability scanning (<https://github.com/j3ssie/Osmedeus>). This image is built upon Debian's Buster slim image.

In early September 2019, Osmedeus' main developer (j3ssie) launched a beta of the new 2.0 version, which includes a new architecture based on Django and a new API. This README file covers both the 1.5 and the 2.0 versions.

## v1.5

The image launches Osmedeus' Web UI and API server using Python's development mode on port 5000 through SSL and a self generated certificated.

### How to use this image

This will start an Osmedeus instance listening on port 5000:

    $ docker run -d -p 5000:5000 --name osmedeus mablanco/osmedeus

In case you want to persist the results of your analysis, you can create a volume for that purpose:

    $ docker volume create osmedeus_workspaces
    $ docker run -d -p 5000:5000 --name osmedeus -v osmedeus_workspaces:/root/.osmedeus/workspaces mablanco/osmedeus

Now you can interact with Osmedeus from the CLI using the `--client` parameter. For example:

    $ docker exec -it osmedeus ./osmedeus.py --client -t example.com

Once you launch the first analysis, a password for the Web UI will be automatically generated, stored in the `core/config.conf` file inside the container. You can get it this way:

    $ docker exec -it osmedeus cat /root/.osmedeus/config.conf | grep password

You can now access the Web UI with a web browser at port 5000 using HTTPS. Remember that the certificate is self generated, so you will have to instruct your web browser to accept it.

### Note

Osmedeus v1.5 has changed the location of the working directory and now lives at `.osmedeus` under the home directory of the running user.

<<<<<<< HEAD
## v2.0-beta
=======
## v2.1
>>>>>>> 2.1

The image launches Osmedeus' CLI tool without any arguments, so you have to provide your own to modify Osmedeus execution. Have a look at the inline help and the official documentation for basic and advance usage examples.

### How to use this image

This will show Osmedeus inline help:

<<<<<<< HEAD
    $ docker run -it --rm mablanco/osmedeus:2.0-beta

This will start an analysis on domain `example.com` with logs on the console:

    $ docker run -it --rm --name osmedeus --net host mablanco/osmedeus:2.0-beta ./osmedeus.py -t example.com
=======
    $ docker run -it --rm mablanco/osmedeus:2.1

This will start an analysis on domain `example.com` with logs on the console:

    $ docker run -it --rm --name osmedeus --net host mablanco/osmedeus:2.1 ./osmedeus.py -t example.com
>>>>>>> 2.1

In case you want to persist the results of your analysis, you can create a volume for that purpose:

    $ docker volume create osmedeus_workspaces
<<<<<<< HEAD
    $ docker run -it --rm --name osmedeus -v osmedeus_workspaces:/root/.osmedeus/workspaces --net host mablanco/osmedeus:2.0-beta ./osmedeus.py -t example.com

### Note

The Web UI is accesible through port 8000, but it doesn't work right now. Django seems to be unable to find the HTML templates (this issue is being investigated).
=======
    $ docker run -it --rm --name osmedeus -v osmedeus_workspaces:/root/.osmedeus/workspaces --net host mablanco/osmedeus:2.1 ./osmedeus.py -t example.com

### Note

The Web UI is accesible at `http://127.0.0.1:8000/`, thanks to the `--net host` parameter. Omit it if you don't want the UI to be accessible.
>>>>>>> 2.1
