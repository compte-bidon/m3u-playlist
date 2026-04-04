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
        "noplaylist": True,
        "extractor_args": {
            "youtube": {
                "skip": [
                    "dash",
                    "translated_subs"
                ],
                "player_skip": [
                    "configs",
                    #"webpage", # if we skip this, we get an error saying "The page needs to be reloaded."
                    "js",
                    "initial_data"
                ],
                "webpage_skip": [
                    "player_response",
                    "initial_data"
                ],
            }
        },
        "quiet": True,
    }
    with yt_dlp.YoutubeDL(ydl_opts) as ydl:
        info = ydl.extract_info(embed_url, download=False)
        return info["url"]