import py_mini_racer
import requests

channel_name = "TRT BELGESEL"
channel_logo = "https://i.ibb.co/N1h8m96/trtbelgesel.png"

def get_m3u8():
    #return "https://tv-trtbelgesel-dai.medya.trt.com.tr/master.m3u8" # doesn't work in this moment

    channel_html = requests.get("https://www.canlitv.me/live/trtbelgesel-canli-izle").text
    referrer_start = channel_html.find("https://www.canlitv.me/geolive.php?kanal=trtbelgesel-canli-izle")
    referrer_end = channel_html.find('"', referrer_start)

    referrer = channel_html[referrer_start:referrer_end]
    
    token_code = requests.get("https://geo.alfastreamtv.com/?channel=trtbelgesel-canli-izle").text
    token_name_end = token_code.find('=') - 1
    token_start = token_code.find('"') + 1
    token_end = token_code.find('"', token_start)
    
    token_name = token_code[:token_name_end]
    token_value = token_code[token_start:token_end]

    country_code = requests.get("https://www.canlitv.me/geo").text
    country_name_end = country_code.find('=') - 1
    country_start = country_code.find('"') + 1
    country_end = country_code.find('"', country_start)
    
    country_name = country_code[:country_name_end]
    country_value = country_code[country_start:country_end]

    m3u_html = requests.get(
        "https://www.canlitv.me/yayin.php?kanal=trtbelgesel-canli-izle&" + country_name + "=" + country_value + "&" + token_name + "=" + token_value,
        headers={
            "Referer": referrer,
        }
    ).text
    script_start = m3u_html.find("const playersetup")
    script_end = m3u_html.find("const playerInstance", script_start)

    script = m3u_html[script_start:script_end]

    ctx = py_mini_racer.MiniRacer()
    player_setup = ctx.eval(script + "\nplayersetup")

    return player_setup["file"]