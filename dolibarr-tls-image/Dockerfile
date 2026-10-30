FROM dolibarr/dolibarr:24.0.2-php8.5

RUN set -eu; \
    file=/var/www/html/core/db/mysqli.class.php; \
    test -r /etc/ssl/certs/ca-certificates.crt; \
    grep -Fq 'parent::options(MYSQLI_OPT_SSL_VERIFY_SERVER_CERT, 0);' "$file"; \
    grep -Fq 'parent::ssl_set(null, null, "", null, null);' "$file"; \
    sed -i 's/parent::options(MYSQLI_OPT_SSL_VERIFY_SERVER_CERT, 0);/parent::options(MYSQLI_OPT_SSL_VERIFY_SERVER_CERT, 1);/' "$file"; \
    sed -i 's@parent::ssl_set(null, null, "", null, null);@parent::ssl_set(null, null, "/etc/ssl/certs/ca-certificates.crt", null, null);@' "$file"; \
    grep -Fq 'parent::options(MYSQLI_OPT_SSL_VERIFY_SERVER_CERT, 1);' "$file"; \
    grep -Fq 'parent::ssl_set(null, null, "/etc/ssl/certs/ca-certificates.crt", null, null);' "$file"; \
    php -l "$file"
