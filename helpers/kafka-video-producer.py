"""
Camera Video Kafka Producer using OpenCV
"""

import argparse
import base64
import cv2
import sys
import json
import time
from kafka import KafkaProducer
from kafka.errors import KafkaError

def format_json_for_image(key, pixels):
  """
  Formats and returns json in format
  {
    "key": key,
    "image": pixels
  }
  """
  return json.dumps({'key': key, 'image': pixels})

def on_send_error(excp):
  print(excp)

def on_send_success(excp):
  print('Frame Sent.')

def publish_video(producer, topic, key, sleep=0.2, file_name='test_video.avi'):
  """
  Publish frames from a local video to producer topic
  args:
    producer: Kafka producer.
    topic: Topic name to publish frames to.
  """
  cap = cv2.VideoCapture(file_name)
  print('Starting Camera Frames Publishing... Best of Luck.')

  while(True):
    success, frame = cap.read()

    if not success:
      cap = cv2.VideoCapture(file_name)
      continue

    _, buffer = cv2.imencode('.jpg', frame)
    # jpg_base64 = base64.encodestring(buffer.tostring())
    pixels_list = buffer.flatten().tolist()
    json = format_json_for_image(key, pixels_list)
    json_bytes = json.encode('utf-8')
    producer.send(topic, json_bytes).add_callback(on_send_success).add_errback(on_send_error)

    # Choppier stream, reduced load on processor
    time.sleep(sleep)


  cap.release()

def main(args):
  if not args.topicname or not args.key:
    print('Topic name and JSON Key must be specified.')
    sys.exit(1)
  topic_name = args.topicname
  key = args.key

  if not args.bsservers:
    print('Bootstrap servers not specified... Using default localhost:9092')
  bootstrap_servers = args.bsservers if args.bsservers else 'localhost:9092'

  producer = KafkaProducer(bootstrap_servers=bootstrap_servers)
  publish_camera(producer, topic_name, key)

if __name__ == '__main__':
  # Configure script arguments and flags
  parser = argparse.ArgumentParser()
  parser.add_argument('-t', '--topicname', help='Kafka Topic Name ex. -t "camera 1"')
  parser.add_argument('-b', '--bsservers', help='Kafka Bootstrap Servers ex. --bsservers localhost:9092')
  parser.add_argument('-k', '--key', help='Key value for the published json.')
  main(parser.parse_args())