import requests

channel_name = "TMC"
channel_logo = "https://i.ibb.co/hKVyKj4/tmc.png"

def get_m3u8():
    return requests.get("https://tvradiozap.eu/tools/np-m3u8.php/tmc", allow_redirects=False).headers["Location"]