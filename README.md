Aria2, with integrated Aria2-WebUI and Aria2-NG Frontends
---

This is my fork of `XUJINKAI/aria2-with-webui`'s docker container, which is
excellent, but didn't fix my exact use case. For some reason it's quite hard to
find an somewhat up-to-date Aria2 build, let alone Aria2-WebUI or NG front-ends.

This container uses the latest Alpine linux build, along with the latest stable
Aria2 client (from Alpine's package repository) and bleeding-edge Aria2-WebUI or
latest release Aria2-NG front-end. In practice both are quite stable, so the
chances of a broken WebUI is minimal.

Builds for this container are triggered by `Alpine` container updates, so it
should remain up-to-date as newer Alpine/Aria2 versions become available.

## Tags:

`latest`: Same as `latest-webui`.

`latest-webui`: Latest Aria2 with the [Aria2-WebUI](https://github.com/timonier/webui-aria2) frontend

`latest-ng`: Latest Aria2 with the [Aria2-NG](https://github.com/mayswind/AriaNg) frontend

## Configuration:

The container supports being run both with a custom configuration, or without.
If you don't want to customize anything, use:

```
sudo docker run -d \
--name aria2-with-webui \
-p 6800:6800 \
-p 6880:80 \
-v /DOWNLOAD_DIR:/data \
-e SECRET=YOUR_SECRET_CODE \
-e PGID=100 \
-e PUID=1001 \
abcminiuser/docker-aria2-with-webui
```

Which will make the Aria2 client accessible over HTTP from port 6800, with the
WebUI being accessible from 6880. If you define `SECRET`, this token can be used
to communicate with the Aria2 daemon from a remote machine (if not set, the
WebUI should still work).

If you wish to use a custom configuration, map in a `/config` volume with your
custom `aria2.conf` configuration:

```
sudo docker run -d \
--name aria2-with-webui \
-p 6800:6800 \
-p 6880:80 \
-v /DOWNLOAD_DIR:/data \
-v /CONFIG_DIR:/conf \
-e PGID=100 \
-e PUID=1001 \
abcminiuser/docker-aria2-with-webui
```

Note that no authentication is used on the WebUI - if you need this, use a NGINX
reverse proxy to handle the authentication.

For an explanation of `PGID` and `PUID`, see the `User / Group Identifiers`
section below.

## Docker Compose

Example compose configuration:

```
  aria2:
    container_name: Aria2
    image: abcminiuser/docker-aria2-with-webui:latest
    network_mode: "bridge"
    ports:
      - 6800:6800
      - 6880:80
    volumes:
      - /volume1/Download/complete:/data
      - /volume1/docker/Aria2:/conf
    environment:
      - PGID=100
      - PUID=1001
    restart: unless-stopped
```

## User / Group Identifiers

**Note:** (This section stolen from [LinuxServer.io](http://linuxserver.io)'s
excellent container documentation.)

Sometimes when using data volumes (`-v` flags) permissions issues can arise
between the host OS and the container. We avoid this issue by allowing you to
specify the user PUID and group PGID. Ensure the data volume directory on the
host is owned by the same user you specify and it will "just work" TM.

In this instance `PUID=1001` and `PGID=1001`. To find yours use id user as below:

```
  $ id <dockeruser>
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
```

## Credits

As mentioned, this is a lightly modified version of the container by
`XUJINKAI/aria2-with-webui` - all credits to him.
