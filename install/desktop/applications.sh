#!/bin/bash

for script in ${OMAKUB_PATH:-~/.local/share/omakub}/applications/*.sh; do source $script; done
