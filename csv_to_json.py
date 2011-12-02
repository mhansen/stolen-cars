#!/usr/bin/env python
"""
Module docstring
This serves as a long usage message.
"""
import sys
import simplejson as json

o = []

for line in sys.stdin:
    plate, color, make, model, year, t, date_reported, region = line.split(",")
    o.append({
        "plate": plate,
        "color": color,
        "make": make,
        "model": model,
        "year": int(year),
        "type": t,
        "dateReportedStolen": date_reported,
        "region": region
        })

print json.dumps(o)
