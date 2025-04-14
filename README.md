# Data Engineering Pipeline with Modern Tools  
**A Comprehensive Report on Building an End-to-End Data Pipeline**  
## About Dataset 
+ This dataset was obtained from [kaggle](https://www.kaggle.com/datasets/robikscube/flight-delay-dataset-20182022?fbclid=IwZXh0bgNhZW0CMTEAAR2T1H6XTAsd0yEPQMr2LLCmAHwVv7uYcD9r5KBckwsjsrhfFNOTEt5fnSo_aem_mQbJbkFYbtlAPHT_34pqRQ) which originally came from United States Department of Transportation open data in [Marketing Carrier On-Time Performance (Beginning January 2018)](https://www.transtats.bts.gov/Fields.asp?gnoyr_VQ=FGK)
+ For this project data from year 2020-2021 was used.
### Description
+ This database contains scheduled and actual departure and arrival times reported by certified U.S. air carriers that account for at least half of one percent of domestic scheduled passenger revenues. In 2018 the percent changed from one percent to half of one percent. The data is collected by the Office of Airline Information, Bureau of Transportation Statistics (BTS).
+ **Marketing Carrier On-Time Performance (Beginning January 2018)**
Marketing carriers market flights for themselves and, in some cases, for regional code share partners. Table shows on-time data for the marketing carrier network, if applicable, the marketing carrier that is the reporting carrier and the marketing carriers code-share affiliates as a group. Reporting carriers that do not market flights are included in the regional code share group. Table shows: on-time arrival and departure data for non-stop domestic flights by month and year, by marketing network, marketing carrier that reports and regional code-share group, by origin and destination airport. Includes scheduled and actual departure and arrival times, canceled and diverted flights, taxi-out and taxi-in times, causes of delay and cancellation, air time, and non-stop distance. Use Download for individual flight data.

    
## 1. Overview  
This project demonstrates a **modern data engineering pipeline** using:  
- **Terraform** (Infrastructure as Code)  
- **Python** (Data Processing & API Integration)  
- **Google Cloud Storage (GCS)** (Data Lake)  
- **BigQuery** (Data Warehouse)  
- **dbt (Data Build Tool)** (Transformation & Modeling)  
- **Looker Studio** (Visualization & BI)  

---

## 2. Architecture Diagram  
```
    [Data Source] 
        |
        v
    [Python ETL Script]
        |
        v
    [Google Cloud Storage] --> [Terraform Provisioned Resources]
        |
        v
    [BigQuery Raw Tables]
        |
        v
    [DBT Models (Staging, Core)]
        |
        v
    [Looker Studio Dashboard]
```

## 3. Technologies Used
|Tools  | Purpose |
|-------|---------|
| **Terraform**	| Automates GCP resource provisioning (BigQuery, GCS, IAM) |
**Python**	| Extracts, transforms, and loads (ETL) data into GCS
**Google Cloud Storage (GCS)**	| Stores raw and processed data (data lake)
**BigQuery** | Data warehouse for structured analytics
**dbt (Data Build Tool)**	| Transforms raw data into analytics-ready models
**Looker Studio**	| Creates interactive dashboards

## 4. Step-by-Step Implementation
### 4.1 Terraform Setup (Infrastructure as Code)
`main.tf` – Provisions GCP resources:
```hcl
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.6.0"
    }
  }
}

provider "google" {
  # Credentials only needs to be set if you do not have the GOOGLE_APPLICATION_CREDENTIALS set
  #  credentials = 
  project = var.project
  region  = var.location
}

resource "google_storage_bucket" "data-lake-bucket" {
  name     = "${local.data_lake_bucket}_${var.project}" # Concatenating DL bucket & Project name for unique naming
  location = var.location

  # Optional, but recommended settings:
  storage_class               = var.storage_class
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 30 // days
    }
  }

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }


}

resource "google_bigquery_dataset" "dataset" {
  dataset_id = var.BQ_DATASET
  project    = var.project
  location   = var.location

}
```

**Run Terraform:**

```bash
terraform init
terraform plan
terraform apply
```

### 4.2 Python ETL (Extract & Load to GCS)
+ Fetches data and uploads to GCS:
```bash 
python data_ingestion_gcs.py
``` 
### 4.3 Python ETL (Extract & Load to BigQuery)
+ Load data from GCS to BigQuery:

```bash 
python gcs_to_bq.py
``` 

### 4.4 dbt (Data Transformation & Modeling)

`profiles.yml` (dbt config):

```yaml
DE_Project01:
  outputs:
    dev:
      dataset: dbt_flights_output
      job_execution_timeout_seconds: 300
      job_retries: 1
      keyfile: /home/codespace/.config/gcloud/key.json
      location: asia-southeast1
      method: service-account
      priority: interactive
      project: boreal-quarter-455022-q5
      threads: 4
      type: bigquery
  target: dev
```


`models/core/airport_congestion_analysis.sql` (dbt model):

```sql

{{
    config(
        materialized='table'
    )
}}


SELECT 
    Year,
    Origin,
    AVG(TaxiOut) AS avg_taxi_out_time,
    AVG(DepDelay) AS avg_dep_delay
FROM {{ref("flights_2020-2021")}}
GROUP BY Year, Origin
ORDER BY Origin
```
**Run dbt:**

```bash
dbt run  # Builds models in BigQuery
dbt docs generate  # Generates data lineage
```
### 4.4 Looker Studio (Visualization)
Connect to BigQuery as a data source.
+ **Dashboard**
>    ![](Looker/page_1.PNG)
>    ![](Looker/page_2.PNG)



