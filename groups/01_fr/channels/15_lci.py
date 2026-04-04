import requests

channel_name = "LCI"
channel_logo = "https://i.ibb.co/Zfcrrr1/lci.png"

def get_m3u8():
    return requests.get("https://tvradiozap.eu/tools/np-m3u8.php/lci", allow_redirects=False).headers["Location"]