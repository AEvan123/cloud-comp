#!/bin/bash

# ==============================================================================
# Cloud-init pour la vm web
# Ce script fait les actions suivante :
    # Mise à jours du système
    # installation de nginx
    # installation de nextcloud
    # extraction du certificat
    # mise en forme de fichier de configuration de nginx avec nextcloud
# ==============================================================================

apt-get update -y
apt-get upgrade -y
apt install -y php8.1-fpm php8.1-xml php8.1-zip php8.1-mbstring php8.1-gd php8.1-curl php8.1-intl php8.1-bcmath php8.1-gmp php8.1-mysql php-imagick php8.1-apcu php8.1-redis
apt-get install openssl zip unzip -y
apt install -y mariadb-server -y
apt install nginx -y

nginx -t && systemctl reload nginx

mkdir -p /var/www/nextcloud
chown www-data:www-data /var/www/nextcloud
cd /tmp


wget "https://download.nextcloud.com/server/releases/latest.zip"
unzip "latest.zip"
mv nextcloud/* /var/www/nextcloud/
rm -rf nextcloud/
chown -R www-data:www-data /var/www/nextcloud/

curl -sL https://aka.ms/InstallAzureCLIDeb | bash

export PATH=$PATH:/usr/local/bin

az login --identity

PFX_DATA=$(az keyvault secret show --name ${KV_NAME} --vault-name ${V_NAME} --query "value" -o tsv)
echo "$PFX_DATA" | base64 --decode > certificate.pfx
openssl pkcs12 -in certificate.pfx -clcerts -nokeys -out /etc/ssl/certs/nginx-nextcloud.pem -passin pass:
openssl pkcs12 -in certificate.pfx -nocerts -out /etc/ssl/private/nginx-nextcloud.key -passin pass: -passout pass:

cp /etc/ssl/private/nginx-nextcloud.key /etc/ssl/private/nginx-nextcloud.key.bak.$(date +%s)

openssl pkey -in /etc/ssl/private/nginx-nextcloud.key \
  -out /etc/ssl/private/nginx-nextcloud.key.unencrypted \
  -passin pass:

mv /etc/ssl/private/nginx-nextcloud.key.unencrypted /etc/ssl/private/nginx-nextcloud.key
chmod 600 /etc/ssl/private/nginx-nextcloud.key
chown root:root /etc/ssl/private/nginx-nextcloud.key

cat > /etc/nginx/sites-available/${NEXTCLOUD_FQDN} <<EOL
upstream php-handler {
    #server 127.0.0.1:9000;
    server unix:/var/run/php/php8.1-fpm.sock;
}

server {
    listen 80;
    listen [::]:80;
    server_name ${NEXTCLOUD_FQDN};

    # Enforce HTTPS just for `/nextcloud`
    location /nextcloud {
        return 301 https://\$server_name\$request_uri;
    }
}

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name ${NEXTCLOUD_FQDN};

    # Use Mozilla's guidelines for SSL/TLS settings
    # https://mozilla.github.io/server-side-tls/ssl-config-generator/
    ssl_certificate     /etc/ssl/certs/nginx-nextcloud.pem;
    ssl_certificate_key /etc/ssl/private/nginx-nextcloud.key;

    # HSTS settings
    # WARNING: Only add the preload option once you read about
    # the consequences in https://hstspreload.org/. This option
    # will add the domain to a hardcoded list that is shipped
    # in all major browsers and getting removed from this list
    # could take several months.
    #add_header Strict-Transport-Security "max-age=15768000; includeSubDomains; preload;" always;

    # Path to the root of the domain
    root /var/www;

    location = / { return 301 /nextcloud/; }

    location = /robots.txt {
        allow all;
        log_not_found off;
        access_log off;
    }

    location /.well-known {
        # The following 6 rules are borrowed from `.htaccess`

        rewrite ^/\.well-known/host-meta\.json  /nextcloud/public.php?service=host-meta-json    last;
        rewrite ^/\.well-known/host-meta        /nextcloud/public.php?service=host-meta         last;
        rewrite ^/\.well-known/webfinger        /nextcloud/public.php?service=webfinger         last;
        rewrite ^/\.well-known/nodeinfo         /nextcloud/public.php?service=nodeinfo          last;

        location = /.well-known/carddav   { return 301 /nextcloud/remote.php/dav/; }
        location = /.well-known/caldav    { return 301 /nextcloud/remote.php/dav/; }

        try_files \$uri \$uri/ =404;
    }

    location ^~ /nextcloud {
        # set max upload size
        client_max_body_size 512M;
        fastcgi_buffers 64 4K;

        # Enable gzip but do not remove ETag headers
        gzip on;
        gzip_vary on;
        gzip_comp_level 4;
        gzip_min_length 256;
        gzip_proxied expired no-cache no-store private no_last_modified no_etag auth;
        gzip_types application/atom+xml application/javascript application/json application/ld+json application/manifest+json application/rss+xml application/vnd.geo+json application/vnd.ms-fontobject application/x-font-ttf application/x-web-app-manifest+json application/xhtml+xml application/xml font/opentype image/bmp image/svg+xml image/x-icon text/cache-manifest text/css text/plain text/vcard text/vnd.rim.location.xloc text/vtt text/x-component text/x-cross-domain-policy;

        # Pagespeed is not supported by Nextcloud, so if your server is built
        # with the `ngx_pagespeed` module, uncomment this line to disable it.
        #pagespeed off;

        # HTTP response headers borrowed from Nextcloud `.htaccess`
        add_header Referrer-Policy                      "no-referrer"   always;
        add_header X-Content-Type-Options               "nosniff"       always;
        add_header X-Download-Options                   "noopen"        always;
        add_header X-Frame-Options                      "SAMEORIGIN"    always;
        add_header X-Permitted-Cross-Domain-Policies    "none"          always;
        add_header X-Robots-Tag                         "none"          always;
        add_header X-XSS-Protection                     "1; mode=block" always;

        # Remove X-Powered-By, which is an information leak
        fastcgi_hide_header X-Powered-By;

        # Specify how to handle directories -- specifying `/nextcloud/index.php\$request_uri`
        # here as the fallback means that Nginx always exhibits the desired behaviour
        # when a client requests a path that corresponds to a directory that exists
        # on the server. In particular, if that directory contains an index.php file,
        # that file is correctly served; if it doesn't, then the request is passed to
        # the front-end controller. This consistent behaviour means that we don't need
        # to specify custom rules for certain paths (e.g. images and other assets,
        # `/updater`, `/ocm-provider`, `/ocs-provider`), and thus
        # `try_files \$uri \$uri/ /nextcloud/index.php\$request_uri`
        # always provides the desired behaviour.
        index index.php index.html /nextcloud/index.php\$request_uri;

        # Rule borrowed from `.htaccess` to handle Microsoft DAV clients
        location = /nextcloud {
            if ( \$http_user_agent ~ ^DavClnt ) {
                return 302 /nextcloud/remote.php/webdav/\$is_args\$args;
            }
        }

        # Rules borrowed from `.htaccess` to hide certain paths from clients
        location ~ ^/nextcloud/(?:build|tests|config|lib|3rdparty|templates|data)(?:$|/)    { return 404; }
        location ~ ^/nextcloud/(?:\.|autotest|occ|issue|indie|db_|console)                { return 404; }

        # Ensure this block, which passes PHP files to the PHP process, is above the blocks
        # which handle static assets (as seen below). If this block is not declared first,
        # then Nginx will encounter an infinite rewriting loop when it prepends
        # `/nextcloud/index.php` to the URI, resulting in a HTTP 500 error response.
        location ~ \.php(?:$|/) {
            # Required for legacy support
            rewrite ^/nextcloud/(?!index|remote|public|cron|core\/ajax\/update|status|ocs\/v[12]|updater\/.+|oc[ms]-provider\/.+|.+\/richdocumentscode\/proxy) /nextcloud/index.php\$request_uri;

            fastcgi_split_path_info ^(.+?\.php)(/.*)$;
            set \$path_info \$fastcgi_path_info;

            try_files \$fastcgi_script_name =404;

            include fastcgi_params;
            fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
            fastcgi_param PATH_INFO \$path_info;
            fastcgi_param HTTPS on;

            fastcgi_param modHeadersAvailable true;         # Avoid sending the security headers twice
            fastcgi_param front_controller_active true;     # Enable pretty urls
            fastcgi_pass php-handler;

            fastcgi_intercept_errors on;
            fastcgi_request_buffering off;
        }

        location ~ \.(?:css|js|svg|gif)$ {
            try_files \$uri /nextcloud/index.php\$request_uri;
            expires 6M;         # Cache-Control policy borrowed from `.htaccess`
            access_log off;     # Optional: Don't log access to assets
        }

        location ~ \.woff2?$ {
            try_files \$uri /nextcloud/index.php\$request_uri;
            expires 7d;         # Cache-Control policy borrowed from `.htaccess`
            access_log off;     # Optional: Don't log access to assets
        }

        location /nextcloud {
            try_files \$uri \$uri/ /nextcloud/index.php\$request_uri;
        }
    }
}
EOL

ln -s /etc/nginx/sites-available/${NEXTCLOUD_FQDN} /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default
rm -rf /etc/nginx/sites-available/default

nginx -t && systemctl reload nginx

echo "*/5 * * * * -u www-data php /var/www/nextcloud/cron.php" | crontab -