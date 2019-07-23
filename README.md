# docker-osmedeus

Docker image for Osmedeus, a fully automated offensive security tool for reconnaissance and vulnerability scanning (<https://github.com/j3ssie/Osmedeus>).

This image is built upon Debian Stretch slim image and launches Osmedeus' Web UI and API server through Python (i.e. development mode) on port 5000.

## How to use this image

This will start an Osmedeus instance listening on port 5000 (the `--net` parameter is needed to able to authenticate against the Web UI):

    $ docker run -d --net host --name osmedeus mablanco/osmedeus
    
### For MacOs

    $ docker run -d -p 5000:5000 --name osmedeus mablanco/osmedeus

In case you want to persist the result of your analysis, you can create a volume for that purpose:

    $ docker volume create osmedeus_workspaces
    $ docker run -d --net host --name osmedeus -v osmedeus_workspaces:/home/Osmedeus/workspaces mablanco/osmedeus

Now you can interact with Osmedeus from the CLI using the `--client` parameter. For example:

    $ docker exec -it osmedeus ./osmedeus.py --client -t example.com

Once you launch the first analysis, a password for the Web UI will be automatically generated, stored in the `core/config.conf` file inside the container. You can now access the Web UI with a web browser at port 5000.
