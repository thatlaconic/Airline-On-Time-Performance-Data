#!/bin/bash

# Set up Google credentials
mkdir -p /workspaces/.gcp
if [ -n "$GOOGLE_CREDENTIALS_JSON" ]; then
  echo "Setting up Google credentials..."
  echo "$GOOGLE_CREDENTIALS_JSON" > /workspaces/.gcp/credentials.json
  chmod 600 /workspaces/.gcp/credentials.json
else
  echo "⚠️ GOOGLE_CREDENTIALS_JSON not found! BigQuery connections will fail."
fi

# Initialize dbt profile
mkdir -p /workspaces/.dbt
cat > /workspaces/.dbt/profiles.yml <<EOF
default:
  target: dev
  outputs:
    dev:
      type: bigquery
      method: service-account
      project: ${GCP_PROJECT:-[YOUR_PROJECT_ID]}
      dataset: ${DBT_DATASET:-[YOUR_DATASET]}
      threads: 4
      keyfile: /workspaces/.gcp/credentials.json
EOF

echo "✅ dbt profile configured for project: ${GCP_PROJECT:-[YOUR_PROJECT_ID]}"