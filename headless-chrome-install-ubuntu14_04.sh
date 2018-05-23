##################################################################
########### Debian and Ubuntu based Linux distributions
##################################################################

### for node 8
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs

### for node 10
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get install -y nodejs

### To compile and install native addons from npm you may also need to install build tools:
sudo apt-get install -y build-essential


##################################################################
########### Amazon AMI/Redhat CentOS
##################################################################

#Step 1: Add node.js yum repository
yum install -y gcc-c++ make
curl -sL https://rpm.nodesource.com/setup_8.x | sudo -E bash -

#Step 2: Install node.js and NPM
yum install nodejs

#Step 2: when complaining about the node version conflict with old version
rm -f /etc/yum.repos.d/nodesource-el.repo
yum clean all
yum -y remove nodejs
yum -y install nodejs

##################################################################
########### Finalize and testing
##################################################################

#Step 3: Upgrade/Verify versions

#the module n makes version-management easy:
#sudo npm install n -g
#sudo n 0.12.2

#For the latest stable version of node js
#sudo n stable
#For the latest version of node js
#sudo n latest

#Check the version
node -v 
npm -v 

#Step 4: Testing the installation
vim test_server.js

var http = require('http');
http.createServer(function (req, res) {
  res.writeHead(200, {'Content-Type': 'text/plain'});
  res.end('Welcome');
}).listen(3001, "127.0.0.1");
console.log('Server running at http://127.0.0.1:3001/');

node --debug test_server.js

################################################################
########### Puppeteer
################################################################

sudo npm install -g puppeteer --unsafe-perm=true
sudo npm i puppeteer --unsafe-perm=true

########################################################################
################## UBUNTU TROUBLE SHOOTING #################
########################################################################

### TOUBLESHOOT: [0509/163819.806050:ERROR:icu_util.cc(133)] Invalid file descriptor to ICU data received.

### The issue is permissions of the directories/files.
### When puppeteer was installed, the permissions were default owner of nobody:<usergroup> but not all files had group or others bits set (i.e. 600 or 700)
### Puppeteer was installed as npm install -g puppeteer and it is run as the local user.

### The fix was to chmod the files to set the group and others bits to match the "users".

### I left the ownership as what it was - nobody:<usergroup>

### 755 for directories
### 755 for executable files
### 644 for all other files
### I am unsure if the nobody:<usergroup> ownership is a bad situation.

cd /usr/local/lib/node_modules/puppeteer/.local-chromium
find . -type d | xargs -L1 -Ixx sudo chmod 755 xx
find . -type f -perm /u+x | xargs -L1 -Ixx sudo chmod 755 xx
find . -type f -not -perm /u+x | xargs -L1 -Ixx sudo chmod 644 xx

### install chinese characters (ubuntu)
sudo apt-get install fonts-wqy-zenhei
sudo apt-get install fonts-arphic-bkai00mp fonts-arphic-bsmi00lp fonts-arphic-gbsn00lp fonts-arphic-gkai00mp fonts-arphic-ukai fonts-arphic-uming fonts-cns11643-kai fonts-cns11643-sung fonts-cwtex-fs fonts-cwtex-heib fonts-cwtex-kai fonts-cwtex-ming fonts-cwtex-yen


################## DOCKER #####################

FROM node:8-slim

# See https://crbug.com/795759
RUN apt-get update && apt-get install -yq libgconf-2-4

# Install latest chrome dev package and fonts to support major charsets (Chinese, Japanese, Arabic, Hebrew, Thai and a few others)
# Note: this installs the necessary libs to make the bundled version of Chromium that Puppeteer
# installs, work.
RUN apt-get update && apt-get install -y wget --no-install-recommends \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-unstable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst ttf-freefont \
      --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get purge --auto-remove -y curl \
    && rm -rf /src/*.deb

# It's a good idea to use dumb-init to help prevent zombie chrome processes.
ADD https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64 /usr/local/bin/dumb-init
RUN chmod +x /usr/local/bin/dumb-init

# Uncomment to skip the chromium download when installing puppeteer. If you do,
# you'll need to launch puppeteer with:
#     browser.launch({executablePath: 'google-chrome-unstable'})
# ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true

# Install puppeteer so it's available in the container.
RUN npm i puppeteer

# Add user so we don't need --no-sandbox.
RUN groupadd -r pptruser && useradd -r -g pptruser -G audio,video pptruser \
    && mkdir -p /home/pptruser/Downloads \
    && chown -R pptruser:pptruser /home/pptruser \
    && chown -R pptruser:pptruser /node_modules

# Run everything after as non-privileged user.
USER pptruser

ENTRYPOINT ["dumb-init", "--"]
CMD ["google-chrome-unstable"]
