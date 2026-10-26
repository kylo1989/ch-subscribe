# ⚡ ch-subscribe

个人自用的 **Clash / Mihomo (Clash Meta)** 订阅转换配置文件与精简分流规则集。主要面向家庭旁路由 / 软路由（OpenWrt / iStoreOS / OpenClash）、软硬件网关及多端客户端的高效稳定分流场景。

---

## 🌟 特性

- **精准分流**：合理规划国内直连、海外代理、流媒体、PT 下载及特定局域网规则，避免无效中转。
- **DNS / Fake-IP 友好**：针对 Fake-IP 模式优化，防止 DNS 污染与回环泄漏。
- **规则集维护**：基于主流上游规则源进行模块化组合与精简定制。
- **多端适配**：支持 Mihomo (Clash.Meta) / OpenClash / Clash Verge / Shadowrocket 等主流内核与客户端。

---

## 📁 目录结构

```text
.
├── rules/                  # 分流规则集合 (Rule-Providers / 域名与 IP 规则)
│   ├── direct.list         # 国内直连 / PT / 本地白名单
│   ├── proxy.list          # 代理与常规出海域名
│   ├── media.list          # 国际主流流媒体分流
│   └── reject.list         # 广告及追踪拦截
├── profiles/               # 基础配置模板 / 预设模板
│   └── default.yaml        # 标准订阅模板 (Mihomo 规范)
└── README.md
