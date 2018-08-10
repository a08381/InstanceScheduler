--
-- Created by IntelliJ IDEA.
-- User: lenovo
-- Date: 2018/8/10
-- Time: 23:01
-- To change this template use File | Settings | File Templates.
--
local _, Addon = ...

local L = Addon.Locale
local M = Addon.Messages
local V = Addon.Variables

local GetMessageTable = function()
    local args = {}
    for k, v in pairs(M) do
        args[k] = v["name"]
    end
    return args
end

Addon["Option"] = {
    name = L["InstanceScheduler"],
    type = "group",
    args = {
        basic = {
            name = L["basic_option"],
            type = "group",
            childGroups = "tab",
            args = {
                enable = {
                    name = L["enable"],
                    type = "toggle",
                    set = function(info, val)
                        Addon:SwitchOn()
                    end,
                    get = function(info)
                        return V.Status
                    end
                },
                auto_start = {
                    name = L["auto_start"],
                    type = "toggle",
                    set = function(info, val)
                        V["AUTO_START"] = val
                    end,
                    get = function(info)
                        return V["AUTO_START"]
                    end
                },
                raid_settings = {
                    name = L["raid_setings"],
                    type = "group",
                    disabled = function(info)
                        return not V.Status
                    end,
                    args = {
                        extend = {
                            name = L["extend"],
                            type = "toggle",
                            set = function(info, val)
                                V.Extended = val
                            end,
                            get = function(info)
                                return V.Extended
                            end
                        },
                        only_extend = {
                            name = L["only_extend"],
                            type = "toggle",
                            hidden = function(info)
                                return not V.Extended
                            end,
                            set = function(info, val)
                                V.Extended_Only = val
                            end,
                            get = function(info)
                                return V.Extended_Only
                            end
                        }
                    }
                },
                other_setings = {
                    name = L["other_setings"],
                    type = "group",
                    disabled = function(info)
                        return not V.Status
                    end,
                    args = {
                        leave_time = {
                            name = L["leave_time"],
                            type = "range",
                            min = 20,
                            max = 120,
                            set = function(info, val)
                                V.LEAVE_TIME = val
                            end,
                            get = function(info)
                                return V.LEAVE_TIME
                            end
                        }
                    }
                }
            }
        },
        advanced = {
            name = L["advanced_option"],
            type = "group",
            childGroups = "tab",
            args = {
                message = {
                    name = L["message_select"],
                    type = "select",
                    style = "dropdown",
                    values = GetMessageTable()
                },
                key = {
                    name = L["message_key"],
                    type = "input",
                },
                response = {
                    name = L["message_response"],
                    type = "input"
                }
            }
        }
    }
}

