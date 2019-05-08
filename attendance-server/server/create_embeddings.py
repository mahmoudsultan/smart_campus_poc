import pickle
import time
from attendance_system.utils import *

root_path = Path('./input_images')
embeddings_path = Path('./input_embeddings')

if embeddings_path.exists():
    for l in embeddings_path.glob('*'):
        embeddings_file_path = l/'embeddings'
        embeddings_file_path.unlink()
        l.rmdir()
    embeddings_path.rmdir()

embeddings_path.mkdir()
    
known_encodings, known_labels = load_images_from_path(root_path)

print(known_labels)

len_encoding = known_encodings[0].shape[0]

current_label = None
current_embeddings = np.empty((0, len_encoding))

i = 0
while i < len(known_labels):
    label = known_labels[i]
    
    if label != current_label:
        print(f'i = {i}, label = {label}, current_label = {current_label}')
        
        if current_label != None:
            print('saving')
            student_dir = embeddings_path/current_label
            student_dir.mkdir()
        
            with open(str(student_dir/'embeddings'), 'wb') as f:
                pickle.dump(current_embeddings, f)
        
        current_label = label
        current_embeddings = np.empty((0, len_encoding))
        
    current_embeddings = np.vstack((current_embeddings, known_encodings[i]))
    i += 1
        
print(f'finishing, label = {known_labels[-1]}')
student_dir = embeddings_path/known_labels[-1]
student_dir.mkdir()

with open(str(student_dir/'embeddings'), 'wb') as f:
    pickle.dump(current_embeddings, f)
