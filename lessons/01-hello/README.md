# 第一课：运行你的第一个 agent

目标：认识初始目标和计划。只要能看到一句输出，这一课就完成了。

从项目根目录运行：
```bash
cd lessons/01-hello
jason hello.mas2j
```

预期关键输出（日志和前缀可能因版本不同）：
```text
[robot] Hello! I am a Jason agent.
```

打开 `robot.asl`：
- `!start.` 是初始成就目标：启动时，机器人想完成 start。
- `+!start` 匹配新目标出现的事件。
- `<-` 后面是执行步骤。
- `.print` 是内置操作。
- 最后的 `.` 结束整条计划。

`start` 是我们自己起的名字，不是 Jason 的特殊入口关键字。

练习：把输出改为 `Hello, Hanjin!`。停止并重新运行，确认输出发生变化。

口述练习：
> My agent has an initial goal called start. When that goal creates an event, Jason selects a matching plan. The plan prints a greeting.

下一课：返回项目根目录，再进入 `lessons/02-delivery`。
