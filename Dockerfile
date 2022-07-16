FROM 412314/mltb:heroku

WORKDIR /usr/src/app
RUN chmod 777 /usr/src/app

RUN apt-get -y update && apt-get install -y wget 

RUN apt -qq install -y --no-install-recommends mediainfo

COPY . .
RUN pip3 install --no-cache-dir -r requirements.txt
CMD ["bash", "start.sh"]
