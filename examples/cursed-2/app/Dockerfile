FROM python:3.9.7

WORKDIR /app
COPY --chown=dracula . .
RUN pip install -r requirements.txt
ENV EVIL=True 

USER dracula
EXPOSE 5000
ENTRYPOINT ["python", "app.py"]
