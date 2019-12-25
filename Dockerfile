FROM ubuntu:18.04

ADD . /home/Albireo

ENV DEBIAN_FRONTEND=noninteractive

RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak \
    && cp /home/Albireo/sources.list /etc/apt/sources.list \
    && apt-get update \
    && apt-get -y --force-yes install deluged deluge-webui postgresql postgresql-contrib python-pip postgresql-client python-dev libyaml-dev python-psycopg2 ffmpeg nodejs python-pil

RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/10/main/pg_hba.conf \
    && echo "listen_addresses='*'" >> /etc/postgresql/10/main/postgresql.conf \
    && usermod -a -G sudo postgres

USER postgres
RUN /etc/init.d/postgresql start && psql -U postgres -d postgres -c "alter user postgres with password '123456';" \
    && /etc/init.d/postgresql start && createdb -O postgres albireo

EXPOSE 5432

USER root
RUN useradd -p albireo -m albireo

WORKDIR /home/Albireo
#"Setting up deluge user..."
RUN mkdir /home/Albireo/.config
RUN mkdir /home/Albireo/.config/deluge
RUN touch /home/Albireo/.config/deluge/auth
RUN echo ":deluge:10" >> /home/Albireo/.config/deluge/auth

USER root
RUN pip install -r /home/Albireo/requirements.txt
RUN chmod -R 777 /home/Albireo

EXPOSE 5000

RUN locale-gen "en_US.UTF-8"
ENV LC_ALL en_US.UTF-8
RUN /etc/init.d/postgresql start && python /home/Albireo/tools.py --db-init && python /home/Albireo/tools.py --user-add admin 1234 && python tools.py --user-promote admin 3
VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

CMD ["bash", "-c", "/etc/init.d/postgresql start && python /home/Albireo/server.py"]
