# LibreTranslate Helm Chart

## Known Issues

### It takes very long for the webserver to become available

The LibreTranslate webserver will only become available after downloading the languages. This can take up to 10 minutes. Maybe even more with a slow connection

### Persistance Not Included

There's no perstistance included. That's why LibreOffice needs to download the language files every time.
I'm planning to include this in the future. Feel free to contribute.