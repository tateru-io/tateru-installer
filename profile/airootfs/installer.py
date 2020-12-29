#!/usr/bin/env python3

# TODO: Placeholder for real API
# Just get the SSH key for now

import requests
import sys
import time
import traceback
import urllib.parse

with open('/proc/cmdline', 'r') as f:
    cmdline = f.read()
parts = cmdline.split(' ')
for part in parts:
    if 'svc' in part:
        svc = part.split('=', 1)[1].strip()
        break
else:
    raise Exception('Error NO-SVC: No svc= parameter was provided on kernel command line')

with open('/sys/devices/virtual/dmi/id/product_uuid', 'r') as f:
    product_uuid = f.read().strip()
with open('/sys/devices/virtual/dmi/id/product_serial', 'r') as f:
    product_serial = f.read().strip()
data = {
        'uuid': product_uuid,
        'serial': product_serial,
    }

print('Machine data:', data)

ssh_pub_key = ''
while True:
    # TODO: backoff
    try:
        r = requests.post(urllib.parse.urljoin(svc, '/v1/installer-callback'), json=data)
        if r.status_code == 204:
            print('No installation request found for me, waiting a bit...')
        elif r.status_code == 200:
            ssh_pub_key = r.json()['ssh_pub_key']
            break
        print(f'Tateru machine service returnd code {r.status_code}, will retry')
    except Exception as err:
        print('Unexpected Tateru service call error:')
        traceback.print_tb(err.__traceback__)
    time.sleep(5)

with open('/etc/authorized_keys', 'w') as f:
    f.write(ssh_pub_key)
print('SSH public key installed')
