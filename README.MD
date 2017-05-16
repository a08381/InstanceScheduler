#CD进度插件 InstanceScheduler
这个插件是用于帮助使用进度的玩家自动化的插件
##队长模式 LeaderMode （暂无法正常使用）
下载后将InstanceScheduler_LeaderMode放入Addons目录即可<br/>
~~_使用方法未完成_~~
##排队模式 LineUpMode
下载后将InstanceScheduler_LineUpMode放入Addons目录即可
###使用方法
**请注意，您所能修改的东西只有`Config.lua`**<br/>
_特别的，请不要直接使用系统自带记事本打开，推荐使用 [NotePad++](https://notepad-plus-plus.org/download/)_
<br/>您可以修改`InstanceScheduler.AutoStart`为`false`来关闭进入游戏自动启动功能<br/>
您可以修改`InstanceScheduler.Messages`内的自动回复信息

* `AddInLine`为加入队列时的回复
* `AlreadyInLine`为玩家已经加入队列时的回复
* `NetProblem`为玩家由于网络原因跨位面失败时的回复
* `ResetComplete`为副本重置完毕后的回复
* `ChangeDifficulty`为修改副本难度后的回复
* `ChangeLeader`为给予队长后的回复
* `LeaveMessage`为离开队伍前的回复

###插件流程
1. 接受到私聊1，确认队伍中是否有人，是则加入队列，否则发送邀请
2. 玩家同意邀请后，重置副本，并在小队频道发送`ResetComplete`
3. 特别的，在玩家进本前接受到小队频道的10，将会更换模式为10人普通。
4. 玩家进本后，自动发送`ChangeLeader`并给予队长，一秒后发送`LeaveMessage`并离队。
5. 离队后，插件将对自身状态进行检查，若模式为10人普通，则自动改回25人普通，并搜索队列，如果队列中有人则按顺序邀请。

###机制
* 玩家进本时，会直接给予队长并退组，这种情况下读蓝条会等，但是卡蓝条并不会影响下一个人进入队列
* 玩家进组后 120 秒内未进入副本且队列中有其他玩家的情况下，将主动离队
* 玩家进组后离线将会直接离队

当您进入游戏后，您可以为`按键设置`->`插件`->`Instance Scheduler`->`Switch On`设置一个按键来手动开关插件功能<br/><br/>
_~~使用英雄榜远程遥控CD号功能开发中~~_
