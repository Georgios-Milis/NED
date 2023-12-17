import cv2
import os
import sys

# Input video file path
input_video = sys.argv[1]
output_directory = sys.argv[2]

# Output directory for frames
# output_directory = "test_examples"

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
    # frame_filename = os.path.join(output_directory, '30F.png')
    cv2.imwrite(frame_filename, frame)

    frame_number += 1

# Release the video capture object
cap.release()

# from glob import glob
# import shutil
# import os


# for subject in ["38F", "42M", "49F"]:
#     regex = f"results/NEUTART/{subject}/*.mp4"
#     for file in glob(regex):
#         filename = file.split(os.sep)[-1].replace("mp4", "")
#         utt = file.split(os.sep)[-1].split('_')[1]
#         src = f"/gpu-data3/filby/EAVTTS/TCDTIMIT_preprocessed/videos/{subject}_{utt}.mp4"
#         dst = f"results/NEUTART/{subject}/{filename}_gold.mp4"
#         shutil.copyfile(src, dst)
