import requests
import yt_dlp

channel_name = "SÖZCÜ TV"
channel_logo = "https://i.ibb.co/6NX1j0n/szc-tv.png"

def get_m3u8():
    html = requests.get("https://www.szctv.com.tr/canli-yayin-izle")
    url_start = html.text.find("https://www.youtube.com/embed/")
    url_end = html.text.find('"', url_start)
    embed_url = html.text[url_start:url_end]

    ydl_opts = {
        "format": "best[protocol=m3u8_native]/best",
        "quiet": True,
    }
    with yt_dlp.YoutubeDL(ydl_opts) as ydl:
        info = ydl.extract_info(embed_url, download=False)
        return info["url"]