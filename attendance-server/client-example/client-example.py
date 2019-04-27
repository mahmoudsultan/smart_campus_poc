import requests, json
import base64
import cv2
from pathlib import WindowsPath, Path
import os

print('Sending request...')

address = 'http://13.59.94.81:50000/'
url = address + 'attendance'

image_path = Path('./input_images/IMG_20190224_172925.jpg')

content_type = 'image/jpeg'
headers = {'content-type': content_type}

with open(image_path, 'rb') as f:
    img = f.read()

response = requests.post(url, data=base64.encodebytes(img), headers=headers)
response = json.loads(response.json())
for k in response.keys():
    print(f'Found {k} at {response[k]}')
