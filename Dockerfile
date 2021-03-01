FROM python:3.7-alpine
RUN mkdir /flask_app
WORKDIR /flask_app
ADD . /flask_app
RUN pip install -r requirements.txt
EXPOSE 8383
CMD ["python","web.py"]