import requests
#import time
#import math

channel_name = "ATV"
channel_logo = "https://i.ibb.co/n1SCYqN/atv.png"

def get_m3u8():
    headers = {
        "Referer": "https://www.atv.com.tr/", # Must put this header to work
        #"X-Rand": str(math.floor(time.time()*1000)), # the code in the website puts this header, but it doesn't change the result from my expriments so I am ignoring
        #"X-isApp": "false" # the code in the website puts this header, but it doesn't change the result from my expriments so I am ignoring
    }
    
    return requests.get("https://securevideotoken.tmgrup.com.tr/webtv/secure?123456&url=https%3A%2F%2Ftrkvz-live.ercdn.net%2Fatvavrupa%2Fatvavrupa.m3u8&url2=https%3A%2F%2Ftrkvz-live.ercdn.net%2Fatvavrupa%2Fatvavrupa.m3u8", headers=headers).json()["Url"]