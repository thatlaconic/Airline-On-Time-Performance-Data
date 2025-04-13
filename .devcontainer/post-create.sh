#!/bin/bash

WORKSPACE_PATH="/workspaces/$(basename $(pwd))"

# Create directories
mkdir -p "$WORKSPACE_PATH/.gcp"
mkdir -p "$WORKSPACE_PATH/.dbt"

# Set up credentials
if [ -n "$GOOGLE_CREDENTIALS_JSON" ]; then
  echo "$GOOGLE_CREDENTIALS_JSON" > "$WORKSPACE_PATH/.gcp/credentials.json"
  chmod 600 "$WORKSPACE_PATH/.gcp/credentials.json"
fi

# Create default profile
cat > "$WORKSPACE_PATH/.dbt/profiles.yml" <<EOF
default:
  target: dev
  outputs:
    dev:
      type: bigquery
      method: service-account
      project: ${GCP_PROJECT:-your-project-id}
      dataset: ${DBT_DATASET:-your_dataset}
      threads: 4
      keyfile: $WORKSPACE_PATH/.gcp/credentials.json
EOF