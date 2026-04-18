import requests

channel_name = "TMC"
channel_logo = "https://i.ibb.co/hKVyKj4/tmc.png"

def get_m3u8():
    full_m3u = requests.get("https://tvradiozap.eu//live/x/vlc/d/tvzeu.m3u").text
    channel_start = full_m3u.find('tvg-name="TMC"')
    channel_url_start = full_m3u.find("\n", channel_start) + 1
    channel_url_end = full_m3u.find("\n", channel_url_start)
    stream = full_m3u[channel_url_start:channel_url_end]
    m3u8 = requests.get(stream, allow_redirects=False).headers["Location"]

    return m3u8