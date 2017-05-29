--
-- Created by IntelliJ IDEA.
-- User: lenovo
-- Date: 2017/3/28
-- Time: 23:48
-- To change this template use File | Settings | File Templates.
--

InstanceScheduler.Status = InstanceScheduler.AutoStart
--InstanceScheduler.TempStatus = InstanceScheduler.Status

local frame = CreateFrame("Frame", "InstanceSchedulerFrame")

frame:SetScript("OnEvent", function(self, event, ...)
    InstanceScheduler[event] (self, ...)
end)

frame:RegisterEvent("VARIABLES_LOADED")
--frame:RegisterEvent("CHAT_MSG_GUILD")
