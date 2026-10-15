-- Renkei's original UI, GPL-3.0-or-later. 2026-10-13.
local imgui = require('imgui');
local M = {};
local gold = {0.95, 0.84, 0.57, 1};
local muted = {0.66, 0.75, 0.90, 1};

function M.push()
    local colors = {
        {ImGuiCol_WindowBg, {0.025, 0.055, 0.22, 0.97}},
        {ImGuiCol_Border, {0.70, 0.77, 0.91, 1}},
        {ImGuiCol_Text, {0.94, 0.96, 1, 1}},
        {ImGuiCol_Separator, {0.48, 0.59, 0.81, 0.70}},
        {ImGuiCol_FrameBg, {0.015, 0.028, 0.10, 1}},
        {ImGuiCol_TitleBg, {0.06, 0.12, 0.34, 1}},
        {ImGuiCol_TitleBgActive, {0.10, 0.20, 0.47, 1}},
        {ImGuiCol_Button, {0.12, 0.23, 0.48, 1}},
        {ImGuiCol_ButtonHovered, {0.22, 0.39, 0.67, 1}},
        {ImGuiCol_ButtonActive, {0.18, 0.32, 0.56, 1}},
        {ImGuiCol_CheckMark, gold},
        {ImGuiCol_SliderGrab, gold},
    };
    for _, v in ipairs(colors) do imgui.PushStyleColor(v[1], v[2]); end
    imgui.PushStyleVar(ImGuiStyleVar_WindowRounding, 6);
    imgui.PushStyleVar(ImGuiStyleVar_WindowBorderSize, 2);
    imgui.PushStyleVar(ImGuiStyleVar_WindowPadding, {16, 12});
    imgui.PushStyleVar(ImGuiStyleVar_ItemSpacing, {8, 5});
end

function M.pop()
    imgui.PopStyleVar(4);
    imgui.PopStyleColor(12);
end

local function originalFrame()
    local x, y = imgui.GetWindowPos();
    local w, h = imgui.GetWindowSize();
    local dl = imgui.GetWindowDrawList();
    -- ImGui packed colors use AABBGGRR. Draw before content, inside the border.
    dl:AddRectFilledMultiColor({x+4,y+4}, {x+w-4,y+h-4},
        0xFA6B3516, 0xFA55250C, 0xFA220A03, 0xFA300E04);
    dl:AddRect({x+4,y+4}, {x+w-4,y+h-4}, 0xFF8D7561, 3, 0, 1);
end

local reveal = 1;
local clipped = false;
local function faded(color, opacity)
    local alpha = math.floor(color / 16777216);
    return color % 16777216 + math.floor(alpha * opacity) * 16777216;
end

-- Start as a small square, then settle into the panel's final proportions.
local function bounds(x,y,w,h,amount)
    local side = math.min(w-8,h-8);
    local shape = amount*amount*amount;
    local rw = (side+(w-8-side)*shape)*amount;
    local rh = (side+(h-8-side)*shape)*amount;
    return {x+(w-rw)/2,y+(h-rh)/2}, {x+(w+rw)/2,y+(h+rh)/2};
end

function M.frame()
    if reveal >= 1 then originalFrame(); return; end
    local x,y = imgui.GetWindowPos();
    local w,h = imgui.GetWindowSize();
    local dl = imgui.GetWindowDrawList();
    -- A faint larger box leads the solid panel, like the native menu zoom.
    if reveal>0 and reveal<1 then
        local a,b = bounds(x,y,w,h,math.min(1,reveal+0.20));
        local opacity = (1-reveal)*math.min(1,reveal*8)*0.45;
        dl:AddRectFilledMultiColor(a,b,faded(0xFA6B3516,opacity),faded(0xFA55250C,opacity),
            faded(0xFA220A03,opacity),faded(0xFA300E04,opacity));
        dl:AddRect(a,b,faded(0xFF8D7561,opacity),0,0,1);
    end
    local a,b = bounds(x,y,w,h,reveal);
    local opacity = math.min(1,reveal*5);
    dl:AddRectFilledMultiColor(a,b,faded(0xFA6B3516,opacity),faded(0xFA55250C,opacity),
        faded(0xFA220A03,opacity),faded(0xFA300E04,opacity));
    dl:AddRect(a,b,faded(0xFF8D7561,opacity),3*reveal,0,1);
end

function M.beginReveal(amount)
    reveal = amount;
    M.frame();
    clipped = reveal < 1;
    if not clipped then return; end
    local x,y = imgui.GetWindowPos();
    local w,h = imgui.GetWindowSize();
    local a,b = bounds(x,y,w,h,reveal);
    imgui.PushClipRect(a,b,true);
