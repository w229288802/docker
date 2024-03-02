from flask import Flask,request

app = Flask(__name__)


@app.route('/token', methods=['POST'])
def token():
    requestJson = request.form
    print(requestJson)
    return {"access_token":"70f93755dc8c597df7d0ae597f48dd43","refresh_token":"e4f0c2f006343298159b36a889aea5b5","uid":"20220309225220012-BF9B-8B5AA79B4","expires_in":3600}

@app.route('/user', methods=['GET', 'POST'])
def user():
    return {"spRoleList":["xianghao5"],"uid":"20220309225220012-BF9B-8B5AA79B4","displayName":"向昊","loginName":"xianghao5"}