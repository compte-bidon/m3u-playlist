import os

channel_name = "TF1"
channel_logo = "https://i.ibb.co/BBpR1Wx/tf1.png"

def get_m3u8():
    from streamlink import Streamlink
    from streamlink.options import Options

    options = Options({
        "email": os.environ.get("TF1EMAIL"),
        "password": os.environ.get("TF1PASSWORD"),
        "purge-credentials": True
    })

    session = Streamlink()
    stream = session.streams("https://www.tf1.fr/tf1/direct", options)["best"]
    m3u8 = stream.to_manifest_url()
    
    return m3u8