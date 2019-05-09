FROM python:3.7-alpine
LABEL maintainer="howie_howerton@trendmicro.com"
RUN apt-get update -y
RUN apt upgrade -y
RUN apt-get install -y python-pip python-dev build-essential
ADD . /flask-app
WORKDIR /flask-app
RUN pip install -r requirements.txt
ENTRYPOINT ["python"]
CMD ["flask-docker.py"]
