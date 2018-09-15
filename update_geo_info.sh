#!/usr/bin/env bash
redis-cli del tempgeo && \
 wget http://ipgeobase.ru/files/db/Main/geo_files.zip -qO temp.zip && \
 unzip -c temp.zip cidr_optim.txt | grep -Eiw 'RU|UA|BY' | awk '{print $1 " b|"$1"|"$2"|"$6 " " $2 " e|"$1"|"$2"|"$6}' | xargs -n 500 redis-cli zadd tempgeo && \
 redis-cli rename tempgeo geoinfo && \
 rm temp.zip