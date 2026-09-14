--[[
词典释义快捷上屏处理器 (dict_commit_processor.lua)

功能：
在输入拼音或英文时，挑选并选中候选词后：
按下快捷键（推荐：反斜杠 "\"、Ctrl+D、Ctrl+E 或 Ctrl+Shift+Return）：
将「当前高亮候选词 + 完整词典释义」一同上屏。

快捷键设计说明：
- 默认支持：
  1. \         (反斜杠键，无需按 Ctrl，在 L 键上滑或按 \ 即可将当前选中的词带释义上屏)
  2. Ctrl + D  (Dict 词典快捷键)
  3. Ctrl + E  (Explain 释义快捷键)
  4. Ctrl + Shift + Return (回车组合键)
- 支持在 schema 或 custom.yaml 中通过 `key_binder/dict_commit` 自定义任意按键。

示例：
- 选中「你好」按 \ -> 上屏「你好 (hello; hi; how are you)」
- 选中「apple」按 \ -> 上屏「apple (n. 苹果, 苹果树)」
--]]

local M = {}

local global_ecdict = nil
local global_cedict = nil

local function load_opencc_dict(name)
    local ok, obj = pcall(Opencc, name)
    if ok and obj then return obj end
    local ok2, obj2 = pcall(Opencc, "opencc/" .. name)
    if ok2 and obj2 then return obj2 end
    return nil
end

local function init_dicts()
    if not global_ecdict then global_ecdict = load_opencc_dict("ecdict.json") end
    if not global_cedict then global_cedict = load_opencc_dict("cedict.json") end
end

local function is_english(s)
    if not s or s == "" then return false end
    return s:match("^[%a%-%'%s%.%d]+$") ~= nil
end

local function lookup(opencc_obj, key)
    if not opencc_obj or not key or key == "" then return nil end
    -- 仅使用 convert_word 进行精确全词匹配（严禁使用 convert_text，以防分词匹配局部子词导致释义错误）
    local ok, res = pcall(function() return opencc_obj:convert_word(key) end)
    if ok and res then
        if type(res) == "table" and #res > 0 then
            local joined = table.concat(res, " ")
            if joined ~= key and joined ~= "" then
                return joined
            end
        elseif type(res) == "string" and res ~= key and res ~= "" then
            return res
        end
    end
    return nil
end

local function get_full_definition(text)
    if not text or text == "" then return nil end
    init_dicts()
    local full_def = nil
    if is_english(text) and global_ecdict then
        local lower = text:lower():gsub("^%s+", ""):gsub("%s+$", "")
        full_def = lookup(global_ecdict, lower) or lookup(global_ecdict, text)
    elseif global_cedict then
        local clean = text:gsub("^%s+", ""):gsub("%s+$", "")
        full_def = lookup(global_cedict, clean)
    end
    if full_def and full_def ~= "" then
        full_def = full_def:gsub("\194\160", " ")
        full_def = full_def:gsub("^[;%s]+", ""):gsub("[;%s]+$", "")
        return full_def
    end
    return nil
end

function M.init(env)
    init_dicts()
    local config = env.engine.schema.config
    -- 支持在 schema 中配置自定义快捷键，默认为 Control+d
    env.commit_key = config:get_string("key_binder/dict_commit") or "Control+d"
end

function M.func(key, env)
    local engine = env.engine
    local context = env.engine.context

    if not key:release() and (context:is_composing() or context:has_menu()) then
        local repr = key:repr()
        -- 匹配反斜杠 \, Ctrl+d, Ctrl+e, Ctrl+Shift+Return 以及自定义按键
        local is_match = (repr == env.commit_key)
            or (repr == "backslash")
            or (repr == "\\")
            or (repr == "Control+d")
            or (repr == "Control+D")
            or (repr == "Control+e")
            or (repr == "Control+E")
            or (repr == "Control+Shift+Return")
            or (repr == "Control+Shift+KP_Enter")

        if is_match then
            local cand = context:get_selected_candidate()
            local text = cand and cand.text or context.input

            if text and text ~= "" then
                local def = get_full_definition(text)
                if def and def ~= "" then
                    engine:commit_text(text .. " (" .. def .. ")")
                else
                    engine:commit_text(text)
                end
                context:clear()
                return 1 -- kAccepted
            end
        end
    end

    return 2 -- kNoop
end

return M
