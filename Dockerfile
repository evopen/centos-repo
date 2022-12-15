FROM centos:centos7.9.2009

RUN yum install -y createrepo

COPY reposync.conf /reposync.conf

RUN repotrack -c /reposync.conf -a x86_64 -p /reposync/ -n kernel-headers kernel-devel kernel-core gcc elfutils-libelf elfutils-libelf-devel

RUN createrepo /reposync/

RUN curl -sL "https://github.com/svenstaro/miniserve/releases/download/v0.22.0/miniserve-0.22.0-x86_64-unknown-linux-musl" -o /usr/local/bin/miniserve && \
    chmod +x /usr/local/bin/miniserve

WORKDIR /reposync

EXPOSE 80

ENTRYPOINT [ "/usr/local/bin/miniserve", "--dirs-first", "-p", "80", "--hide-theme-selector", "." ]

