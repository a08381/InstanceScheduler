--
-- Created by IntelliJ IDEA.
-- User: lenovo
-- Date: 2017/3/28
-- Time: 23:48
-- To change this template use File | Settings | File Templates.
--

local Addon = _G["InstanceScheduler"]

Addon.AutoStart = true
Addon.TempTime = GetTime()
Addon.Keywords =
{
    LK = {"HLK", "无敌", "巫妖王", "冰冠"},
    ULD = {"ULD", "奥杜尔", "飞机头", "米米尔隆", "萨隆", "傻龙"},
    FL = {"火源", "火焰之地", "火乌鸦", "火鹰", "拉格纳罗斯", "大螺丝"},
    DS = {"DS", "龙魂", "死亡之翼", "大下巴"},
    MGS = {"魔古山", "伊拉贡", "星光龙"},
    TOT = {"雷电", "季鹍"}
}
Addon.Repeats =
{
    DEFAULT = "需要副本CD的注意啦！直接在副本门口M我打1即可！发送副本关键字即可获得更详细的信息！\n龙魂，决战奥格，火源只能染普通，要刷英雄或史诗难度的请自行从头打",
    LK = "M我打1进本后，上楼将鲜血女王击杀，染到CD后退组，出本自行将难度改为25人普通，然后进本改英雄即可",
    ULD = "M我打1进本后，将熔炉BOSS击杀，染到CD后退组，出本自行将难度改为25人普通，然后进本击杀尤格萨隆即可",
    FL = "M我打1进本后直接击杀BOSS即可",
    DS = "由于老七比较麻烦就击杀了，请先自行打到老五然后出本M我打1进组",
    MGS = "M我打1进本后直接击杀BOSS即可",
    TOT = "请先自行击杀老二之后出本M我打1进组获取季鹍进度"
}
Addon.Messages =
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