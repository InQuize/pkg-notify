# **pkg-notify**

### Features:
- update version of `pkg`
- log output of `pkg upgrade -n` to a file and parse it for numbers
- upload the log file to [termbin.com](http://termbin.com) for temporary hosting (month if nothing changed)
- send notification using [Pushover](https://pushover.net) including numbers and URL for the log file

---
### Message example:

>NOTE: 123 in message title is actually a system's hostname

![Message in Pushover Android app](https://github.com/InQuize/img/raw/master/repos/pkg-notify/pushover-msg.png)

### Log file preview example:

![log file opened in Chrome](https://github.com/InQuize/img/raw/master/repos/pkg-notify/termbin-paste.png)

### Log file raw example:

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
