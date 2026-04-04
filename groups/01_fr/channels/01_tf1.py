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
    return requests.get("https://tvradiozap.eu/tools/np-m3u8.php/tf1hd", allow_redirects=False).headers["Location"]