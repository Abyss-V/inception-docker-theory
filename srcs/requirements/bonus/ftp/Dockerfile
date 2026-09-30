FROM debian:bookworm


RUN apt-get update -y && apt-get install vsftpd -y &&  mkdir -p /run/vsftpd/empty
COPY conf/vsftpd.conf /etc/vsftpd.conf
COPY tools/init.sh /usr/local/bin/init.sh
CMD ["sh","/usr/local/bin/init.sh"]