import requests

channel_name = "TF1"
channel_logo = "https://i.ibb.co/BBpR1Wx/tf1.png"

"""def get_m3u8():
    from streamlink import Streamlink
    from streamlink.options import Options

    import env

    options = Options({
        "email": env.tf1_email,
        "password": env.tf1_password,
        "purge-credentials": True
    })

    session = Streamlink()
    stream = session.streams("https://www.tf1.fr/tf1/direct", options)["best"].url
    
    return stream"""

def get_m3u8():
    full_m3u = requests.get("https://tvradiozap.eu//live/x/vlc/d/tvzeu.m3u").text
    channel_start = full_m3u.find('tvg-name="TF1"')
    channel_url_start = full_m3u.find("\n", channel_start) + 1
    channel_url_end = full_m3u.find("\n", channel_url_start)
    stream = full_m3u[channel_url_start:channel_url_end]
    m3u8 = requests.get(stream, allow_redirects=False).headers["Location"]

    return m3u8