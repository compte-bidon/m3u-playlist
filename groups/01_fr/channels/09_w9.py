import requests

channel_name = "W9"
channel_logo = "https://i.ibb.co/LNRd253/w9.png"

def get_m3u8():
    return requests.get("https://tvradiozap.eu/tools/np-m3u8.php/w9", allow_redirects=False).headers["Location"]