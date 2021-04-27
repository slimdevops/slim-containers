FROM python:latest

COPY ./app /app

RUN pip install -r /app/requirements.txt

EXPOSE 1300

ENTRYPOINT ["python","/app/app.py"]
