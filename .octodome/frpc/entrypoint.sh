#!/bin/bash

envsubst < ./template.toml > ./frpc.toml

chmod +x ./frpc
exec ./frpc -c ./frpc.toml
