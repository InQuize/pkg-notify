# **pkg-notify**

Simple `sh` script to notify via Pushover API about `pkg` update candidates in FreeBSD, etc

### Features:

- update version of `pkg`
- log output of `pkg upgrade -n` to a file and parse it for numbers
- upload the log file to [termbin.com](http://termbin.com) for temporary hosting (month if nothing changed)
- send notification to [Pushover](https://pushover.net) app using netcat including numbers and URL for the log file

### Requirements:

- `pkg`
- `curl`, `nc`, `dirname`
- [Pushover account](https://pushover.net/login)

---

### Installation example:

```
cd /root/ && \
git clone https://github.com/InQuize/pkg-notify.git
cp /root/pkg-notify/config.example /root/pkg-notify/config && \
chmod 0700 /root/pkg-notify/config
```

### Configuration:

>NOTE: **Do not** edit `pkg-notify.sh` for the sake of configuration. All 'user-servisable' variables are 
located in `config` file

- edit `config` file to fill in **your** Pushover _User Key_ and _App Token_:

>NOTE: these are the **only variables** that are **necessary**

```
TOKEN=uQiRzpo4DXghDmr9QzzfQu27cmVRsG
USER=azGDORePK8gMaC0QOYAMyEEuzJnyUi
```

- in case of `executable not found` issues revise:

```
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
```

- to customize log file name and path:

```
LOG="/tmp/pkg.log"
```

- to use message title other than machine's hostname just comment (`#`) the corresponding line and add yours:

```
#MSG_TITLE=$(hostname)
MSG_TITLE="your title in doube quotes"
```

- to customize link text of log paste use:

```
URL_TITLE="Your text in double quotes"
```

- execute to test: `sh /root/pkg-notify/pkg-notify.sh`

---

### Example cron job:

>NOTE: [Generate your own](http://crontab-generator.org/)

>NOTE: execute every day at 6:30 AM and redirect output (including errors) to a file in `/tmp/` overwrighting it contents

- `crontab -u root -e` :

```
30 6 * * * /bin/sh /root/pkg-notify/pkg-notify.sh > /tmp/pkg-notify.log 2>&1
```

---

### Screenshots:

>NOTE: 123 in message title is actually a system's hostname

<img src="https://raw.githubusercontent.com/InQuize/img/master/repos/pkg-notify/pushover-msg.png" width="425" /> <img src="https://raw.githubusercontent.com/InQuize/img/master/repos/pkg-notify/termbin-paste.png" width="425" />

### Example log file raw text:

```
Updating FreeBSD repository catalogue...
FreeBSD repository is up to date.
All repositories are up to date.
Checking for upgrades (25 candidates): .......... done
Processing candidates (25 candidates): .......... done
The following 27 package(s) will be affected (of 0 checked):

New packages to be INSTALLED:
	pcre: 8.40
	libnghttp2: 1.21.1

Installed packages to be UPGRADED:
	subversion: 1.9.3_3 -> 1.9.5
	sqlite3: 3.11.1 -> 3.18.0
	serf: 1.3.8_1 -> 1.3.9_1
	python27: 2.7.11_1 -> 2.7.13_1
	perl5: 5.20.3_8 -> 5.24.1_1
	p5-Socket: 2.021 -> 2.024
	p5-Net-SSLeay: 1.72 -> 1.81
	p5-Net-SMTP-SSL: 1.03 -> 1.04
	p5-IO-Socket-SSL: 2.024 -> 2.044
	p5-IO-Socket-IP: 0.37 -> 0.39
	indexinfo: 0.2.4 -> 0.2.6
	git: 2.7.4_1 -> 2.12.1
	gettext-runtime: 0.19.7 -> 0.19.8.1_1
	gdbm: 1.11_2 -> 1.12
	expat: 2.1.0_3 -> 2.2.0_1
	db5: 5.3.28_3 -> 5.3.28_6
	cvsps: 2.1_1 -> 2.1_2
	curl: 7.48.0_1 -> 7.53.1_1
	ca_root_nss: 3.22.2 -> 3.30.1
	apr: 1.5.2.1.5.4 -> 1.5.2.1.5.4_2

Installed packages to be REINSTALLED:
	p5-Mozilla-CA-20160104 (direct dependency changed: perl5)
	p5-GSSAPI-0.28_1 (direct dependency changed: perl5)
	p5-Error-0.17024 (direct dependency changed: perl5)
	p5-Digest-HMAC-1.03_1 (direct dependency changed: perl5)
	p5-Authen-SASL-2.16_1 (direct dependency changed: perl5)

Number of packages to be installed: 2
Number of packages to be upgraded: 20
Number of packages to be reinstalled: 5

The process will require 11 MiB more space.
33 MiB to be downloaded.
```
