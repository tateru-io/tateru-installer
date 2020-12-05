#!/usr/bin/env python3

# TODO: Placeholder for real API
# Just get the SSH key for now

import requests

with open('/proc/cmdline', 'r') as f:
    cmdline = f.read()
parts = cmdline.split(' ')
for part in parts:
    if 'svc' in part:
        svc = part.split('=', 1)[1].strip()
        break
else:
    raise Exception('Error NO-SVC: No svc= parameter was provided on kernel command line')

r = requests.get(svc)
with open('/etc/authorized_keys', 'w') as f:
    f.write(r.text)
print('SSH public key installed')
