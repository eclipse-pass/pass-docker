#!/bin/bash

docker compose -f eclipse-pass.base.yml -f eclipse-pass.demo.yml -f eclipse-pass.local.yml $@