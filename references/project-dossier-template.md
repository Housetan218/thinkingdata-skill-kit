# Project Dossier Template

Each project should use the same dossier structure.

## `overview.md`

```md
# Overview

- Project name:
- Project ID:
- Aliases:
- Common timezone:
- Main business:
- Owner/contact:
- Notes:

## Subprojects

| Subproject ID | Subproject Name | Platform | Status | Notes |
| --- | --- | --- | --- | --- |
```

## `fields.md`

```md
# Fields

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
```

## `metrics.md`

```md
# Metrics

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
```

## `output-template.md`

```md
# Output Template

- Display name:
- Timezone wording:
- Date format:
- Metric order:
- Country output rule:
- Analysis tone:
- Required caveat wording:
```

## `query-templates.md`

````md
# Query Templates

## Template: example
- Metric:
- Last verified:
- Required placeholders:
- Caveats:

```sql
-- Add verified SQL here
```
````
