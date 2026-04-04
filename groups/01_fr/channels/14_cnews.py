import requests

channel_name = "CNEWS"
channel_logo = "https://i.ibb.co/qY6w8ds/cnews.png"

def get_m3u8():
    html = requests.get("https://www.cnews.fr/le-direct")
    video_id_attr = 'data-videoid="'
    video_id_attr_start = html.text.find(video_id_attr)
    video_id_start = video_id_attr_start + len(video_id_attr)
    video_id_end = html.text.find('"', video_id_start)
    video_id =  html.text[video_id_start:video_id_end]
    
    return requests.get("https://geo.dailymotion.com/video/" + video_id + ".json?legacy=true").json()["qualities"]["auto"][0]["url"]