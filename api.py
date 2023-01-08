import http
import redis
from fastapi import FastAPI, Request, HTTPException, status

# types= 0 -> Search, 1 -> Price, 2 -> Views

app = FastAPI()


@app.get("/HigherOrLower")
async def main(info: Request):
    info_json = await info.json()
    try:
        type_id = int(info_json['type'])
        object_id = int(info_json['id'])
    except:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST)

    if type_id < 0 or type_id >= 3:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST)

    if object_id == 0:
        return redis.Redis(host='192.168.2.2', port=6379, db=type_id).dbsize()

    ans = redis.Redis(host='192.168.2.2', port=6379, db=type_id).json().get(object_id)
    return ans if ans is not None else http.HTTPStatus(404)


@app.post("/HigherOrLower")
async def main(info: Request):
    info_json = await info.json()
    try:
        type_id = int(info_json['type'])
        name_id = info_json['name']
        value_id = float(info_json['value'])
        picture_id = info_json['picture']
    except:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST)

    if type_id < 0 or type_id >= 3:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST)

    r = redis.Redis(host='192.168.2.2', port=6379, db=type_id)
    if not r.json().set(r.dbsize() + 1, ".", {"name": name_id, "value": value_id, "picture": picture_id}, nx=False):
        raise HTTPException(status_code=status.HTTP_507_INSUFFICIENT_STORAGE)
