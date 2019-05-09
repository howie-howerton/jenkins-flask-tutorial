FROM python:3.7-alpine
LABEL maintainer="howie_howerton@trendmicro.com"

ADD . /flask-app
WORKDIR /flask-app
RUN pip install -r requirements.txt
ENTRYPOINT ["python"]
CMD ["flask-docker.py"]
