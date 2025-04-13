from google.cloud import bigquery
import os
from google.oauth2 import service_account

# Path to your service account JSON key file
KEY_PATH = "/home/codespace/.config/gcloud/key.json"

# Initialize client with explicit credentials
credentials = service_account.Credentials.from_service_account_file(KEY_PATH)
client = bigquery.Client(credentials=credentials, project="boreal-quarter-455022-q5")

def load_gcs_to_bigquery():
    # Set variables
    project_id = "boreal-quarter-455022-q5"
    dataset_id = "flights_data_bq"
    bucket_name = "flights_data_boreal-quarter-455022-q5"
    
    # Update with the correct file path pattern (you may loop over the files later)
    file_path = "gs://flights_data_boreal-quarter-455022-q5/Flights_2021_*.csv"
    
    # Specify your table name
    table_name = "Flights_2021"  # Use a static name for the table
    
    # Reference the destination table
    table_ref = client.dataset(dataset_id).table(table_name)
    
    # Configure the load job
    job_config = bigquery.LoadJobConfig(
        source_format=bigquery.SourceFormat.CSV,
        autodetect=True,  # Automatically detect schema (you can also provide a schema if needed)
        skip_leading_rows=1,
    )
    
    # Start the load job for each file if using a wildcard
    uri = file_path  # If you want to use multiple files, you could iterate over each one
    
    # Start the load job
    load_job = client.load_table_from_uri(
        uri, table_ref, job_config=job_config
    )
    
    # Wait for job to complete
    load_job.result()
    
    print(f"Job finished. Loaded {load_job.output_rows} rows into {dataset_id}.{table_name}")

if __name__ == "__main__":
    load_gcs_to_bigquery()
