FROM centos:centos7.9.2009 as CACHER

RUN yum install -y createrepo

COPY reposync.conf /reposync.conf

RUN repotrack -c /reposync.conf -a x86_64 -p /reposync/ -n kernel-headers kernel-devel kernel-core gcc elfutils-libelf elfutils-libelf-devel
RUN repotrack -c /reposync.conf -a x86_64 -p /reposync/ -n --repoid=kernel kernel

RUN createrepo /reposync/


FROM alpine:3.17

COPY --from=CACHER /reposync /reposync
RUN apk add --no-cache miniserve
WORKDIR /reposync

EXPOSE 80

ENTRYPOINT [ "/usr/local/bin/miniserve", "--dirs-first", "-p", "80", "--hide-theme-selector", "." ]
