FROM python:latest

COPY ./app /app

RUN pip install -r /app/requirements.txt

EXPOSE 5000

ENTRYPOINT ["python","/app/app.py"]
