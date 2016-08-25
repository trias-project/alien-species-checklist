import sys
import argparse
import itertools

# Way to call script:

# verify_synonyms.py input_file output_file --synonymlist --usagekeycol --acceptedkeycol --remarkcol

# What script should do

# Use usagekeycol and acceptedkeycol to lookup a match in the synonymlist

## If match found and status = ok => populate remarkcol with: ok: SYNONYM verified
## If match found and status <> ok => populate remarkcol with: verify: SYNONYM <status>
## If no match found: do nothing
