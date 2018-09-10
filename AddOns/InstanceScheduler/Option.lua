--
-- Created by IntelliJ IDEA.
-- User: lenovo
-- Date: 2018/8/10
-- Time: 23:01
-- To change this template use File | Settings | File Templates.
--
local _, Addon = ...

setfenv(1, Addon)

function Util:GetMessageTable()
    local args = {}
    for k, v in pairs(Messages) do
        if k ~= "Extras" then
            args[k] = {
                name = v.name,
                type = "group",
                args = {
                    key = {
                        name = Locale["message_key"],
                        type = "input",
                        hidden = function(info)
                            return not v.key
                        end,
                        get = function(info)
                            return v.key
                        end,
                        set = function(info, val)
                            v.key = val
                        end
                    },
                    response = {
                        name = Locale["message_response"],
                        type = "input",
                        width = "full",
                        multiline = true,
                        get = function(info)
                            return v.response
                        end,
                        set = function(info, val)
                            v.response = val
                        end
                    }
                }
            }
        else
            for n, t in pairs(v) do
                args[n] = {
                    name = t.name,
                    type = "group",
                    args = {
                        key = {
                            name = Locale["message_key"],
                            type = "input",
                            hidden = function(info)
                                return not t.key
                            end,
                            get = function(info)
                                return t.key
                            end,
                            set = function(info, val)
                                t.key = val
                            end
                        },
                        response = {
                            name = Locale["message_response"],
                            type = "input",
                            width = "full",
                            multiline = true,
                            get = function(info)
                                return t.response
                            end,
                            set = function(info, val)
                                t.response = val
                            end
                        }
                    }
                }
            end
        end
    end
    return args
end

Option = {
    name = Locale["InstanceScheduler"],
    type = "group",
    args = {
        basic = {
            name = Locale["basic_option"],
            type = "group",
            childGroups = "tab",
            args = {
                ["1"] = {
                    name = Locale["enable"],
                    type = "toggle",
                    set = function(info, val)
                        Util:SwitchOn()
                    end,
                    get = function(info)
                        return Variables.Status
                    end
                },
                ["2"] = {
                    name = Locale["auto_start"],
                    type = "toggle",
                    set = function(info, val)
                        SavedVariables.AUTO_START = val
                    end,
                    get = function(info)
                        return SavedVariables.AUTO_START
                    end
                },
                ["3"] = {
                    name = Locale["raid_setings"],
                    type = "group",
                    args = {
                        ["1"] = {
                            name = Locale["extend"],
                            type = "toggle",
                            disabled = function(info)
                                return not Variables.Status
                            end,
                            set = function(info, val)
                                SavedVariables.Extended = val
                            end,
                            get = function(info)
                                return SavedVariables.Extended
                            end
                        },
                        ["2"] = {
                            name = Locale["only_extend"],
                            type = "toggle",
                            disabled = function(info)
                                return not Variables.Status
                            end,
                            hidden = function(info)
                                return not SavedVariables.Extended
                            end,
                            set = function(info, val)
                                SavedVariables.Extended_Only = val
                            end,
                            get = function(info)
                                return SavedVariables.Extended_Only
                            end
                        }
                    }
                },
                ["4"] = {
                    name = Locale["other_setings"],
                    type = "group",
                    args = {
                        leave_time = {
                            name = Locale["leave_time"],
                            type = "range",
                            disabled = function(info)
                                return not Variables.Status
                            end,
                            min = 10,
                            max = 120,
                            bigStep = 5,
                            set = function(info, val)
                                SavedVariables.LEAVE_TIME = val
                            end,
                            get = function(info)
                                return SavedVariables.LEAVE_TIME
                            end
                        }
                    }
                }
            }
        },
        message = {
            name = Locale["message_option"],
            type = "group",
            args = nil
        },
        advanced = {
            name = Locale["advanced_option"],
            type = "group",
            childGroups = "tab",
            args = {}
        }
    }
}

