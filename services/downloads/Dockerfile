FROM ubuntu:24.04
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y python3 cron
COPY crontab.cron /etc/cron.d/jetzig.cron
COPY get_releases.py /usr/local/lib/
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["sleep", "infinity"]
