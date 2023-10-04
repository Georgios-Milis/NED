""" Utility script for downloading the FSGAN models.
This script should be placed in the root directory of the FSGAN repository.
"""
import argparse
import logging
import os
import traceback

from fsgan.utils.utils import download_from_url


parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.ArgumentDefaultsHelpFormatter)
parser.add_argument('-o', '--output', default='weights', metavar='DIR', help='output directory')

model_link = 'https://github.com/YuvalNirkin/fsgan/releases/download/v1.0.1/lfw_figaro_unet_256_2_0_segmentation_v1.pth'


def main(output='weights'):
    # Make sure the output directory exists
    os.makedirs(output, exist_ok=True)

    filename = os.path.split(model_link)[1]
    out_path = os.path.join(output, filename)
    if os.path.isfile(out_path):
        print('Skipping "%s"' % (filename))
    print('Downloading "%s"...' % (filename))
    try:
        download_from_url(model_link, out_path)
    except Exception:
        logging.error(traceback.format_exc())


if __name__ == "__main__":
    main(**vars(parser.parse_args()))
