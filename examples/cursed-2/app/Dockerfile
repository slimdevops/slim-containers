FROM python:3.9.7

WORKDIR /app
COPY . .
RUN pip install -r requirements.txt
ENV EVIL="True" 

EXPOSE 5001
ENTRYPOINT ["python", "app.py"]
