FROM ubuntu:latest
LABEL maintainer="howie_howerton@trendmicro.com"
RUN apt-get update -y
RUN apt upgrade
RUN apt-get install -y python-pip python-dev build-essential
ADD . /flask-app
WORKDIR /flask-app
RUN pip install -r requirements.txt
ENTRYPOINT ["python"]
CMD ["flask-docker.py"]
