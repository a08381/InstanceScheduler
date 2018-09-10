--
-- Created by IntelliJ IDEA.
-- User: lenovo
-- Date: 2018/8/9
-- Time: 21:22
-- To change this template use File | Settings | File Templates.
--
local _, Addon = ...

Addon.Locale = {}
Addon.Messages = { Extras = {} }

local L = Addon.Locale
local M = Addon.Messages
local E = M["Extras"]

L["InstanceScheduler"] = "副本进度共享"
L["PrintPrefix"] = "cff99ffff副本进度共享|r - "

L["SwitchOn"] = "已启用"
L["SwitchOff"] = "已禁用"

L["basic_option"] = "基本设置"
L["enable"] = "启用"
L["auto_start"] = "自动启动"
L["raid_setings"] = "副本设置"
L["extend"] = "延长副本"
L["only_extend"] = "仅延长"
L["other_setings"] = "其他设置"
L["leave_time"] = "等待进本时长"
L["advanced_option"] = "进阶设置"
L["message_option"] = "回复设置"
L["message_key"] = "关键字"
L["message_response"] = "消息回复"

_G["BINDING_HEADER_INSTANCESCHEDULER"] = "副本进度共享"
_G["BINDING_NAME_SWITCHON"] = "切换 开/关"

M["AutoResponse"] = {
    name = "自动回复",
    response = [[
    本插件完全免费，任何兜售免费CD宏的都是骗子
    ]]
}
M["InLine"] = {
    name = "队列加入",
    key = "1",
    response = [[
    您已经加入队列了哦，当前排在第 %d 名，请耐心等待~~~
    本插件完全免费，任何兜售免费CD宏的都是骗子
    ]]
}
M["WaitPortal"] = {
    name = "等待开门",
    key = "4",
    response = [[
    您已加入了队列~~ 请稍等，CD姬很快就会来组你啦~~
    ]]
}
M["InstanceProblem"] = {
    name = "副本问题",
    response = [[
    非常抱歉，在BLZ的某次系统更新后，巨龙之魂、雷电王座、永春台、魔古山宝库这四个副本暂时无法染CD
    为了防止您的CD被黑，已将您移出队伍，给您造成的不便敬请谅解
    ]]
}
M["RemoveFromLine"] = {
    name = "队列移除",
    key = "0",
    response = [[
    您已被移出了队列，感谢您的支持
    ]]
}
M["NetProblem"] = {
    name = "网络故障",
    response = [[
    很抱歉，由于某些不可抗力因素，已将您移除队伍，请尝试重新申请~~~
    ]]
}
M["ResetComplete"] = {
    name = "重置完毕",
    response = [[
    副本已重置，请进本~~~
    ]]
}
M["ChangeDifficulty"] = {
    name = "人数变更",
    key = "10",
    response = [[
    副本难度已修改至10人~~~
    ]]
}
M["ChangeHero"] = {
    name = "难度变更",
    key = "yx",
    response = [[
    副本难度已修改至英雄~~~
    ]]
}
M["ChangeLeader"] = {
    name = "转交队长",
    response = [[
    已将队长转交，刷无敌请自行修改难度为英雄哦~~~
    ]]
}
M["Leave"] = {
    name = "离开队伍",
    response = [[
    其他副本请不要修改难度！！祝您刷出想要的坐骑~~~
    ]]
}
M["InBlacklist"] = {
    name = "在黑名单",
    response = [[
    您因为违规操作已被禁止使用本CD号 %s 秒，希望您能素质使用
    ]]
}
E["Menu"] = {
    name = "副本进度菜单",
    key = "3",
    response = [[
    到本密 1 ，排队等我组你
    取消排队密 0
    查询副本清单密 5
    查询副本坐标密 6
    查询各副本注意事项密 7
    ]]
}
E["InstanceList"] = {
    name = "副本列表",
    key = "5",
    response = [[
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
    ]]
}
E["InstanceLocation"] = {
    name = "副本坐标",
    key = "6",
    response = [[
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
    ]]
}
E["Advice"] = {
    name = "注意事项",
    key = "7",
    response = [[
    冰冠堡垒必须染25人难度，其他副本可以队伍频道打 10 切10人难度，不影响坐骑掉率。
    冰冠堡垒必须25人普通难度进本，进本后得到队长，自己切25H难度！（插件版可使用H按钮）
    奥杜尔现在10人难度就掉坐骑，注意不能和任何守护者对话！
    风神王座、火源之地、巨龙之魂、黑翼血环不能切H难度！
    【H小吼CD】需进组后队伍频道打YX10，然后进本（插件版可使用H按钮）
    安其拉神殿进去从头走一圈到克苏恩房间，完成“清醒的梦魇”坐骑步骤
    由于7.35更新后，魔古山宝库、雷神王座、永春台、巨龙之魂的CD有BUG，应急版暂停供应此4个副本的CD！
    暂时新增蛋刀CD，因为目前有BUG可以染这个CD，提供到BLZ修复这个BUG为止，进本传送之后，和阿卡玛对话，你会被BOSS战围栏挡住，请等待脱战重新对话，即可正常进去刷蛋刀了！
    ]]
}
