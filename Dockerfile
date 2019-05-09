FROM python:3.7-alpine
LABEL maintainer="howie_howerton@trendmicro.com"

ADD . /flask-app
WORKDIR /flask-app
RUN pip install -r requirements.txt
#RUN echo 'X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*' > eicar.txt
ENTRYPOINT ["python"]
CMD ["flask-docker.py"]
