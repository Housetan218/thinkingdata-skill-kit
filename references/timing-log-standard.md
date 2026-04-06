# Timing Log Standard

Measure the workflow by stages so slowdowns can be localized.

## Recommended Stages

- `login_check_s`
- `page_open_s`
- `project_confirm_s`
- `sql_prepare_s`
- `sql_submit_s`
- `server_execute_s`
- `result_format_s`
- `writeback_s`
- `total_s`

## Log Row Format

```csv
timestamp,project_id,project_name,metric_group,query_date,login_check_s,page_open_s,project_confirm_s,sql_prepare_s,sql_submit_s,server_execute_s,result_format_s,writeback_s,total_s,notes
2026-04-05T22:30:00+08:00,125,LiCoWa Android,summary_daily,2026-03-30,1.2,2.5,1.0,3.1,0.8,41.7,2.2,0.9,53.4,"country split kept separate"
```

## Usage Rule

If total time is high, do not just report the total. Identify which stage dominates.

## Optimization Priorities

- If `login_check_s` or `page_open_s` is high: improve browser/session reuse.
- If `project_confirm_s` is high: improve local project index and naming clarity.
- If `sql_prepare_s` is high: improve reusable SQL templates.
- If `server_execute_s` is high: optimize query design or reduce query count.
- If `result_format_s` is high: standardize output templates.
