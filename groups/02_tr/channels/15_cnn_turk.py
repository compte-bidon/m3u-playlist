import requests

channel_name = "CNN TÜRK"
channel_logo = "https://i.ibb.co/JqWCczW/cnnturk1.png"

def get_m3u8():
    html = requests.get("https://www.cnnturk.com/canli-yayin")
    content_id_field_string = '"cnn_contentid": "'
    content_id_field_start = html.text.find(content_id_field_string)
    content_id_start = content_id_field_start + len(content_id_field_string)
    content_id_end = html.text.find('"', content_id_start)
    content_id = html.text[content_id_start:content_id_end]
    
    res = requests.get("https://www.cnnturk.com/api/cnnvideo/media?id=" + content_id + "&isMobile=false").json()
    m3u8 = res["Media"]["Link"]["DefaultServiceUrl"] + res["Media"]["Link"]["SecurePath"]
    
    return m3u8