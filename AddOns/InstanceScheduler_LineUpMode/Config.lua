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
InstanceScheduler.DifficultyID = { 3, 4, 5, 6, 9, 14, 15 }

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
    "黑暗神殿",
    "安其拉神殿",
    "地狱火堡垒",
    "黑石铸造厂"
}
InstanceScheduler.Messages =
{
    AutoRepeat = "本插件完全免费，任何兜售免费CD宏的都是骗子",
    Menu = [[
    到本密 1 ，排队等我组你
    取消排队密 0
    查询副本清单密 5
    查询副本坐标密 6
    查询各副本注意事项密 7
    ]],
    InstanceList = [[
    黑暗神殿【蛋刀】“利用时光BUG，我们暂时可以提供这个CD了，请密7查看这个CD的注意事项。
    冰冠堡垒【无敌】
    奥杜尔【飞机头】
    风神王座【南风幼龙】
    火焰之地【鹿盔】
    巨龙之魂CD处于BUG状态，暂停提供，待BLZ修复
    魔古宝库CD处于BUG状态，暂停提供，待BLZ修复
    雷神王座CD处于BUG状态，暂停提供，待BLZ修复
    永春台CD处于BUG状态，暂停提供，待BLZ修复
    决战奥格【傲之煞房间】谜语人坐骑步骤、【H小吼CD】（需进组后队伍频道打YX10，然后进本）
    黑翼血环【能量洪流】FM幻象
    黑石铸造厂【黑石之印】FM幻象
    地狱火堡垒【血环之印】FM幻象
    需求【决战奥格：索克】请寻求其他特殊CD君提供！
    ]],
    InstanceLocation = [[
    黑暗神殿【外域-影月谷 71,46】
    冰冠堡垒【冰冠冰川 53,85】
    奥杜尔【风暴峭壁 42,18】
    风神王座【奥丹姆 39,80】
    火焰之地【海加尔山 48,78】
    决战奥格【锦绣谷 72,45】
    黑翼血环【燃烧平原 25,25】
    黑石铸造厂【戈尔德隆 51,28】
    地狱火堡垒【塔纳安丛林 45,53】
    以上副本入口坐标经本人亲自勘测，真实有效，部分地区坐标需准确到所在地
    ]],
    Advice = [[
    冰冠堡垒必须染25人难度，其他副本可以队伍频道打 10 切10人难度，不影响坐骑掉率。
    冰冠堡垒必须25人普通难度进本，进本后得到队长，自己切25H难度！（插件版可使用H按钮）
    奥杜尔现在10人难度就掉坐骑，注意不能和任何守护者对话！
    风神王座、火源之地、巨龙之魂、黑翼血环不能切H难度！
    【H小吼CD】需进组后队伍频道打YX10，然后进本（插件版可使用H按钮）
    安其拉神殿进去从头走一圈到克苏恩房间，完成“清醒的梦魇”坐骑步骤
    由于7.35更新后，魔古山宝库、雷神王座、永春台、巨龙之魂的CD有BUG，应急版暂停供应此4个副本的CD！
    暂时新增蛋刀CD，因为目前有BUG可以染这个CD，提供到BLZ修复这个BUG为止，进本传送之后，和阿卡玛对话，你会被BOSS战围栏挡住，请等待脱战重新对话，即可正常进去刷蛋刀了！
    ]],
    AddInLine = [[
    您已经加入队列了哦，当前排在第 %d 名，请耐心等待~~~
    本插件完全免费，任何兜售免费CD宏的都是骗子
    ]],
    AlreadyInLine = [[
    您已经加入队列了哦，当前排在第 %d 名，请耐心等待~~~
    本插件完全免费，任何兜售免费CD宏的都是骗子
    ]],

    RemoveFromLine = "您已被移出了队列，感谢您的支持",
    NotInLine = "您当前不在队列中哦，M 我打 1 即可加入队列了哦",
    NetProblem = "很抱歉，由于某些不可抗力因素，已将您移除队伍，请尝试重新申请~~~",

    ResetComplete = "副本已重置，请进本~~~",
    ChangeDifficulty = "副本难度已修改~~~",
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
