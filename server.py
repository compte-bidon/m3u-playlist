from pathlib import Path
from http.server import ThreadingHTTPServer, BaseHTTPRequestHandler
import socket
import subprocess
import sys
import os
import threading
import time
import importlib.util

PORT = 80

m3u_content = "#EXTM3U"
channel_modules = {}

class MyHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        
        print(self.path)
        paths = self.path.split("/")
        if paths[1] == "": # / -> Get m3u complete playlist
            content = m3u_content.encode("utf-8")
            
            self.send_response(200)
            self.send_header("Content-type", "text/plain; charset=utf-8")
            self.send_header("X-Content-Type-Options", "nosniff") # so that some browsers don't trigger a download
            self.send_header("Content-Length", str(len(content)))
            
            self.end_headers()
            
            self.wfile.write(content)
        
        elif len(paths) == 3:
            group_name, module_name = paths[1], paths[2]
            m3u8 = channel_modules[group_name][module_name].get_m3u8()
            
            self.send_response(302)
            self.send_header("Location", m3u8)
            self.send_header("Content-Length", "0")
            
            self.end_headers()
            
            self.wfile.write(b'')
        else:
            self.send_response(404)
            self.send_header("Content-Length", "0")
        
# Get local IP
def get_local_ip():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        # doesn't actually send anything
        s.connect(("8.8.8.8", 80))
        ip = s.getsockname()[0]
    finally:
        s.close()
    return ip

local_ip = get_local_ip()

root = Path()
groups_dir = Path("groups")

# Loop through each subfolder in groups
for group_folder in sorted(groups_dir.iterdir()):
    with open(group_folder / "group_title.txt", "r", encoding="utf-8") as f:
        group_title = f.read()
    
    channel_modules[group_folder.stem] = {}
    
    # Find all .py files in that subfolder
    for channel_script in sorted((group_folder / "channels").glob("*.py")):
        module_name = channel_script.stem  # filename without .py
        
        spec = importlib.util.spec_from_file_location(module_name, channel_script)
        channel_module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(channel_module)
        
        m3u_content = m3u_content + f'\n\n#EXTINF:-1 tvg-logo="' + channel_module.channel_logo + '" group-title="' + group_title + '",' + channel_module.channel_name + "\n" + "http://" + local_ip + "/" + group_folder.stem + "/" + module_name
        
        channel_modules[group_folder.stem][module_name] = channel_module

server = ThreadingHTTPServer(("0.0.0.0", PORT), MyHandler)

print(f"Local:   http://localhost")
print(f"Network: http://{local_ip}")
print("Press Ctrl+C to stop.")

server.serve_forever()

#stream = streamlink.streams(m3u8)["best"].url