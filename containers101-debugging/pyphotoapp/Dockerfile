FROM python:slim

WORKDIR /app

COPY . . 

RUN python test.py 

RUN pip install -r requirements.txt


EXPOSE 5000 

ENTRYPOINT [ "python", "jinx.py" ]
# ENTRYPOINT [ "python"]

# RUN bash -c 'source ./setuser.sh && groupadd $GROUP_ID && useradd -G $GROUP_ID $USER_ID && chown $USER_ID:$GROUP_ID /app/static/images  && chmod 700 /app/static/images'
RUN bash -c 'source ./setuser.sh && groupadd $GROUP_ID && useradd -G $GROUP_ID $USER_ID && chown $USER_ID:$GROUP_ID /app/static/images'
USER www-data

CMD [ "app.py" ]



