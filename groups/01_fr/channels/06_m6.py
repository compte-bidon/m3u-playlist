import requests

channel_name = "M6"
channel_logo = "https://i.ibb.co/wgJTdGY/m6.png"

def get_m3u8():
    return requests.get("https://tvradiozap.eu/tools/np-m3u8.php/m6hd", allow_redirects=False).headers["Location"]