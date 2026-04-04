import requests

channel_name = "FRANCE 2"
channel_logo = "https://i.ibb.co/GxWtcTm/fr2bl.png"

def get_m3u8():
    html = requests.get("https://www.france.tv/france-2/direct.html")
    video_json_start_string = '{\\"options\\":{\\"id\\":\\"'
    json_start = html.text.find(video_json_start_string)
    id_start = json_start + len(video_json_start_string)
    id_end = html.text.find('\\"', id_start)
    video_id = html.text[id_start:id_end]

    video_data = requests.get("https://k7.ftven.fr/videos/" + video_id + "?domain=www.france.tv&browser=chrome").json()["video"]
    akaimai_url = video_data["token"]["akamai"]
    url = video_data["url"]
    m3u8 = requests.get(akaimai_url + "&url=" + url).json()["url"]
    
    return m3u8