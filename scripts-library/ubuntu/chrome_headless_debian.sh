# coder-code-server
# auchenberg.vscode-browser-preview
# export CHROME_BIN=/usr/bin/google-chrome
# export DISPLAY=:99.0
apt-get update

apt-get install -y wget fonts-liberation libatk-bridge2.0-0 libatk1.0-0 libatspi2.0-0 libcairo2 libcups2 libgbm1 libgdk-pixbuf2.0-0 libgtk-3-0 libnspr4 libnss3 libpango-1.0-0 libxcomposite1 libxdamage1 libxfixes3 libxkbcommon0 libxrandr2 libxshmfence1 xdg-utils

apt --fix-broken install

wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

dpkg -i google-chrome-stable_current_amd64.deb

rm -f google-chrome-stable_current_amd64.deb

apt-get remove -y wget

# start chrome
/opt/google/chrome/chrome --no-sandbox &

# install plugin
# broswer preview
