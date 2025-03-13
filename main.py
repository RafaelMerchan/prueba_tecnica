from fastapi import FastAPI
import rutas

app = FastAPI()

app.include_router(rutas.router)

@app.get("/")
def read_root():
    return {"Hello": "World"}
