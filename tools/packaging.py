'''
    Packages files into a single output folder.
    Files to include and output folder are specified in the .env file.
    Optionally zip output.
    Optionally copy output to other folder.
'''

import os
from dotenv import load_dotenv, dotenv_values
import shutil
from loguru import logger


def clear_dir(dir_path: str):
    '''
    Recursively empties the given directory. Does not delete the given directory
    '''
    logger.debug(f"Clearing folder '{dir_path}'")
    if not os.path.isdir(dir_path):
        raise NotADirectoryError
    
    for item in os.listdir(dir_path):
        item_path = os.path.join(dir_path, item)
        if os.path.isfile(item_path): os.unlink(item_path)
        elif os.path.isdir(item_path): 
            clear_dir(item_path)
    os.rmdir(dir_path)



## Manual config
# If set to True, DO_ZIP and DO_EXPORT will be used. Otherwise user input is used.
USE_MANUAL_CONFIG = True
DO_ZIP = False
DO_EXPORT = True


## Load input variables
load_dotenv()

try:
    config: dict[str, str | list[str]] = {
        'output_dest': os.getenv("OUTPUT_DESTINATION"),
        'output_name': os.getenv("OUTPUT_NAME"),
        'included_file_paths': [fp.strip() for fp in os.getenv("INCLUDED_FILE_PATHS").split(',')] if os.getenv("INCLUDED_FILE_PATHS") is not None else None,
        'export_dest': os.getenv("EXPORT_DESTINATION")
    }
    # if None in config.values()
except LookupError as e:
    logger.error(e.with_traceback)
except Exception as e:
    logger.error(f"Error while reading input variables: {e}")

# Log loaded variables
logger.info("Read input variables:" + ''.join(f'\n\t{key}\' : \'{val}\'' for key,val in config.items()))


## Get user input, if not using manual config
if USE_MANUAL_CONFIG:
    do_zip = DO_ZIP
    do_export = DO_EXPORT
else:
    while (do_zip_input := input(f"Zip output to '{config['output_name']}.zip' [y/n]? ")) not in ['y', 'n']:
        logger.warning(f"\tInvalid input '{do_zip_input}', try again...")
    do_zip: bool = do_zip_input=='y'

    while (do_export_input := input(f"Export output to '{config['export_dest']}' [y/n]? ")) not in ['y', 'n']:
        logger.warning(f"\tInvalid input '{do_export_input}', try again...")
    do_export: bool = do_export_input=='y'


## Generate output
# Check existence of output destination, if not then create it
output_path = os.path.join(os.getcwd(), config['output_dest'])
if not os.path.exists(output_path): logger.info(f"Output destination '{output_path}' non-existent, creating it now."); os.makedirs(output_path, exist_ok=True)

# Generate output
if do_zip:
    logger.info(f"Generating output '{config['output_name'] + '.zip'}'")

    # TODO put files in pdf
else:
    # If not zipping, clear output folder
    logger.info(f"Generating output '{config['output_name']}'")

    # Check existence of output folder, is so then empty it, if not then create it
    output_path = os.path.join(output_path, config['output_name'])
    if os.path.isdir(output_path):
        logger.info(f"Clearing output folder '{output_path}'")
        for filename in os.listdir(output_path):
            filepath = os.path.join(output_path, filename)
            if os.path.isfile(filepath): os.unlink(filepath)
            if os.path.isdir(filepath): clear_dir(filepath)
    
    os.makedirs(output_path, exist_ok=True)

    # Copy selected files to output
    for filename in config['included_file_paths']:
        filepath = os.path.join(os.getcwd(), filename)

        if os.path.isfile(filepath):
            file_dest = os.path.join(output_path, os.path.basename(filename))
            logger.info(f"copying file {file_dest}")
            shutil.copyfile(filepath, file_dest)
            
        elif os.path.isdir(filepath):
            folder_dest = os.path.join(output_path, os.path.basename(filename))
            logger.info(f"copying directory {filepath} to {folder_dest}")
            # TODO Copy directory
            shutil.copytree(filepath, folder_dest)

        else:
            logger.error(f"Could not copy '{filepath}'. File/dir non-existent.")
            # logger.info(f"Clearing output folder '{output_path}'")
            # for filename in os.listdir(output_path):
            #     os.unlink(os.path.join(output_path, filename))
            # TODO Clear folder
            logger.warning("Exiting")
            exit()

# logger.info("Output generated")

# TODO Export output
if do_export:
    # Check existence of export destination, is so then empty it, if not then create it
    export_path = os.path.join(config['export_dest'], config['output_name'])
    if os.path.isdir(export_path):
        logger.info(f"Deleting export folder '{export_path}'")
        clear_dir(export_path)
    
    # os.makedirs(output_path, exist_ok=True)

    # Copy generated output files to output
    logger.info(f"Exporting directory {filepath} to {export_path}")
    # TODO Copy directory
    shutil.copytree(output_path, export_path)