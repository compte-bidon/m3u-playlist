import requests

channel_name = "GULLI"
channel_logo = "https://i.ibb.co/LQXjFc3/gulli.png"

def get_m3u8():
    return requests.get("https://tvradiozap.eu/tools/np-m3u8.php/gulli", allow_redirects=False).headers["Location"]