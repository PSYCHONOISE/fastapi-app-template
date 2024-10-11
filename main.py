import time
from fastapi import FastAPI, Request

app = FastAPI()

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