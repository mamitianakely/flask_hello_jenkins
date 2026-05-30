FROM localhost:4000/python:3.11

WORKDIR /home/flask
ADD . .
RUN pip install -r requirements.txt
RUN chmod a+x app.py test.py

ENV FLASK_APP=app.py
EXPOSE 5000

CMD ["python", "app.py"]