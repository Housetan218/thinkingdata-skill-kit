#!/usr/bin/env bash

set -euo pipefail

if [ "$#" -lt 3 ]; then
  echo "Usage: $0 <base_dir> <project_id> <project_slug>"
  exit 1
fi

base_dir="$1"
project_id="$2"
project_slug="$3"
project_dir="${base_dir}/${project_id}-${project_slug}"

mkdir -p "${project_dir}"

create_file() {
  local path="$1"
  local content="$2"
  if [ ! -f "${path}" ]; then
    printf "%s\n" "${content}" > "${path}"
  fi
}

create_file "${project_dir}/overview.md" "# Overview

- Project name:
- Project ID: ${project_id}
- Aliases:
- Common timezone:
- Main business:
- Owner/contact:
- Notes:

## Subprojects

| Subproject ID | Subproject Name | Platform | Status | Notes |
| --- | --- | --- | --- | --- |
"

create_file "${project_dir}/fields.md" "# Fields

## User Identity
- Main user field:
- Device field:

## Time
- Event time field:
- Date conversion rule:

## Dimensions
- Country field:
- Platform field:
- App version field:
- Language field:

## Filters
- Internal/test exclusion:
- Valid-user filter:
- Other exclusions:
"

create_file "${project_dir}/metrics.md" "# Metrics

## Verified

### New Users
- Definition:
- Main event or condition:
- Exclusions:

### Active Users
- Definition:
- Main event or condition:

### D1 Retention
- Definition:
- Denominator:
- Numerator:

## Project-Specific

### Metric Name
- Definition:
- Formula:
- Caveat:

## Unverified
- Metric name:
- Why still unverified:
"

create_file "${project_dir}/output-template.md" "# Output Template

- Display name:
- Timezone wording:
- Date format:
- Metric order:
- Country output rule:
- Analysis tone:
- Required caveat wording:
"

create_file "${project_dir}/query-templates.md" "# Query Templates

## Template: example
- Metric:
- Last verified:
- Required placeholders:
- Caveats:

\`\`\`sql
-- Add verified SQL here
\`\`\`
"

echo "Created project kit at ${project_dir}"
