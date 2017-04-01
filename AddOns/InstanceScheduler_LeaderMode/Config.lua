--
-- Created by IntelliJ IDEA.
-- User: lenovo
-- Date: 2017/3/28
-- Time: 23:48
-- To change this template use File | Settings | File Templates.
--

InstanceScheduler.PrintPrefix = "|cff99ffffInstance Schedule|r - "
InstanceScheduler.AutoStart = true
InstanceScheduler.TempTime = GetTime()
InstanceScheduler.Keywords =
{
    LK = {"HLK", "无敌", "巫妖王", "冰冠"},
    ULD = {"ULD", "奥杜尔", "飞机头", "米米尔隆", "萨隆", "傻龙"},
    FL = {"火源", "火焰之地", "火乌鸦", "火鹰", "拉格纳罗斯", "大螺丝"},
    DS = {"DS", "龙魂", "死亡之翼", "大下巴" },
    MGS = {"魔古山", "伊拉贡", "星光龙"},
    TOT = {"雷电", "季鹍"}
}
InstanceScheduler.Repeats =
{
    DEFAULT = "需要副本CD的注意啦！直接在副本门口M我1即可！发送副本关键字即可获得更详细的信息！",
    LK = "进本后，上楼将鲜血女王击杀，染到CD后退组，出本自行将难度改为25人普通，然后进本改英雄即可",
    ULD = "进本后，将熔炉BOSS击杀，染到CD后退组，出本自行将难度改为25人普通，然后进本击杀尤格萨隆即可",
    FL = "进本后直接击杀BOSS即可",
    DS = "由于老七比较麻烦就击杀了，请先自行打到老五然后出本进组",
    MGS = "进本后直接击杀BOSS即可",
    TOT = "请先自行击杀老二之后进组获取季鹍进度"
}
InstanceScheduler.Messages =
{
    AddBlacklistSuccess = "成功将玩家添加到黑名单",
    AlreadyInBlacklist = "这名玩家已经在黑名单里了",
    RemoveBlacklistSuccess = "成功将玩家移出黑名单",
    NotInBlacklist = "这名玩家并不在在黑名单里",
    ListBlacklist = "当前黑名单中共有 %d 名玩家：",
    BlacklistFormat = "%d、 %s",
    GroupWelcome = "副本已重置，请进本，进本后请在小队频道里发1~~~",
    ChangeLeader = "已将队长转交，刷无敌请自行修改难度为英雄，修改难度完毕或确认后请打1~~~",
    Finish = "服务完成~~祝您刷出想要的坐骑~~~",
}