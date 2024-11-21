FROM python:3.12

WORKDIR /fastapi

COPY ./requirements.txt /fastapi/requirements.txt

RUN pip install --no-cache-dir --upgrade -r requirements.txt

COPY ./app /fastapi/app

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "80"]