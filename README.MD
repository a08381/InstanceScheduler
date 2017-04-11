#CD进度插件 InstanceScheduler
这个插件是用于帮助使用进度的玩家自动化的插件
##队长模式 LeaderMode （未完成）
下载InstanceScheduler_LeaderMode，改名为InstanceScheduler后放入Addons目录即可<br/>
~~_使用方法未完成_~~
##排队模式 LineUpMode
下载InstanceScheduler_LineUpMode，改名为InstanceScheduler后放入Addons目录即可
###使用方法
_**请注意，您所能修改的东西只有`Config.lua`**_<br/>
<br/>您可以修改`InstanceScheduler.AutoStart`为`false`来关闭进入游戏自动启动功能<br/>
您可以修改`InstanceScheduler.Messages`内的自动回复信息

* `AddInLine`为加入队列时的回复
* `AlreadyInLine`为玩家已经加入队列时的回复
* `NetProblem`为玩家由于网络原因跨位面失败时的回复
* `ResetComplete`为副本重置完毕后的回复
* `ChangeDifficulty`为修改副本难度后的回复
* `ChangeLeader`为给予队长后的回复
* `LeaveMessage`为离开队伍前的回复

进入游戏后，您可以用`/click InstanceSchedulerButton`来手动开关插件功能<br/><br/>
_~~使用英雄榜远程遥控CD号功能开发中~~_
