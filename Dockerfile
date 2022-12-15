FROM centos:centos7.9.2009

RUN yum install -y createrepo
RUN curl -sL "https://caddyserver.com/api/download?os=linux&arch=amd64" -o /usr/local/bin/caddy

COPY reposync.conf /reposync.conf

RUN reposync -c /reposync.conf -g -l -d -m -a x86_64 --download-metadata -p /reposync/ --repoid=base
RUN reposync -c /reposync.conf -g -l -d -m -a x86_64 --download-metadata -p /reposync/ --repoid=updates

RUN createrepo /reposync/

RUN curl -sL "https://github.com/svenstaro/miniserve/releases/download/v0.22.0/miniserve-0.22.0-x86_64-unknown-linux-musl" -o /usr/local/bin/miniserve && \
    chmod +x /usr/local/bin/miniserve

WORKDIR /reposync

EXPOSE 80

ENTRYPOINT [ "/usr/local/bin/miniserve", "--dirs-first", "-p", "80", "--hide-theme-selector", "." ]
