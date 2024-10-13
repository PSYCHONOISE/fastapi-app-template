import time

from fastapi import FastAPI, Request, Response, Query 
from fastapi.responses import HTMLResponse
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates

app = FastAPI(
  title="My Awesome API",
  description="This is a very fancy project, with auto docs for the API",
  version="1.0.0",
  docs_url="/docs",                   # Путь для Swagger UI
  redoc_url="/redoc",                 # Путь для ReDoc
  openapi_url="/api/v1/openapi.json") # Путь для OpenAPI-схемы
app.mount('/static', StaticFiles(directory='static'), name='static')
templates = Jinja2Templates(directory='templates')

@app.middleware("http")
async def add_process_time_header(request: Request, call_next):
  start_time = time.time()
  response = await call_next(request)
  process_time = time.time() - start_time
  if request.query_params.__contains__("set-process-time"):
    response.headers["X-Process-Time"] = str(process_time)
  return response

@app.get("/")
async def root():
  return {"message": "Hello World"}