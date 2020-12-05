#!/usr/bin/env python3

# TODO: Placeholder for real API

from http.server import BaseHTTPRequestHandler, HTTPServer
import sys

with open(sys.argv[1], 'rb') as f:
    key = f.read()

class Server(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/plain')
        self.end_headers()
        self.wfile.write(key)

if __name__ == '__main__':
    h = HTTPServer(('127.0.0.1', 7708), Server)
    h.serve_forever()
