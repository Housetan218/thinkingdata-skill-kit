# ThinkingData 登录到分析架构流程

更新时间：2026-04-03

> 目标：固定“登录后台 -> 取得登录态 -> 确认项目 -> 进入 SQL 链路”的最短安全路径。

## 1. 固定入口

- 登录页：`https://taadmin.unbing.cn/oauth/#/login`
- 后台主站：`https://taadmin.unbing.cn`
- SQL 页：`https://taadmin.unbing.cn/#/tga/ide/-1?tab=result`

## 2. 标准流程

1. 在真实浏览器中登录后台。
2. 确认后台首页可见，且左上角项目切换器可以打开。
3. 让自动化工具复用当前已登录浏览器状态，或接管当前会话。
4. 在后台页面读取 `localStorage`：
   - `ACCESS_TOKEN`
   - `REFRESH_TOKEN`
   - `TA_MASTER_PROPS`
   - `TA_AUTHS`
5. 后续接口统一使用：

```http
Authorization: Bearer <ACCESS_TOKEN>
```

6. 先确认项目，再决定是否需要探表。
7. 已建档项目直接走 SQL 模板；新项目先探结构再写 SQL。
8. SQL 优先走 WebSocket 直连；浏览器 SQL 页只做回退。

## 3. 读取登录态的固定方式

在后台 shell 页面执行：

```js
localStorage.getItem('ACCESS_TOKEN')
localStorage.getItem('LOGIN_NAME')
```

固定原则：

- token 只用于当前会话，不写入仓库
- token 失效就重新从已登录页面读取
- 不要把 token 抄进长期文档

## 4. 项目确认规则

- 先确认项目 ID，再跑 SQL
- 单产品项目可以直接跑基础模板
- 聚合项目必须先拆产品
- 特殊项目不要默认套 `bundle_id`

当前常用映射提示：

- `123` = LiCoWa iOS
- `125` = LiCoWa Android
- `160` / `170` = 聚合项目
- `171` = 特殊项目

## 5. SQL 进入规则

优先顺序：

1. 已建档项目 + 已有模板：
   - 直接 WebSocket 直连
2. 新项目或异常项目：
   - 先探结构
   - 再写 SQL
3. 直连受阻：
   - 回退到浏览器 SQL 页

详见：

- [data-acquisition-methods.md](data-acquisition-methods.md)

## 6. 常见错误

- 登录后直接看仪表盘读数
- 未确认项目就开始跑 SQL
- token 没更新，导致后台接口误报未登录
- 聚合项目没拆产品就直接输出结论
- 写 SQL、计算、下载 CSV

还不稳定的部分：

- 不同项目的“正试用户”口径字段不一致
- 留存和使用率指标还需要逐项目校准
- 数数查询引擎全局队列会显著影响耗时

## 7. 推荐团队使用方式

团队初版 skill 只负责：

1. 登录和鉴权检查
2. 项目结构探查
3. 项目识别字段确认
4. SQL 页标准操作
5. 常见错误拦截

先不要在初版 skill 里承诺：

- 所有产品可直接一键出完整日报
- 所有比率指标都天然口径一致
- 无需人工校准
