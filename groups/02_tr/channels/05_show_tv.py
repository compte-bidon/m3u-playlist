import requests

channel_name = "SHOW TV"
channel_logo = "https://i.ibb.co/BrGNZJ4/showtv.png"

def get_m3u8():
    html = requests.get("https://www.showtv.com.tr/canli-yayin")
    url_start = html.text.find("https://ciner.daioncdn.net/showtv/showtv.m3u8")
    url_end = html.text.find('"', url_start)
    m3u8 = html.text[url_start:url_end]
    
    return m3u8