end

function M.endReveal()
    if clipped then imgui.PopClipRect(); end
    clipped = false;
    reveal = 1;
end

-- Fixed compact width, independent of long action names or help text.
function M.width(entry, groups, textWidth, scale)
    return 320 * (scale or 1);
end

local function wrapped(color, text)
    imgui.PushStyleColor(ImGuiCol_Text, color);
    imgui.TextWrapped(text);
    imgui.PopStyleColor();
end

function M.draw(entry, groups, options)
    imgui.TextColored(gold, 'R E N K E I');
    imgui.SameLine();
    imgui.TextColored(muted, options.preview and ' /  PREVIEW' or ' /  SKILLCHAINS');
    imgui.Separator();
    wrapped(muted, options.targetName or 'Current target');

    local elapsed = math.max(0, options.now - entry.ts);
    local remaining = math.max(0, entry.dur - elapsed);
    local waiting = elapsed < entry.wait;
    local label, tint, fraction;
    if entry.closed then
        label, tint, fraction = 'CHAIN COMPLETE', gold, remaining / math.max(entry.dur, 0.01);
    elseif waiting then
        label, tint, fraction = 'WAIT', {1, 0.72, 0.32, 1}, (entry.wait-elapsed)/math.max(entry.wait, 0.01);
    else
        label, tint, fraction = 'CHAIN WINDOW', {0.40, 0.92, 0.73, 1}, remaining/math.max(entry.dur-entry.wait, 0.01);
    end
    imgui.TextColored(tint, label);
    if not entry.closed then
        imgui.SameLine();
        imgui.Text(('  %.1fs'):format(waiting and entry.wait-elapsed or remaining));
    end
    imgui.PushStyleColor(ImGuiCol_PlotHistogram, tint);
    imgui.ProgressBar(math.max(0, math.min(1, fraction)), {-1, 7}, '');
    imgui.PopStyleColor();
    imgui.TextWrapped(('STEP %d   /   %s'):format(entry.step, entry.en));

    local function properties()
        if entry.bound then
            imgui.TextColored(gold, ('Chainbound Lv.%d'):format(entry.bound));
            return;
        end
        local used = 0;
        for i, property in ipairs(entry.property) do
            local width = options.textWidth(property);
            if i > 1 and used + width + 24 < imgui.GetWindowWidth() - 32 then
                imgui.SameLine(); imgui.TextColored(muted, '/'); imgui.SameLine();
                used = used + 24;
            else used = 0; end
            used = used + width;
            imgui.TextColored(options.color(property), property);
        end
    end
    properties();
    if entry.step > 1 and options.burst then
        imgui.TextColored(gold, 'BURST ELEMENTS');
        local used = 0;
        for i, element in ipairs(options.burst) do
            local width = options.textWidth(element);
            if i > 1 and used + width + 24 < imgui.GetWindowWidth() - 32 then
                imgui.SameLine(); imgui.TextColored(muted, '/'); imgui.SameLine();
                used = used + 24;
            else used = 0; end
            used = used + width;
            imgui.TextColored(options.color(element), element);
        end
    end
    imgui.Separator();

    if entry.closed then
        wrapped(muted, 'No further skillchain extension.');
    else
        local count = 0;
        for _, section in ipairs({{'WEAPON SKILLS', groups.weapon}, {'SPELLS', groups.spell}, {'PET ABILITIES', groups.pet}}) do
            if #section[2] > 0 then
                imgui.Spacing();
                imgui.TextColored(gold, section[1]);
                for _, row in ipairs(section[2]) do
                    local name = row.outName:gsub('%s+$', '');
                    wrapped(row.ready and {0.94,0.96,1,1} or muted, name);
                    local result = row.outText:gsub('>> ', '') .. '  ' .. row.outProp;
                    local resultWidth = options.textWidth(result);
                    if options.textWidth(name) + resultWidth + 12 <= imgui.GetWindowWidth() - 32 then
                        imgui.SameLine(imgui.GetWindowWidth() - 16 - resultWidth);
                    end
                    wrapped(options.color(row.outProp), result);
                    count = count + 1;
                end
            end
        end
        if count == 0 then wrapped(muted, 'No matching follow-ups available.'); end
    end
    imgui.Spacing();
    imgui.Separator();
    wrapped(muted, options.preview and 'Drag to move | /renkei to close'
        or 'Normal TP / ability costs apply.');
end

return M;
