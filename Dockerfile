FROM alpine:latest
RUN apk update
RUN apk upgrade
RUN apk add bash jq uuidgen
ADD /check /opt/resource/check
ADD /out /opt/resource/out
ADD /in /opt/resource/in
RUN chmod +x /opt/resource/*
