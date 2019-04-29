from flask import Flask, request, Response, jsonify

from attendance_system.utils import *
from utils import *
import jsonpickle
import json
from pathlib import Path

app = Flask(__name__)
embeddings_dict = initialize_embeddings(Path('./input_embeddings'))

@app.route('/')
def index():
    return "<h1> Hello World </h1>"

@app.route('/attendance', methods=['POST'])
def test():

    r = request
    print('Received request')
    req = json.loads(r.data)
    
    img = get_image_from_request(req)

    print('Getting Predictions...')
    ids = req['ids']
    predictions = _get_people_in_image(img, embeddings_dict, ids, method='cnn')
    print(predictions) 
    
    response = convert_dict_to_JSON(predictions)
    print(response)    
    
    response_pickled = jsonpickle.encode(response)
    print('Sending response')
    return jsonify(response)

app.run(host="0.0.0.0", port=50000)
