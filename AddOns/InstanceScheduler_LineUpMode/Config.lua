--
-- Created by IntelliJ IDEA.
-- User: lenovo
-- Date: 2017/3/28
-- Time: 23:48
-- To change this template use File | Settings | File Templates.
--

local _, InstanceScheduler = ...
_G["InstanceScheduler"] = InstanceScheduler

InstanceScheduler.PrintPrefix = "|cff99ffffInstance Scheduler|r - "
_G.BINDING_HEADER_INSTANCESCHEDULER = "Instance Scheduler"
_G.BINDING_NAME_SWITCHON = "Switch On"

InstanceScheduler.InGroupPlayer = ""
InstanceScheduler.TempTime = GetTime()
InstanceScheduler.InviteSchedulerTempTime = GetTime()
InstanceScheduler.InGroupTime = 0
InstanceScheduler.TempMembers = 0
InstanceScheduler.DifficultyID = { 3, 4, 5, 6, 14, 15 }

InstanceScheduler.AutoStart = true
InstanceScheduler.SavedInstances =
{
    "冰冠堡垒",
    "奥杜尔",
    "火焰之地",
    "风神王座",
    --"巨龙之魂",
    --"魔古山宝库",
    --"雷电王座",
    --"永春台",
    "黑翼血环",
    "决战奥格瑞玛",
    "安其拉神殿",
    "地狱火堡垒",
    "黑石铸造厂"
}
InstanceScheduler.Messages =
{
    AutoRepeat = "自动回复balabala...",

    AddInLine = "当前队伍里有其他人哦，已将您添加到队列，请耐心等待哦~~~",
    AlreadyInLine = "您已经加入队列了哦，当前排在第 %d 名，请耐心等待~~~",
    RemoveFromLine = "您已被移出了队列，感谢您的支持",
    NotInLine = "您当前不在队列中哦，M 我打 1 即可加入队列了哦",
    NetProblem = "很抱歉，由于某些不可抗力因素，已将您移除队伍，请尝试重新申请~~~",

    ResetComplete = "副本已重置，请进本~~~",
    ChangeDifficulty = "已将副本难度改为10人~~~",
    ChangeLeader = "已将队长转交，刷无敌请自行修改难度为英雄哦~~~",
    LeaveMessage = "其他副本请不要修改难度！！祝您刷出想要的坐骑~~~",
}
InstanceScheduler.Commands =
{
    CommandPrefix = "@进度号 ",

    InfoGreat = "优秀",
    InfoGood = "良好",
    InfoNotbad = "不错",
    InfoBad = "较差",
    InfoWorst = "极差",
    CommandInfo = "当前进度号本地延迟 %dms，世界延迟 %dms，FPS %d，状态%s。",

    CommandCheck = "当前队伍内有 %d 名玩家，其中 %d 名玩家进队时长超过 30 分钟， %d 名玩家离线",
    CommandCheckTime = "当前队伍中进队时长超过 30 分钟的有： ",
    CommandCheckOffline = "当前队伍中离线的玩家有： ",

    CommandKick = "成功发出移除玩家指令",

    CommandStart = "成功发出启动指令，请尝试使用“%sinfo”来确认是否启动成功",
    CommandStop = "成功发出停止指令，同时将不接收除“%sstart”以外的任何指令",

    CommandClose = "指令接收成功，将在 5 秒内关闭游戏。。。"
}
