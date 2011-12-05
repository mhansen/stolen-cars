#!/bin/sh
curl -s -d form_id=stolen_vehicles_download_form \
        -d op=Download \
        -d 'nz%5Ball%5D=all'\
        http://www.police.govt.nz/stolen/vehicles \
| funzip > stolenvehicles.csv
