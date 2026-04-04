import requests

channel_name = "KANAL 7"
channel_logo = "https://i.ibb.co/1s3fHfm/k7tr1.png"

def get_m3u8():
    php = requests.get("https://www.kanal7.com/canli-yayin-iframe.php")
    url_start = php.text.find("https://kanal7.daioncdn.net/kanal7/kanal7.m3u8")
    url_end = php.text.find("'", url_start)
    m3u8 = php.text[url_start:url_end]
    
    return m3u8