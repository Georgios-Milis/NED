import cv2
import os
import sys

# Input video file path
input_video = sys.argv[1]

# Output directory for frames
output_directory = sys.argv[2]

# Create the output directory if it doesn't exist
os.makedirs(output_directory, exist_ok=True)

# Open the video file
cap = cv2.VideoCapture(input_video)

# Check if the video file is opened successfully
if not cap.isOpened():
    print("Error: Could not open the video file.")
    exit()

frame_number = 0

# Read and save frames
while True:
    ret, frame = cap.read()

    if not ret:
        break

    # Save the frame as an image (you can specify the file format, e.g., 'frame{:04d}.jpg')
    frame_filename = os.path.join(output_directory, f'frame{frame_number:06d}.png')
    cv2.imwrite(frame_filename, frame)

    frame_number += 1

# Release the video capture object
cap.release()

