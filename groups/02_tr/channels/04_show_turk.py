import requests
import json

channel_name = "SHOW TÜRK"
channel_logo = "https://i.ibb.co/WvhGGP0/showturk1.png"

def get_m3u8():
    html = requests.get("https://www.showturk.com.tr/canli-yayin")
    data_start = html.text.find("data-hope-video")
    json_start = html.text.find("'{", data_start)
    json_end = html.text.find("}'", data_start)

    data = json.loads(html.text[json_start + 1:json_end + 1])
    m3u8 = data["media"]["m3u8"][0]["src"]
    
    return m3u8