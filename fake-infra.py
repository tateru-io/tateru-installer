#!/usr/bin/env python3

# TODO: Placeholder for real API

from http.server import BaseHTTPRequestHandler, HTTPServer
import json
import sys
import threading

with open(sys.argv[1], 'rb') as f:
    key = f.read()

ssh_pub_key = ''

class ServiceServer(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path.startswith('/v1/machines'):
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.end_headers()
            res = {
                'uuid': '00000000-0000-0000-0000-000000000001',
                'name': 'qemu',
                'managedBy': 'http://localhost:7707/',
            }
            self.wfile.write(json.dumps(res).encode())
        else:
            self.send_response(200)
            self.send_header('Content-type', 'text/plain')
            self.end_headers()
            self.wfile.write(key)

class ManagerServer(BaseHTTPRequestHandler):
    def do_POST(self):
        if self.path.endswith('boot-installer'):
            print(' > Boot installation request')
            length = int(self.headers['content-length'])
            reqd = self.rfile.read(length)
            d = json.loads(reqd)
            ssh_pub_key = d['ssh_pub_key']
            print(' > Updated SSH public key:', ssh_pub_key)
            self.send_response(200)
            self.send_header('Content-type', 'text/plain')
            self.end_headers()
            self.wfile.write(b'')
        else:
            self.send_response(404)
            self.end_headers()
            self.wfile.write(b'404 not found')

if __name__ == '__main__':
    h = HTTPServer(('127.0.0.1', 7708), ServiceServer)
    threading.Thread(target=h.serve_forever, daemon=True).start()
    m = HTTPServer(('127.0.0.1', 7707), ManagerServer)
    m.serve_forever()
