#!/bin/bash
# The invenio-cli python package must be installed for this script to run. https://inveniordm.docs.cern.ch/install/cli/

cd ./pass-docker-invenio-rdm
docker compose -f ../../certs/cert-gen-invenio.yml up
docker compose -f ../../certs/cert-gen-invenio.yml down -v
invenio-cli packages lock
invenio-cli containers build
