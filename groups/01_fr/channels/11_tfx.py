import requests

channel_name = "TFX"
channel_logo = "https://i.ibb.co/4VS27Jw/tfx.png"

def get_m3u8():
    return requests.get("https://tvradiozap.eu/tools/np-m3u8.php/nt1", allow_redirects=False).headers["Location"]