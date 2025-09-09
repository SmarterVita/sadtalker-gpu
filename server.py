from fastapi import FastAPI, Request, Header
from fastapi.responses import JSONResponse
import os

app = FastAPI()

TOKEN = os.getenv("TALKING_HEAD_SERVICE_TOKEN", "changeme")

@app.get("/health")
def health():
    return {"status": "ok"}

@app.post("/v1/talking-head")
async def talking_head(request: Request, authorization: str = Header(None)):
    if authorization != f"Bearer {TOKEN}":
        return JSONResponse(status_code=401, content={"error": "unauthorized"})
    
    body = await request.json()
    job_id = body.get("jobId")
    # TODO: run SadTalker inference here
    
    return {"jobId": job_id, "status": "working", "step": "preflight"}
