# 第二课：用信念选择送餐计划

目标：运行我们讨论过的送餐例子。同一个目标，根据电梯状态选择不同的计划。

从项目根目录运行：
```bash
cd lessons/02-delivery
jason delivery.mas2j
```

预期关键输出：
```text
[robot] Taking the stairs.
[robot] Delivering food to alice
```

打开 `robot.asl`：
- `elevator(broken).` 是初始信念。
- `!deliver(alice).` 是初始目标。
- 两个计划都匹配 `+!deliver(Customer)`，但适用条件不同。
- `:` 后面的条件在信念库上求值。
- 大写开头的 `Customer` 是变量，匹配目标时绑定为 `alice`。
- `;` 分隔同一个计划中的步骤。
- `+delivered(Customer)` 在执行时增加一条信念。

这里的信念是机器人掌握的信息，不一定等于现实。打印和新增信念只是教学模拟，没有真正移动机器人，也没有独立确认送餐成功。

意图在哪里？你没有声明一个叫 intention 的字段。Jason 选定并实例化计划，把它加入执行中的意图。这是运行时状态。计划是备用方法；意图是已经承诺执行的计划实例。

练习一：把 `elevator(broken).` 替换为 `elevator(working).`，停止并重新运行。预期路线变为 `Taking the elevator.`。两条互斥状态只保留一条。

练习二：把初始目标里的 `alice` 改为 `bob`。预期收餐人变为 bob，两个计划都不用改。

思考：如果两个电梯状态都删掉，两个计划的条件都不成立。这个目标会因为没有适用计划而失败。条件为假，不会自动让目标等到条件变真。

口述练习：
> The agent believes that the elevator is broken. It has a goal to deliver food to Alice. Jason selects the plan whose context is true. The agent takes the stairs and records the delivery as complete.
