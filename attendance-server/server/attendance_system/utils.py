from tqdm import tqdm
from pathlib import Path
from sklearn.neighbors import KNeighborsClassifier

import face_recognition

from face_recognition.api import _raw_face_landmarks
from face_recognition.api import *


import cv2 as cv
import matplotlib.pyplot as plt

from multiprocessing import Pool

import dlib


def my_face_encodings(face_images, landmarks_model, known_face_locations=None,\
                      number_of_times_to_upsample=1,\
                      detection_model='cnn',
                      num_jitters=1):
    
    if known_face_locations is None:
        known_face_locations = [face_recognition.face_locations(img, number_of_times_to_upsample, model=detection_model)\
                                for img in face_images]
        
    all_raw_landmarks = my_raw_face_landmarks(face_images, known_face_locations)  
    
    ret_val = [[np.array(face_encoder.compute_face_descriptor(image , raw_landmark_set, num_jitters))\
            for raw_landmark_set in raw_landmarks] for image, raw_landmarks in zip(face_images, all_raw_landmarks)]

    del all_raw_landmarks
    
    return ret_val
    
def my_raw_face_landmarks(images, face_locations=None):
    p = Pool(processes=None)
    if face_locations is None:
        all_landmarks = p.map(_raw_face_landmarks, images)
    else:
        args = [(image, loc) for (image, loc) in zip(images, face_locations)]
        all_landmarks = p.map(_raw_face_landmarks, images)
    p.terminate()
    del p
    return all_landmarks

def get_image_encodings(images_paths, label, number_of_times_to_upsample=1, landmarks_model="small"):
    encodings = []
    
    all_images = []
    
    no_faces_paths = []
    multiple_faces_paths = []
    
    for path in images_paths:
        img = face_recognition.load_image_file(path)
        all_images.append(img)
    
    encs = my_face_encodings(all_images, landmarks_model, number_of_times_to_upsample=number_of_times_to_upsample)
    for enc in encs:
        if len(enc) > 0:
            if len(enc) > 1:
                multiple_faces_paths.append(path)
            else:
                encodings.append(enc[0])
        else:
            no_faces_paths.append(path)

        print('.', end='')
    print()
    
    no_len, multiple_len = len(no_faces_paths), len(multiple_faces_paths)
    if no_len > 0 or multiple_len > 0:
        if no_len  > 0:
            str_fmt = 'No faces were found in the following images: '
            for path in no_faces_paths:
                str_fmt += f'{path}-'
            str_fmt[:-1]
            print(str_fmt)
    
        if multiple_len > 0:
            str_fmt = f'Multiple faces were found in the following images: '
            for path in multiple_faces_paths:
                str_fmt += f'{path}-'
            str_fmt = str_fmt[:-1]
            print(str_fmt)
            
        print('Please replace them with other images')
    print('========================================================================')
        
    print(f'Finished processing images of {label}')
    del all_images
    return encodings


def load_images_from_path(path, max_num_images=-1, get_labels=True, choose_pictures_fn=None, landmarks_model="small"):
    face_encodings = []
    labels         = []
    
    for person in path.glob('*'):
        name = person.parts[-1]
        images_paths = []
        
        for image_path in person.glob('*'):
            images_paths.append(image_path)
        
        if choose_pictures_fn is not None:
            images_paths = choose_pictures_fn(images_paths)
        
        if max_num_images != -1:
            images_paths = images_paths[:max_num_images]
        
       
        print(f'Processing {len(images_paths)} images of {name}: ', end='')
        encodings = get_image_encodings(images_paths, name, landmarks_model=landmarks_model, number_of_times_to_upsample=0)
        if get_labels:
            label = [name] * len(encodings) 
            labels += label

        face_encodings += encodings
    
    if get_labels:
        return face_encodings, labels
    
    return face_encodings

def get_locations_in_query_image(img, detection_model='cnn'):
    return face_recognition.face_locations(img, 0, model=detection_model)

def get_embeddings_in_query_image(img, detection_model='cnn', num_jitters=10, return_locations=True):
    unknown_face_locations = get_locations_in_query_image(img, detection_model=detection_model)

    unknown_face_embeddings = face_recognition.face_encodings(img, known_face_locations=\
                                                              unknown_face_locations, num_jitters=num_jitters)
    
    if return_locations:
        return unknown_face_embeddings, unknown_face_locations
    return unknown_face_embeddings

def get_knn_model(k, face_encodings, labels):
    knn = KNeighborsClassifier(k, weights='distance')
    knn.fit(face_encodings, labels)
    
    return knn

def get_people_in_image(knn, known_labels, embds, k=3, threshold=0.5):
    predictions = []
    distances, preds = knn.kneighbors(embds, n_neighbors=k)

    for dist, pred, face_emb in zip(distances, preds, embds):
        mean_dist = sum(dist)/len(dist)
        if mean_dist > threshold:
            name='unknown'
        else:
            name = known_labels[pred[0]]

        predictions.append(name)
    return predictions

def display_results(img, locations=None, names=None, detection_model=None, border_color=(0, 0, 255)):
    img = img.copy()
    
    font = cv.FONT_HERSHEY_DUPLEX
    
    if locations is None:
        if detection_model is None:
            detection_model = 'cnn'
        locations = get_locations_in_query_image(img, detection_model=detection_model)
    
    if names is None:
        names = [None] * len(locations)
    
    for (top, right, bottom, left), name in zip(locations, names):
        if name is not None and name == 'unknown':
            continue
            
        cv.rectangle(img, (left, top), (right, bottom), border_color, 5)
        
        if name is not None:
            cv.rectangle(img, (left, bottom - 35), (right, bottom), border_color, cv.FILLED)
            cv.putText(img, name, (left + 6, bottom - 6), font, 3.0, (255, 255, 255), 2)
            
    fig, ax = plt.subplots(1, 1, figsize=(20, 20))
    ax.imshow(img)
    ax.grid(False)
    