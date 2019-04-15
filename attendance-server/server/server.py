from flask import Flask, request, Response, jsonify

from attendance_system.utils import *
import numpy as np
import cv2 as cv
import base64
import jsonpickle
import pickle
import json
from pathlib import Path

def load_embeddings(student_dir):
    embeddings_path = student_dir/'embeddings'
    
    with open(str(embeddings_path), 'rb') as f:
        student_embeddings = pickle.load(f)
        
    return student_embeddings

def initialize_embeddings(root_dir):
    embeddings_dict = {}
    
    for student in root_dir.glob('*'):
        embeddings_ = load_embeddings(student)
        embeddings_dict[student.parts[-1]] = embeddings_
        
    return embeddings_dict

def get_some_embeddings(embeddings_dict, student_ids):
    random_id = list(embeddings_dict.keys())[0]
    len_embeddings = embeddings_dict[random_id][0].shape[0]
    embeddings, labels = np.empty((0, len_embeddings)), np.empty((0, 1))
    for id in student_ids:
        try:
            student_embeddings = embeddings_dict[id]
            embeddings         = np.vstack((embeddings, student_embeddings))
            count_embeddings   = student_embeddings.shape[0]
            labels             = np.vstack((labels, np.tile(np.array([id]), (count_embeddings, 1))))
        except:
            pass
    labels = labels.flatten()
    print(f'{embeddings.shape}\t{labels.shape}')
    return embeddings, labels


def _get_people_in_image(img, embeddings_dicts, student_ids, k=3, threshold=0.5):
    known_embds, known_labels        = get_some_embeddings(embeddings_dict, student_ids)
    unknown_embds, unknown_locations = get_embeddings_in_query_image(img)
    
    knn = get_knn_model(k, known_embds, known_labels)
    
    predictions = get_people_in_image(knn, known_labels, unknown_embds, k=k, threshold=threshold)
    
    ret_val = {}
    
    for pred, loc in zip(predictions, unknown_locations):
        if pred == "unknown":
            continue

        ret_val[pred] = list(loc)
        
    return ret_val


def convert_dict_to_JSON(dict):
    return json.dumps(dict)

app = Flask(__name__)
embeddings_dict = initialize_embeddings(Path('./input_embeddings'))

print(embeddings_dict)

@app.route('/')
def index():
    return "<h1> Hello World </h1>"

@app.route('/attendance', methods=['POST'])
def test():

    r = request
    print('Received request')
    req = json.loads(r.data)
    
    img_bytes = base64.decodebytes(req['image'].encode())
    print(f'len(img_bytes) = {len(img_bytes)}')
    img = cv.imdecode(np.frombuffer(img_bytes, np.uint8), -1)
    img = cv.cvtColor(img, cv.COLOR_BGR2RGB)
    
    print('Getting Predictions...')
    ids = req['ids']
    print(f'ids: {ids}')
    predictions = _get_people_in_image(img, embeddings_dict, ids)
    print(predictions) 
    response = convert_dict_to_JSON(predictions)
    
    response_pickled = jsonpickle.encode(response)
    print('Sending response')
    return jsonify(predictions)

app.run(host="0.0.0.0", port=50000)
