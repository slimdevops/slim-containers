FROM python:latest

# upgrade pip
RUN pip install --upgrade pip

# permissions and nonroot user for tightened security
RUN adduser nonroot
RUN mkdir /home/app/ && chown -R nonroot:nonroot /home/app
WORKDIR /home/app
USER nonroot

# copy and install requirements.txt
COPY --chown=nonroot:nonroot ./app/requirements.txt ./requirements.txt
RUN pip install -r requirements.txt

# copy app files
COPY --chown=nonroot:nonroot ./app .

# define the port number the container should expose
EXPOSE 5000

CMD ["python", "app.py"]