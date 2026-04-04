channel_name = "TV8"
channel_logo = "https://i.ibb.co/6ZZLDQp/tv8.png"

import requests

body = """------geckoformboundary4690c00fa8ee5e5789c9cfede46cbc
Content-Disposition: form-data; name="remember_me"

0
------geckoformboundary4690c00fa8ee5e5789c9cfede46cbc
Content-Disposition: form-data; name="mail"

email@domain.com
------geckoformboundary4690c00fa8ee5e5789c9cfede46cbc
Content-Disposition: form-data; name="pass"

myPasswordhere
------geckoformboundary4690c00fa8ee5e5789c9cfede46cbc--
"""

"""session = requests.Session()

login_page = session.get("https://tv.vin/login/alternative")
login_url_start = login_page.text.find("https://tv.vin/ajax/account/login?tkn=")
login_url_end = login_page.text.find('"', login_url_start)
login_url = login_page.text[login_url_start:login_url_end]

res = session.post(login_url, headers={'Content-Type': 'multipart/form-data; boundary=----geckoformboundary4690c00fa8ee5e5789c9cfede46cbc'}, data=body)

print(res.status_code)
print(res.headers)
print(res.text)

files = {
    "mail": "email@domain.com",
    "pass": "myPasswordhere",
    "remember_me": "0"
}
print()
print()
print(requests.Request('POST', login_url, files=files).prepare().headers)
print(requests.Request('POST', login_url, files=files).prepare().body.decode('utf8'))
print()
print()
login = session.post(login_url, files=files)

print(login.status_code)
print(login.headers)
print(login.text)

variable = session.get("https://geo.alfastreamtv.com/?channel=tv8")
token_start = variable.text.find('"') + 1
token_end = variable.text.find('"', token_start)
token = variable.text[token_start:token_end]

html = session.get("https://tv.vin/play/tv8/1?tkslast=" + token)
print(html.headers)
print(html.text)
m3u8_start = html.text.find("https://cdn507.tv.vin/tv8.m3u8")
m3u8_end = html.text.find("'", m3u8_start)
m3u8 = html.text[m3u8_start:m3u8_end]

print(m3u8)"""

def get_m3u8():
    return "https://rkhubpaomb.turknet.ercdn.net/fwjkgpasof/tv8/tv8.m3u8"