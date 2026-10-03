# Jason Learning — 从一个送餐机器人开始

这是一个循序渐进的 Jason / AgentSpeak 学习项目。以“机器人送餐”为例，从一个 agent 的目标和计划，逐步学到两个 agent 的通信。每课是独立项目，运行前先进入对应目录。

## 第一次只做第一课

1. 安装 Java 21 和 Jason CLI，见 [安装说明](docs/SETUP.md)。
2. 克隆这个项目：

```bash
git clone https://github.com/richardgong1987/Jason-learning-.git
cd Jason-learning-
```

3. 在项目根目录执行：

```bash
cd lessons/01-hello
jason hello.mas2j
```

看到 `Hello! I am a Jason agent.` 就说明第一课运行成功。先修改问候语并重跑，然后再做第二课。

Jason 运行结束一个目标后，通常仍等待新事件。控制台窗口或进程保持运行不代表卡死。切换课程前先停止当前系统。

## 学习顺序

| 课 | 主题 | 入口 |
| --- | --- | --- |
| 01 | 初始目标与计划 | [第一课](lessons/01-hello/README.md) |
| 02 | 根据电梯信念选择送餐路线 | [第二课](lessons/02-delivery/README.md) |
| 03 | 对新增信念作出反应 | [第三课](lessons/03-belief-events/README.md) |
| 04 | 子目标、更新信念、继续主任务 | [第四课](lessons/04-subgoals/README.md) |
| 05 | manager 与 robot 通信 | [第五课](lessons/05-two-agents/README.md) |

每次练习都按这个顺序：先预测输出 → 运行原例 → 修改一处 → 停止并重跑 → 用自己的话解释发生了什么。每课末尾提供英文口述稿，方便同时练习技术英语。

## 符号速查

| 写法 | 含义 |
| --- | --- |
| `elevator(broken).` | 初始信念 |
| `!deliver(alice).` | 初始成就目标 |
| `+!deliver(X)` | 匹配新成就目标事件 |
| `+delivered(X)`（计划头） | 匹配新增信念事件 |
| `+delivered(X)`（计划体） | 添加信念 |
| `-battery(low)`（计划体） | 删除信念 |
| `:` | 适用条件开始 |
| `<-` | 计划执行步骤开始 |
| `;` | 分隔计划体步骤 |
| `.` | 结束一条完整声明或计划 |
| `X` / `Customer` | 大写开头是变量 |
| `alice` / `broken` | 小写名称是原子常量 |
| `.send(robot, achieve, Goal)` | 请求另一个 agent 实现目标 |
| `.send(manager, tell, Fact)` | 告诉另一个 agent 一条信息 |

“信念”是 agent 所掌握的信息，不保证真实；“计划”是备选方法；“意图”是运行时承诺执行的计划实例。这里的路线和充电都通过文字及信念更新模拟，没有接入实际环境。

## 遇到问题

参考 [安装与排错](docs/SETUP.md)。可以提供：课号、操作系统、`java -version` / `jason --version`、完整错误信息和你修改过的 `.asl` 文件。

## 官方参考

- [Jason 文档](https://jason-lang.github.io/jason/)
- [CLI 安装与运行](https://jason-lang.github.io/jason/jason-cli/readme.html)
- [官方 Getting Started](https://jason-lang.github.io/jason/tutorials/getting-started/readme.html)
- [官方 BDI 教程](https://github.com/jason-lang/jason/blob/main/doc/tutorials/hello-bdi/readme.adoc)

## 验证情况

已检查项目结构、文档链接、agent 源文件配对和配置引用。当前制作环境只有 Java 17，未安装 Jason，因此这些例子还没有在 Jason 中实际运行；预期输出依据官方语法和运行机制编写。建议按第一课开始验证。示例均为本项目编写。
