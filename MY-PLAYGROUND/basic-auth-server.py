from flask import Flask, request, jsonify
from functools import wraps

app = Flask(__name__)

# Dummy credentials
USERNAME = "admin"
PASSWORD = "password"

def basic_auth_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        auth = request.authorization
        if not auth or auth.username != USERNAME or auth.password != PASSWORD:
            return jsonify({"message": "Authentication failed"}), 401
        return f(*args, **kwargs)
    return decorated_function

@app.route("/secure-data", methods=["GET"])
@basic_auth_required
def secure_data():
    return jsonify({"message": "Access granted", "data": "This is secured data"})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)

# python MY-PLAYGROUND/basic-auth-server.py