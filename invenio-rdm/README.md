# Test InvenioRDM

This is a InvenioRDM instance that can be run locally for testing.

**Note**: This is only intended for local testing and is not meant for Production use.

The `pass-docker-invenio-rdm` directory was created following these instructions: https://inveniordm.docs.cern.ch/install/

## Getting started

**Prerequisites**
- You must have Python v3.8 or greater installed.
- You must have the `invenio-cli` python tool installed and available in your PATH.  https://inveniordm.docs.cern.ch/install/cli/

Run the following commands in order to start the InvenioRDM instance:

```console
./build.sh
./start.sh
```

The above commands first builds the application docker image and afterwards
starts the application and related services (database, Elasticsearch, Redis
and RabbitMQ). The build and boot process will take some time to complete,
especially the first time as docker images have to be downloaded during the
process.

Once running, visit https://127.0.0.1 in your browser.

**Note**: The server is using a self-signed SSL certificate, so your browser
will issue a warning that you will have to by-pass.

To stop the InvenioRDM instance, run the following commands:

```console
./stop.sh
```
