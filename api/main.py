from flask import Flask, request, jsonify, session
from flask_session import Session
from flask_cors import CORS
import json

app = Flask(__name__)

SECRET_KEY = "required_for_flask_session"
SESSION_TYPE = 'filesystem'
app.config.from_object(__name__)
Session(app)
CORS(app)

@app.route('/login', methods=['POST'])
def login():
    try:
        print(session['values'])
    except KeyError:
        session['values'] = []
    try:
        print(session['LOGGED_IN'])
    except KeyError:
        session['LOGGED_IN'] = False
    key = request.headers.get('key')
    if key == 'pass':
        session['LOGGED_IN'] = True
        print(session['values'])
        return jsonify({'message': 'Login successful'})
    else:
        return jsonify({'message': 'Invalid key'})

@app.route('/logout', methods=['POST'])
def logout():
    session['LOGGED_IN'] = False
    return jsonify({'message': 'Logout successful'})

@app.route('/check_login', methods=['GET'])
def check_login():
    return jsonify({'message': 'User login status is {}'.format(session['LOGGED_IN'])})

@app.route('/add-entry', methods=['POST'])
def add_entry():
    entry_text = request.json
    values = json.loads(entry_text)
    session['values'].append(values['entry-text'])
    return jsonify({'message': 'Entry added successfully'})

@app.route('/check-entries', methods=['GET'])
def check_entries():
    return jsonify(session['values'])

if __name__ == '__main__':
    app.run()