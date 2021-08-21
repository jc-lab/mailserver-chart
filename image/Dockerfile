FROM alpine:3.13

RUN adduser -D -g vmail -u 11000 vmail && \
    mkdir -p /mail-storage && \
    chown vmail:vmail -R /mail-storage && \
    mkdir -p /secret

RUN apk add \
    ca-certificates bash procps mariadb-client \
    postfix postfix-mysql postfix-pcre postfix-ldap \
    dovecot dovecot-sql dovecot-pop3d dovecot-mysql dovecot-lmtpd dovecot-ldap \
    opendkim opendkim-utils \
    libsasl cyrus-sasl-ntlm cyrus-sasl-gssapiv2 \
    inotify-tools

ADD [ "opt", "/opt/" ]
RUN chmod +x /opt/*/*.sh

