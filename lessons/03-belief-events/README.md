# 第三课：响应新增信念

目标：区分“新目标出现”和“新信念加入”。

从项目根目录运行：
```bash
cd lessons/03-belief-events
jason belief_events.mas2j
```

预期关键输出：
```text
[robot] Taking the stairs.
[robot] Delivering food to alice
[robot] Delivery completed for alice
```

与第二课相比，只增加了这条计划：
```prolog
+delivered(Customer)
    <- .print("Delivery completed for ", Customer).
```

执行送餐计划中的 `+delivered(alice)` 时，信念库发生变化，产生对应的新增信念事件。上面的计划匹配这个事件并打印完成消息。

比较：
- `+!deliver(Customer)`：新的成就目标事件。
- `+delivered(Customer)`：新增信念事件。
- 计划体中的 `+delivered(Customer)`：执行一次信念添加操作。

同一串文字位于计划头部和计划体时，作用不同：前者匹配事件，后者执行操作。

练习：把完成计划的输出改为 `Customer notified: `，保持触发事件不变，重新运行。

注意：给已有的同来源信念再次执行完全相同的添加，通常不会形成新的信念变化事件。不要把重复添加信念当作消息队列。

口述练习：
> Adding a new belief can trigger another plan. The delivery plan records that the food has arrived. This belief change creates an event, and the agent reacts by printing a confirmation.
