import http.server
import socketserver
import sys

# Locate port from '--port <value>', trailing positional args, or default to 5000
PORT = 5000
if "--port" in sys.argv:
    try:
        port_index = sys.argv.index("--port") + 1
        PORT = int(sys.argv[port_index])
    except (IndexError, ValueError):
        PORT = 5000
elif len(sys.argv) > 1:
    for arg in reversed(sys.argv[1:]):
        if arg.isdigit():
            PORT = int(arg)
            break

Handler = http.server.SimpleHTTPRequestHandler

with socketserver.TCPServer(("", PORT), Handler) as httpd:
    print(f"Serving at port {PORT}")
    httpd.serve_forever()