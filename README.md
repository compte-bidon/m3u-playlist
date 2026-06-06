# m3u-playlist

## Setup credentials

sudo tee /etc/m3u-playlist.env > /dev/null <<EOF
TF1EMAIL=my_email_address
TF1PASSWORD=my_password
EOF

## Install the web server

curl -fsSL https://raw.githubusercontent.com/compte-bidon/m3u-playlist/main/install.sh | bash