#!/bin/bash
# The invenio-cli python package must be installed for this script to run. https://inveniordm.docs.cern.ch/install/cli/

cd ./pass-docker-invenio-rdm
invenio-cli packages lock
invenio-cli containers build
