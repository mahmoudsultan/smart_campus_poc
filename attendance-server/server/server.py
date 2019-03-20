from flask import Flask, request, Response

from attendance_system.utils import *
import numpy as np
import cv2 as cv
import base64
import jsonpickle
import pickle
import json

def get_model_name(info):
    return 'class0'

def _get_people_in_image(img, info):
    unknown_embds, unknown_locations = get_embeddings_in_query_image(img)
    
    model_name = get_model_name(info)
    
    with open(model_name, 'rb') as f:
        knn = pickle.load(f)
    
    k=3
    threshold = 0.5
    known_labels = knn.labels
    
    predictions = get_people_in_image(knn, known_labels, unknown_embds, k=k, threshold=threshold)
    
    ret_val = {}
    
    for pred, loc in zip(predictions, unknown_locations):
        if pred == "unknown":
            continue

        ret_val[pred] = loc
        
    return ret_val


def convert_dict_to_JSON(dict):
    return json.dumps(dict)

app = Flask(__name__)


@app.route('/')
def index():
    return "<h1> Hello World </h1>"

@app.route('/attendance', methods=['POST'])
def test():
    r = request
    print('Received request')
    img_bytes = base64.decodebytes(r.data)
    img = cv.imdecode(np.frombuffer(img_bytes, np.uint8), -1)
    img = cv.cvtColor(img, cv.COLOR_BGR2RGB)
    
    print('Getting Predictions...')
    info = None
    predictions = _get_people_in_image(img, info)
    
    response = convert_dict_to_JSON(predictions)
    
    response_pickled = jsonpickle.encode(response)
    print('Sending response')
    return Response(response=response_pickled, status=200, mimetype="application/json")

app.run(host="0.0.0.0", port=50000)
