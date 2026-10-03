# 第五课：两个 agent 协作

目标：让 manager 发出任务，让 robot 完成任务并回复。

从项目根目录运行：
```bash
cd lessons/05-two-agents
jason two_agents.mas2j
```

预期关键输出：
```text
[manager] Requesting delivery to alice.
[robot] Taking the stairs.
[robot] Delivering food to alice
[manager] Robot confirmed delivery to alice
```

`.mas2j` 声明两个 agent，分别从 `manager.asl` 和 `robot.asl` 加载程序。每个 agent 有自己的信念和目标，并不自动共享信念库。

manager 发任务：
```prolog
.send(robot, achieve, deliver(alice))
```
默认消息处理下，`achieve` 请求接收方实现这个目标。robot 根据自己的电梯信念选择计划。它没有初始送餐目标，任务来自 manager。

robot 发结果：
```prolog
.send(manager, tell, delivered(Customer))
```
默认处理下，`tell` 把信息加入接收方信念库。manager 的信念带有来源，例如 `delivered(alice)[source(robot)]`。

manager 的计划：
```prolog
+delivered(Customer)[source(robot)]
    <- .print("Robot confirmed delivery to ", Customer).
```
它响应来自 robot 的送达信息。这个来源标注说明信息来自哪个 agent，并不独立证明送餐在现实中成功。

练习一：把 manager 发出的目标改为 `deliver(bob)`。预期所有送餐和确认信息都变为 bob。

练习二：把 robot 的电梯信念改为 working。manager 无须修改，robot 自己选择坐电梯。

注意：如果没有完成回复，可能是 robot 的目标失败了。此例没有超时、重试或失败回复机制，这些属于后续课程。

口述练习：
> The manager sends an achievement request to the robot. The robot chooses a delivery plan using its own beliefs. After the plan finishes, it tells the manager that the delivery is complete. The manager reacts to that new belief.
