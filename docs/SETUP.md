# 安装与排错

## 安装一次，后续直接运行课程

官方 CLI 文档目前以 Java 21 为前提。

1. 安装 JDK 21。`java -version` 应显示 21。
2. 从 [官方发布页](https://github.com/jason-lang/jason/releases) 下载 `jason-bin-…zip`，解压到固定位置。
3. 将解压目录下的 `bin` 加到 PATH。重开终端执行 `jason --version`。
4. 使用 VS Code 或其他文本编辑器打开这个项目。

### Windows

官方推荐使用 Git Bash。Java 21 和 Jason 安装完成后，在 Git Bash 中运行：

```bash
java -version
jason --version
```

可以通过 Windows 环境变量设置，把 Jason 的 `bin` 文件夹加入用户 Path；修改后关闭并重新打开 Git Bash。

### macOS / Linux

把解压后 `bin` 目录加入 shell 的 PATH，例如临时配置：

```bash
export PATH="/your/path/to/jason/bin:$PATH"
jason --version
```

将示例路径替换为实际位置。若 `jason` 脚本没有执行权限，在其所在 bin 目录执行 `chmod +x jason`。希望永久生效时，把 PATH 配置加入你实际使用的 shell 启动配置。

## 运行第一课

在 jason-learning 根目录执行：

```bash
cd lessons/01-hello
jason hello.mas2j
```

每课目录都包含自己的 `.mas2j` 和 `.asl` 文件，不需要运行 `jason app create`，也不需要编写 Java 环境类。

这组例子没有额外依赖。如果通常的启动命令遇到 Gradle 或下载问题，官方 CLI 还提供直接启动方式：

```bash
jason mas start --mas2j=hello.mas2j
```

运行前仍然必须处于第一课目录。其他课替换为自己的配置文件名。

## 停止与重新运行

图形控制台启动时，可以使用控制台的停止/退出控件结束系统。前台终端启动时可以用 Ctrl+C。修改源代码后，先停止当前系统，再重新运行。

如果 CLI 启动的系统仍在后台，在另一个终端执行：

```bash
jason mas list
```

根据列表中实际的系统名称停止它：

```bash
jason mas stop <实际系统名称> --exit
```

不要原样输入尖括号占位符。

## 常见问题

| 问题 | 排查 |
| --- | --- |
| `jason: command not found` | bin 是否加入 PATH，终端是否重开 |
| Java 版本错误 | `java -version` 是否为 21，PATH 是否优先指向旧 JDK |
| 找不到 `.mas2j` | 当前目录是否为对应课的目录 |
| 找不到 agent 源文件 | `.asl` 是否和配置在同一目录，名称是否匹配 |
| 语法错误 | 检查英文 `.`、`;`、`:`、`<-`，避免中文标点 |
| 目标没有适用计划 | 检查计划事件能否匹配目标、条件信念是否成立 |
| 修改后输出没变化 | 是否停止旧系统，是否运行了正确的课 |
| 打印结束但窗口仍打开 | agent 在等待新事件，这是正常运行方式 |

系统日志和控制台格式可能随版本变化。每课 README 给出要观察的关键消息，不要求日志逐字一致。
