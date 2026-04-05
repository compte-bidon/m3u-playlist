import requests

channel_name = "HABER TÜRK"
channel_logo = "https://i.ibb.co/wdwm0fn/haberturk.png"

def get_m3u8():
    html = requests.get("https://www.haberturk.com/canliyayin")
    url_start = html.text.find("https://ciner.daioncdn.net/haberturktv/haberturktv.m3u8")
    url_end = html.text.find('"', url_start)
    m3u8 = html.text[url_start:url_end]
    
    return m3u8