import time
from fastapi import FastAPI, Request

app = FastAPI(
  title="My Awesome API",
  description="This is a very fancy project, with auto docs for the API",
  version="1.0.0")

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