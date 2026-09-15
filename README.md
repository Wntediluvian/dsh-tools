# dsh-tools

[DeepSeek Harness](https://github.com/deepseek-ai/deepseek-harness) 运维工具与辅助脚本合集。

相关工作：
- [dsh-plugins](https://github.com/Wntediluvian/dsh-plugins) — 插件（如 dsh-backup）
- [chatgpt-knowledge-base](https://github.com/Wntediluvian/chatgpt-knowledge-base) — Skills 与本地知识库（原 `dsh-skills` 已退役，技能内容已并入该仓库）
- **dsh-tools** — 运维脚本与工具（本仓库）

## 工具列表

| 工具 | 说明 |
|---|---|
| [launchers/启动备用dsh-3081.bat](./launchers/启动备用dsh-3081.bat) | fallback 应急启动器：主进程（3080）无法启动时，以 fallback profile（无用户插件）在 3081 端口启动 dsh |

## 使用

```bat
# 双击运行，或命令行执行
启动备用dsh-3081.bat
```

脚本自动检测 dsh 可执行文件与数据目录（PATH → 常见安装位置）。检测失败时编辑脚本头部：

```bat
set "DSH_BIN_OVERRIDE=C:\path\to\dsh.cmd"
set "DSH_HOME_OVERRIDE=C:\path\to\dsh-data"
```

> **注意**：脚本需保持 GBK/ANSI 编码（勿存为 UTF-8），否则 cmd 解析中文注释会出错。

## 目录规划

```
dsh-tools/
├── README.md
└── launchers/        ← 启动类脚本
    └── 启动备用dsh-3081.bat
```

## License

MIT
