import os
from google.cloud import storage
from concurrent.futures import ThreadPoolExecutor, as_completed
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Configuration
BUCKET_NAME = "flights_data_boreal-quarter-455022-q5"            # Replace with your bucket
LOCAL_BASE_DIR = "/workspaces/DE-project/flights_data"    # Where your monthly files are stored
MONTHS = [str(i) for i in range(1, 13)]  # 01 to 12
MAX_WORKERS = 4                            # Parallel upload threads

def upload_file(bucket, month):
    """Upload a single month's file to GCS"""
    file_name = f"Flights_2021_{month}.csv" #2020 and 2021
    local_path = os.path.join(LOCAL_BASE_DIR, file_name)
    blob_name = file_name
    
    if not os.path.exists(local_path):
        logger.warning(f"File not found: {local_path}")
        return False

    try:
        blob = bucket.blob(blob_name)
        blob.upload_from_filename(local_path)
        logger.info(f"Uploaded {file_name} successfully")
        return True
    except Exception as e:
        logger.error(f"Failed to upload {file_name}: {str(e)}")
        return False

def main():
    try:
        # Initialize GCS client (automatically uses GOOGLE_APPLICATION_CREDENTIALS)
        client = storage.Client()
        bucket = client.bucket(BUCKET_NAME)
        
        if not bucket.exists():
            raise RuntimeError(f"Bucket {BUCKET_NAME} does not exist")

        # Process files with thread pool
        with ThreadPoolExecutor(max_workers=MAX_WORKERS) as executor:
            futures = {
                executor.submit(upload_file, bucket, month): month
                for month in MONTHS
            }
            
            success_count = 0
            for future in as_completed(futures):
                month = futures[future]
                try:
                    if future.result():
                        success_count += 1
                except Exception as e:
                    logger.error(f"Error processing month {month}: {str(e)}")

        (f"Upload complete! {success_count}/{len(MONTHS)} files succeeded")

    except Exception as e:
        logger.error(f"Fatal error: {str(e)}", exc_info=True)
        raise

if __name__ == "__main__":
    main()