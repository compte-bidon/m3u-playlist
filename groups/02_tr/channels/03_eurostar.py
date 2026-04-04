import requests

channel_name = "EURO STAR"
channel_logo = "https://i.ibb.co/CbdPSX6/euro-star.png"

def get_m3u8():
    res = requests.get("https://www.eurostartv.com.tr/canli-izle")
    link_start = res.text.find("https://dygvideo.dygdigital.com/live/hls/staravrupa")
    link_end = res.text.find("'", link_start)
    live = res.text[link_start:link_end]
    m3u8 = requests.get(live, allow_redirects=False).headers["Location"]
    
    return m3u8