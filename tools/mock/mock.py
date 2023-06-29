import json

import requests
from flask import Flask, abort, request, jsonify, redirect
import random

app = Flask(__name__)
url = "https://external-%s.dev.consolecore.io"

@app.route('/<service>/<path:path>', methods=['GET', 'POST', 'PATCH', 'DELETE'])
def get(service, path):
    if request.method == 'GET' or request.method == '':
        res = requests.get(url % service + "/" + path, headers={
            "Authorization": request.headers.get("Authorization")
        }, params=request.args)
        try:
            return res.json()
        except:
            return res.content
    elif request.method == 'DELETE':
        res = requests.delete(url % service + "/" + path, headers={
            "Authorization": request.headers.get("Authorization")
        }, params=request.args)
        return res.json()
    elif request.method == 'POST':
        res = requests.post(url % service + "/" + path, headers={
            "Authorization": request.headers.get("Authorization"),
            "Content-type": 'application/json'
        }, data=request.get_data())
        return res.json()
    elif request.method == 'PATCH':
        res = requests.patch(url % service + "/" + path, headers={
            "Authorization": request.headers.get("Authorization"),
            "Content-type": 'application/json'
        }, data=request.get_data())
        return res.json()

# @app.route('/<service>/admin/ports/v1/<id>', endpoint="test")
# def get(service, id):
#     newUrl = url % service + request.path.replace("/"+service, "")
#     res = requests.get(newUrl, headers={
#         "Authorization": request.headers["Authorization"]
#     }).json()
#     res['minBandwidth'] = 1
#     res['maxBandwidth'] = 100
#     res['bandwidthTiers'] = random.choice(seq=('20,30,40', '10,20,50', '20,30,60', '10,20,30,80'))
#     res['isBandwidthSoldInTiers'] = bool(random.randint(0,0))
#     return res



app.run(host="0.0.0.0",port=6666)
