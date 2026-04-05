import requests

channel_name = "NOW"
channel_logo = "https://i.ibb.co/0DpKtzT/nowtvturk.png"

def get_m3u8():
    html = requests.get("https://www.nowtv.com.tr/canli-yayin")
    url_start = html.text.find("https://nowtv-live-ad.ercdn.net/nowtv/playlist.m3u8")
    url_end = html.text.find("'", url_start)
    m3u8 = html.text[url_start:url_end]
    
    return m3u8