### HTTP updater
* Install the package `lighttpd`
* The file organization of the `/var/www/html` directory must be:
```
- directory1 (e.g., linux)
|
-- directory2 (e.g., ubuntu)
|
--- files (e.g., ubuntu-18.04.3-desktop-amd64.iso)
```
* Update the links of the HTTP server by running the script as root after
uploading your files to `/var/www/html`
```
bash update-download-links.sh
```
