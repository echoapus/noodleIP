#!/bin/bash

# The -G option will convert form parameters (-d options) into query parameters.
# The BLACKLIST endpoint is a GET request.
curl -G https://api.abuseipdb.com/api/v2/blacklist \
-d confidenceMinimum=90 \
-H "Key: 905604b06af7c460a59eb5215eb4280f4544f7d863b95b31e4439e6a7bff7c6e30531e87353e4fd3" \
-H "Accept: text/plain"

