#!/usr/bin/env bash

set -euo pipefail

if [ "$#" -lt 15 ]; then
  echo "Usage: $0 <csv_path> <timestamp> <project_id> <project_name> <metric_group> <query_date> <login_check_s> <page_open_s> <project_confirm_s> <sql_prepare_s> <sql_submit_s> <server_execute_s> <result_format_s> <writeback_s> <notes>"
  exit 1
fi

csv_path="$1"
shift

timestamp="$1"
project_id="$2"
project_name="$3"
metric_group="$4"
query_date="$5"
login_check_s="$6"
page_open_s="$7"
project_confirm_s="$8"
sql_prepare_s="$9"
sql_submit_s="${10}"
server_execute_s="${11}"
result_format_s="${12}"
writeback_s="${13}"
notes="${14}"

total_s=$(awk "BEGIN { print ${login_check_s}+${page_open_s}+${project_confirm_s}+${sql_prepare_s}+${sql_submit_s}+${server_execute_s}+${result_format_s}+${writeback_s} }")

mkdir -p "$(dirname "${csv_path}")"

csv_escape() {
  local value="$1"
  value="${value//\"/\"\"}"
  printf '"%s"' "${value}"
}

if [ ! -f "${csv_path}" ]; then
  printf "%s\n" "timestamp,project_id,project_name,metric_group,query_date,login_check_s,page_open_s,project_confirm_s,sql_prepare_s,sql_submit_s,server_execute_s,result_format_s,writeback_s,total_s,notes" > "${csv_path}"
fi

printf "%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n" \
  "$(csv_escape "${timestamp}")" \
  "$(csv_escape "${project_id}")" \
  "$(csv_escape "${project_name}")" \
  "$(csv_escape "${metric_group}")" \
  "$(csv_escape "${query_date}")" \
  "$(csv_escape "${login_check_s}")" \
  "$(csv_escape "${page_open_s}")" \
  "$(csv_escape "${project_confirm_s}")" \
  "$(csv_escape "${sql_prepare_s}")" \
  "$(csv_escape "${sql_submit_s}")" \
  "$(csv_escape "${server_execute_s}")" \
  "$(csv_escape "${result_format_s}")" \
  "$(csv_escape "${writeback_s}")" \
  "$(csv_escape "${total_s}")" \
  "$(csv_escape "${notes}")" >> "${csv_path}"

echo "Appended timing log to ${csv_path}"
