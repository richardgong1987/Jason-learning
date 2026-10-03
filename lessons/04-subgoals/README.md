# 第四课：先完成子目标，再继续主目标

目标：理解一个任务可以分解成子目标，并认识信念删除和添加。

从项目根目录运行：
```bash
cd lessons/04-subgoals
jason subgoals.mas2j
```

预期关键输出：
```text
[robot] Preparing the delivery.
[robot] Battery is low. Charging first.
[robot] Battery is full.
[robot] Delivering food to alice
[robot] Delivery completed for alice
```

主计划中的 `!prepare` 是子目标。当前送餐意图需要先完成准备，然后才继续后面的送餐步骤。这不是独立启动一个 Java 线程。

`+!prepare : battery(low)` 只在低电量信念成立时适用：
- `-battery(low)` 删除低电量信念。
- `+battery(full)` 增加满电信念。
- 准备计划完成后，父计划继续执行。

这里只是模拟充电，修改内部信念，没有真实充电设备或时间延迟。

练习：把初始信念 `battery(low).` 替换为 `battery(full).`。停止并重新运行，预期输出 `Battery is already full.`，然后继续送餐。

思考：如果把两个电量状态都删掉，prepare 没有适用计划，子目标会失败。我们还没有写失败恢复计划，主送餐目标也不能继续正常完成。

口述练习：
> The delivery goal contains a preparation subgoal. If the battery is low, the agent first runs a charging plan. When the subgoal succeeds, the delivery plan resumes.
