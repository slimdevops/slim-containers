FROM python:3.9.7

WORKDIR /app
COPY --chown=www-data . .
RUN pip install -r requirements.txt

USER www-data
EXPOSE 5000
ENTRYPOINT ["python", "app.py"]
