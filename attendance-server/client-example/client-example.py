import requests, json
import base64
import cv2
from pathlib import WindowsPath, Path
import os

print('Sending request...')

address = 'http://3.17.65.133:50000/'
url = address + 'attendance'

image_path = Path('./IMG_20190224_172925-min.jpg')

content_type = 'image/jpeg'
headers = {'content-type': content_type}

with open(str(image_path), 'rb') as f:
    img = f.read()

request_body = {'image': base64.encodebytes(img).decode('utf-8'), 'ids': ['taw2am', 'magdy', 'aly', 'ezz', 'rana', 'nada', 'menna', 'fatma']}

response = requests.post(url, json.dumps(request_body), headers=headers)
response = json.loads(response.json())
for k in response.keys():
    print('Found {} at {}'.format(k, response[k]))
