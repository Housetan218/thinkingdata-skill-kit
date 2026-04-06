# SQL Template Library Reference

This file defines the structure of reusable query templates. Replace placeholders only after confirming project fields and metric definitions.

## Placeholder Convention

Use placeholders like:
- `{{project_id}}`
- `{{subproject_condition}}`
- `{{timezone}}`
- `{{start_date}}`
- `{{end_date}}`
- `{{country_condition}}`
- `{{new_user_condition}}`
- `{{active_user_condition}}`

## Core Templates To Maintain Per Project

Maintain at least these reusable templates:
- new users
- active users
- D1 retention
- key feature usage rate
- key save rate
- top countries for new users
- bundled summary query when multiple metrics can be safely combined

## Query Record Format

````md
## Template: new_users_daily

- Project:
- Metric:
- Last verified:
- Timezone:
- Grain:
- Dependencies:
- Caveats:

```sql
SELECT ...
```
````

## Bundling Guidance

Bundle metrics into one query only when:
- they share the same date grain
- they share the same denominator or can be safely computed together
- the combined query does not become too fragile to maintain

Keep country distribution separate unless it is proven stable to combine.

## Verification Rule

A query template is only `verified` when:
- the project dossier exists
- field names are confirmed
- metric definition is confirmed
- the result has matched at least one trusted output or manual validation
