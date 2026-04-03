#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

function usage() {
  console.error(
    "Usage: TD_ACCESS_TOKEN=... run_sql_via_ws.js <project_id> <sql_file> [timeout_seconds] [result_json_path]"
  );
}

if (process.argv.length < 4) {
  usage();
  process.exit(1);
}

const token = process.env.TD_ACCESS_TOKEN;
if (!token) {
  console.error("Missing TD_ACCESS_TOKEN");
  process.exit(2);
}

const projectId = Number(process.argv[2]);
const sqlFile = process.argv[3];
const timeoutSeconds = Number(process.argv[4] || "600");
const resultJsonPath = process.argv[5] || "";

if (!Number.isFinite(projectId) || projectId <= 0) {
  console.error(`Invalid project_id: ${process.argv[2]}`);
  process.exit(3);
}

if (!fs.existsSync(sqlFile)) {
  console.error(`SQL file not found: ${sqlFile}`);
  process.exit(4);
}

const sql = fs.readFileSync(sqlFile, "utf8");
const urlBase =
  process.env.TD_WS_URL_BASE || "wss://taadmin.unbing.cn/v1/ta-websocket/query/";
const wsUrl = `${urlBase}${token}`;
const requestId = `WS_SQLIDE@@${Math.random().toString(36).slice(2, 10)}`;
const startMs = Date.now();
const logDir = path.resolve(path.dirname(sqlFile), "..", "logs", "performance");
const timingLogPath = path.join(logDir, "sql-ws-run-timings.log");

function nowSeconds(fromMs) {
  return ((Date.now() - fromMs) / 1000).toFixed(3);
}

function emit(line) {
  process.stdout.write(`${line}\n`);
}

function finish(status, code, extra = {}) {
  const total = nowSeconds(startMs);
  emit(`status.sql_ws_runner=${status}`);
  emit(`timing.total=${total}s`);
  if (extra.connectSeconds) {
    emit(`timing.ws_connect=${extra.connectSeconds}s`);
  }
  if (extra.firstUpdateSeconds) {
    emit(`timing.first_update=${extra.firstUpdateSeconds}s`);
  }
  if (extra.queryElapsedMillis !== undefined) {
    emit(`result.elapsed_time_millis=${extra.queryElapsedMillis}`);
  }
  if (extra.queryId) {
    emit(`result.query_id=${extra.queryId}`);
  }
  if (extra.rawDataSize) {
    emit(`result.raw_data_size=${extra.rawDataSize}`);
  }
  try {
    fs.mkdirSync(logDir, { recursive: true });
    fs.appendFileSync(
      timingLogPath,
      `${new Date().toISOString()}\tproject_id=${projectId}\tstatus=${status}\tconnect=${extra.connectSeconds || ""}s\tfirst_update=${extra.firstUpdateSeconds || ""}s\ttotal=${total}s\tsql_file=${sqlFile}\n`,
      "utf8"
    );
  } catch (_err) {
    // Ignore logging failure.
  }
  process.exit(code);
}

function writeResult(result) {
  if (!resultJsonPath) {
    return;
  }
  fs.mkdirSync(path.dirname(resultJsonPath), { recursive: true });
  fs.writeFileSync(resultJsonPath, JSON.stringify(result, null, 2), "utf8");
}

const payload = {
  requestId,
  projectId,
  qp: JSON.stringify({
    events: {
      sql,
      sqlVoParams: [],
    },
    eventView: {
      sqlViewParams: [],
    },
  }),
  eventModel: 10,
  querySource: "sqlIde",
  searchSource: "model_search",
  isVisualInitialQuery: false,
  useCache: false,
  contentTranslate: "",
};

const frame = ["data", payload, { channel: "ta" }];

emit(`project_id=${projectId}`);
emit(`sql_file=${sqlFile}`);
emit(`ws_url_base=${urlBase}`);
emit(`request_id=${requestId}`);

let connectMs = null;
let firstUpdateMs = null;
let settled = false;

const timeoutTimer = setTimeout(() => {
  if (!settled) {
    settled = true;
    finish("timeout", 5, {
      connectSeconds: connectMs === null ? "" : (connectMs / 1000).toFixed(3),
      firstUpdateSeconds:
        firstUpdateMs === null ? "" : (firstUpdateMs / 1000).toFixed(3),
    });
  }
}, timeoutSeconds * 1000);

const ws = new WebSocket(wsUrl);

ws.addEventListener("open", () => {
  connectMs = Date.now() - startMs;
  emit(`timing.ws_connect=${(connectMs / 1000).toFixed(3)}s`);
  ws.send(JSON.stringify(frame));
});

ws.addEventListener("message", async (ev) => {
  const raw = typeof ev.data === "string" ? ev.data : await ev.data.text();
  if (raw === '["heartbeat",""]' || raw === '["heartbeat", ""]') {
    ws.send('["heartbeat", ""]');
    return;
  }
  let parsed;
  try {
    parsed = JSON.parse(raw);
  } catch (err) {
    emit(`warn.parse_frame_failed=${err.message}`);
    return;
  }
  const [type, body] = parsed;
  if (!body || body.requestId !== requestId) {
    return;
  }
  if (firstUpdateMs === null) {
    firstUpdateMs = Date.now() - startMs;
    emit(`timing.first_update=${(firstUpdateMs / 1000).toFixed(3)}s`);
  }
  emit(
    `progress.update=${JSON.stringify({
      type,
      progress: body.progress,
      status: body.status,
      hintMsg: body.hintMsg || "",
    })}`
  );
  if (body.status === "failed") {
    settled = true;
    clearTimeout(timeoutTimer);
    finish("query_failed", 6, {
      connectSeconds: connectMs === null ? "" : (connectMs / 1000).toFixed(3),
      firstUpdateSeconds:
        firstUpdateMs === null ? "" : (firstUpdateMs / 1000).toFixed(3),
    });
    return;
  }
  if (body.result || body.progress === 100) {
    settled = true;
    clearTimeout(timeoutTimer);
    const result = body.result || {};
    const data = result.data || {};
    writeResult({
      requestId,
      frameType: type,
      payload: body,
    });
    emit("result.payload_begin");
    emit(JSON.stringify(result));
    emit("result.payload_end");
    try {
      ws.close();
    } catch (_err) {
      // Ignore close failure.
    }
    finish("success", 0, {
      connectSeconds: connectMs === null ? "" : (connectMs / 1000).toFixed(3),
      firstUpdateSeconds:
        firstUpdateMs === null ? "" : (firstUpdateMs / 1000).toFixed(3),
      queryElapsedMillis: data.elapsedTimeMillis,
      queryId: data.queryId,
      rawDataSize: data.rawDataSize,
    });
  }
});

ws.addEventListener("error", () => {
  if (!settled) {
    settled = true;
    clearTimeout(timeoutTimer);
    finish("ws_error", 7, {
      connectSeconds: connectMs === null ? "" : (connectMs / 1000).toFixed(3),
      firstUpdateSeconds:
        firstUpdateMs === null ? "" : (firstUpdateMs / 1000).toFixed(3),
    });
  }
});

ws.addEventListener("close", () => {
  if (!settled) {
    settled = true;
    clearTimeout(timeoutTimer);
    finish("ws_closed", 8, {
      connectSeconds: connectMs === null ? "" : (connectMs / 1000).toFixed(3),
      firstUpdateSeconds:
        firstUpdateMs === null ? "" : (firstUpdateMs / 1000).toFixed(3),
    });
  }
});
