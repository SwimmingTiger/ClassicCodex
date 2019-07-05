CodexMap = CreateFrame("Frame")
CodexMap.HBDP = LibStub("HereBeDragons-Pins-2.0")
CodexMap.HBD = LibStub("HereBeDragons-2.0")
CodexMap.nodes = {}
CodexMap.markers = {}
CodexMap.minimapMarkers = {}

CodexMap.targetList = {}
CodexMap.colorList = {
	[1] = {0.901, 0.098, 0.294}, --redish
	[2] = {0.235, 0.705, 0.294}, --Light Green
	[3] = {1, 0.882, 0.098}, --yellow
	[4] = {0, 0.509, 0.784}, --blue
	[5] = {0.960, 0.509, 0.188}, --orange
	[6] = {0.568, 0.117, 0.705}, --purple
	[7] = {0.274, 0.941, 0.941}, --cyan
	[8] = {0.941, 0.196, 0.901}, --magenta
	[9] = {0, 1, 0}, --neon green
	[10] = {1, 0, 0}, --neon red
	[11] = {0, 0.501, 0.501}, --teal
	[12] = {0, 0.1, 1}, --neon blue
	[13] = {0.666, 0.431, 0.156}, --brown
	[14] = {0.4, 0, 0.4}, -- dark purple
	[15] = {0.501, 0, 0}, --maroon
	[16] = {0.666, 1, 0.764}, --mint
	[17] = {0.521, 0.266, 0.258}, --cappuccino
	[18] = {1, 0.843, 0.705}, --apricot
	[19] = {0, 0, 0.501}, --navy
	[20] = {0.501, 0.501, 0.501}, --grey
	[21] = {1, 1, 1}, --white
	[22] = {0, 0, 0}, --black
}

CodexMap.zones = {
    [1426] = 1, --Dun Morogh
	[1418] = 3, --Badlands
	[1419] = 4, --Blasted Lands
	[1435] = 8, --Swamp of Sorrows
	[1431] = 10, --Duskwood
	[1437] = 11, --Wetlands
	[1429] = 12, --Elwynn Forest
	[1411] = 14, --Durotar
	[1445] = 15, --Dustwallow Marsh
	[1447] = 16, --Azshara
	[1413] = 17, --The Barrens
	[1422] = 28, --Western Plaguelands
	[1434] = 33, --Stranglethorn Vale
	[1416] = 36, --Alterac Mountains
	[1432] = 38, --Loch Modan
	[1436] = 40, --Westfall
	[1430] = 41, --Deadwind Pass
	[1433] = 44, --Redridge Mountains
	[1417] = 45, --Arathi Highlands
	[1428] = 46, --Burning Steppes
	[1425] = 47, --The Hinterlands
	[1427] = 51, --Searing Gorge
	[1433] = 69, --Lakeshire
	[1420] = 85, --Tirisfal Glades
	[1421] = 130, --Silverpine Forest
	[1423] = 139, --Eastern Plaguelands
	[1438] = 141, --Teldrassil
	[1439] = 148, --Darkshore
	[1412] = 215, --Mulgore
	[1424] = 267, --Hillsbrad Foothills
	[1440] = 331, --Ashenval
	[1444] = 357, --Feralas
	[1448] = 361, --Felwood
	[1441] = 400, --Thousand Needles
	[1443] = 405, --Desolace
	[1442] = 406, --Stonetalon Mountains
	[1446] = 440, --Tanaris
	[1449] = 490, --Un'Goro Crater
	[1450] = 493, --Moonglade
	[1452] = 618, --Winterspring
	[1451] = 1377, --Silithus
	[1458] = 1497, --Undercity
	[1453] = 1519, --Stormwind City
	[1455] = 1537, --Ironforge
	[1454] = 1637, --Orgrimmar
	[1456] = 1638, --Thunder Bluff
	[1457] = 1657, --Darnassus
	[1459] = 2597, --Alterac Valley
	[1460] = 3277, --Warsong Gulch
	[1461] = 3358, --Arathi Basin
}

local function isEmpty(tabl)
	for key, value in pairs(tabl) do
		return false
	end
	return true
end

function CodexMap:GetTooltipColor(min, max)
	local perc = min / max
	local r1, g1, b1, r2, g2, b2
	if perc <= 0.5 then
		perc = perc * 2
		r1, g1, b2 = 1, 0, 0
		r2, g2, b2 = 1, 1, 0
	else
		perc = perc * 2 - 1
		r1, g1, b1 = 1, 1, 0
		r2, g2, b2 = 0, 1, 0
	end
	r = r1 + (r2 - r1) * perc
	g = g1 + (g2 - g1) * perc
	b = b1 + (b2 - b1) * perc
	
	return r, g, b
end

function CodexMap:ShowTooltip(meta, tooltip)
	local catch = nil
	local tooltip = tooltip or GameTooltip

	-- Add quest data
	if meta["quest"] then
		-- scan all quest entries for matches
		for questId = 1, GetNumQuestLogEntries() do
			local title, _, _, _, _, complete = GetQuestLogTitle(questId)

			if meta["quest"] == title then
				local objectives = GetNumQuestLeaderBoards(questId)
				catch = true

				local symbol = (complete or objectives == 0) and "|cff555555[|cffffcc00?|cff555555]|r " or "|cff555555[|cffffcc00!|cff555555]|r "
				tooltip:AddLine(symbol .. meta["quest"], 1, 1, 0)

				local foundObjective = nil
				if objectives then
					for i = 1, objectives do
						local text, type, complete = GetQuestLogLeaderBoard(i, questId)

						if type == "monster" then
							-- kill
							local _, _, monsterName, objNum, objNeeded = strfind(text, CodexUI:SanitizePattern(QUEST_MONSTERS_KILLED))
							if meta["spawn"] == monsterName then
								foundObjective = true
								local r, g, b = CodexMap:GetTooltipColor(objNum, objNeeded)
								tooltip:AddLine("|cffaaaaaa- |r" .. monsterName .. ": " .. objNum .. "/" .. objNeeded, r, g, b)
							end
						elseif table.getn(meta["item"]) > 0 and type == "item" and meta["dropRate"] then
							-- Loot
							local _, _, itemName, objNum, objNeeded = strfind(text, CodexUI:SanitizePattern(QUEST_OBJECTS_FOUND))

							for _, item in pairs(meta["item"]) do
								if item == itemName then
									foundObjective = true
									local r, g, b = CodexMap:GetTooltipColor(objNum, objNeeded)
									local dr, dg, db = CodexMap:GetTooltipColor(tonumber(meta["dropRate"]), 100)
									local lootColor = string.format("%02x%02x%02x", dr * 255,dg * 255, db * 255)
									tooltip:AddLine("|cffaaaaaa- |r" .. itemName .. ": " .. objNum .. "/" .. objNeeded .. " |cff555555[|cff" .. lootColor .. meta["dropRate"] .. "%|cff555555]", r, g, b)
								end
							end
						elseif table.getn(meta["item"]) > 0 and type == "item" and meta["sellCount"] then
							-- Vendor
							local _, _, itemName, objNum, objNeeded = strfind(text, CodexUI:SanitizePattern(QUEST_OBJECTS_FOUND))

							for _, item in pairs(meta["item"]) do
								if item == itemName then
									foundObjective = true
									local r, g, b = CodexMap:GetTooltipColor(objNum, objNeeded)
									local sellCount = tonumber(meta["sellCount"]) > 0 and " |cff555555[|cffcccccc" .. meta["sellCount"] .. "x" .. "|cff555555]" or ""
									tooltip:AddLine("|cffaaaaaa- |cffffffff" .. "Buy" .. ": |r" .. itemName .. ": " .. objNum .. "/" .. objNeeded .. sellCount, r, g, b)
								end
							end
						end
					end
				end

				if not foundObjective and meta["questLevel"] and meta["texture"] then
					local questLevelString = "Level: " .. meta["questLevel"]
					local questMinString = meta["questMinimumLevel"] and " / Required: " .. meta["questMinimumLevel"] or ""
					tooltip:AddLine("|cffaaaaaa- |r" .. questLevelString .. questMinString , .8,.8,.8)
				end
			end
		end

		if not catch then
			local catchFallback = nil
			tooltip:AddLine("|cff555555[|cffffcc00!|cff555555]|r " .. meta["quest"], 1, 1, .7)

			if meta["item"] and meta["item"][1] and meta["dropRate"] then
				for _, item in pairs(meta["item"]) do
					catchFallback = true
					local dr, dg, db = CodexMap:GetTooltipColor(tonumber(meta["dropRate"]), 100)
					local lootColor = string.format("%02x%02x%02x", dr * 255,dg * 255, db * 255)
					tooltip:AddLine("|cffaaaaaa- |r" .. "Loot: " .. item .. " |cff555555[|cff" .. lootColor .. meta["dropRate"] .. "%|cff555555]", 1, .5, .5)
				end
			end

			if not catchFallback and meta["spawn"] and not meta["texture"] then
				catchFallback = true
				tooltip:AddLine("|cffaaaaaa- |r" .. "Kill: " .. meta["spawn"], 1,.5,.5)
			end

			if not catchFallback and meta["texture"] and meta["questLevel"] then
				local questLevelString = "Level: " .. meta["questLevel"] .. "|r"
				local questMinString = meta["questMinimumLevel"] and " / " .. "Required: " .. meta["questMinimumLevel"] .. "|r" or ""
				tooltip:AddLine("|cffaaaaaa- |r" .. questLevelString .. questMinString , .8,.8,.8)
			end
		end
	else
		if meta["item"][1] and meta["itemId"] and not meta["itemLink"] then
			local _, _, itemQuality = GetItemInfo(meta["itemId"])
			if itemQuality then
				local itemColor = "|c" .. string.format("%02x%02x%02x%02x", 255,
				ITEM_QUALITY_COLORS[itemQuality].r * 255,
				ITEM_QUALITY_COLORS[itemQuality].g * 255,
				ITEM_QUALITY_COLORS[itemQuality].b * 255)

			meta["itemLink"] = itemColor .. "|Hitem:" .. meta["itemId"] .. ":0:0:0|h[" .. meta["item"][1] .. "]h|r"
			end
		end

		if meta["sellCount"] then
			local item = meta["itemLink"] or "[" .. meta["item"][1] .. "]"
			local sellCount = tonumber(meta["sellCount"]) > 0 and  " |cff555555[|cffcccccc" .. meta["sellCount"] .. "x" .. "|cff555555]" or ""
			tooltip:AddLine("Vendor: " .. item .. sellCount, 1, 1, 1)
		elseif meta["item"][1] then
			local item = meta["itemLink"] or "[" .. meta["item"][1] .. "]"
			local r, g, b = CodexMap:GetTooltipColor(tonumber(meta["dropRate"]), 100)
			tooltip:AddLine("|cffffffffLoot: " .. item ..  " |cff555555[|r" .. meta["dropRate"] .. "%|cff555555]", r,g,b)
		end
	end

	tooltip:Show()
end

function CodexMap:AddNode(meta)
	local addon = meta["addon"] or "CODEX"
	local map = meta["zone"]
	local x = meta["x"]
	local y = meta["y"]
	local coords = x .. "|" .. y
	local title = meta["title"]
	local spawn = meta["spawn"]
	local item = meta["item"]

	if not CodexMap.nodes[addon] then CodexMap.nodes[addon] = {} end
	if not CodexMap.nodes[addon][map] then CodexMap.nodes[addon][map] = {} end
	if not CodexMap.nodes[addon][map][coords] then CodexMap.nodes[addon][map][coords] = {} end

	if item and CodexMap.nodes[addon][map][coords][title] and table.getn(CodexMap.nodes[addon][map][coords][title].item) > 0 then
		-- Check if item exists
		for id, name in pairs(CodexMap.nodes[addon][map][coords][title].item) do
			if name == item then
				return
			end
		end
		table.insert(CodexMap.nodes[addon][map][coords][title].item, item)
	end

	local node = {}
	for key, value in pairs(meta) do
		node[key] = value
	end
	node.item = {[1] = item}
	node["mapMarker"] = CreateMapMarker(node.spawn, node.level, {}, CodexMap.colorList[2])


	CodexMap.nodes[addon][map][coords][title] = node

	-- add to gametooltips
	-- if spawn and title then
	-- 	pfMap.tooltips[spawn]        = pfMap.tooltips[spawn]        or {}
	-- 	pfMap.tooltips[spawn][title] = pfMap.tooltips[spawn][title] or node
	-- end
end

function CodexMap:DeleteNode(addon, title)
	if not addon then
		CodexMap.nodes = {}
	elseif not title then
		CodexMap.nodes[addon] = {}
	elseif CodexMap.nodes[addon] then
		for map in pairs(CodexMap.nodes[addon]) do
			for coords, node in pairs(CodexMap.nodes[addon][map]) do
				if CodexMap.nodes[addon][map][coords][title] then
					CodexMap.nodes[addon][map][coords][title] = nil
					if isEmpty(CodexMap.nodes[addon][map][coords]) then
						CodexMap.nodes[addon][map][coords] = nil
					end
				end
				if CodexMap.markers[coords] then
					CodexMap.HBDP:RemoveWorldMapIcon("Map", CodexMap.markers[coords])
				end
			end
		end
	end
end

function CodexMap:UpdateNodes()
	print("Updating Nodes")
	local mapId = C_Map.GetBestMapForUnit("player")
	local map = CodexMap.zones[mapId]
	local i = 0

	CodexMap.HBDP:RemoveAllWorldMapIcons("Map")
	CodexMap.HBDP:RemoveAllMinimapIcons("Map")

	-- refresh all nodes
	for addon, v in pairs(CodexMap.nodes) do
		if CodexMap.nodes[addon][map] then
			for coords, node in pairs(CodexMap.nodes[addon][map]) do
				for k, v in pairs(node) do
					CodexMap.HBDP:AddWorldMapIconMap("Map", v.mapMarker, mapId, v.x / 100, v.y / 100, HBD_PINS_WORLDMAP_SHOW_PARENT)
					CodexMap.HBDP:AddMinimapIconMap("Map", CreateMinimapMarker(v.spawn, v.level, {}, CodexMap.colorList[4]), mapId, v.x / 100, v.y / 100, true, false)
				end
			end
		end
	end
end



-- function Codex.UpdateMap()
--     local index = 1
-- 	local colorIndex = 1
-- 	Codex.targetList = {}
--     Codex.HBDP:RemoveAllWorldMapIcons("Map")
-- 	Codex.HBDP:RemoveAllMinimapIcons("Map")
--     for questID, questValue in pairs(Codex.QuestLog) do
--         if not questValue["isComplete"] then
--             for objectiveKey, objective in pairs(questValue["objectives"]) do
-- 				if not objective["isComplete"] then
-- 					for targetKey, target in pairs(objective["targets"]) do
-- 						if Codex.targetList[target["name"]] == nil then
-- 							Codex.targetList[target["name"]] = {["coords"] = {}, ["level"] = nil, ["objectives"] = {}, ["color"] = Codex["DotColorList"][colorIndex]}
-- 							if target["level"] then
-- 								Codex.targetList[target["name"]]["level"] = target["level"]
-- 							end

-- 							tinsert(Codex.targetList[target["name"]]["objectives"], objective["text"])
-- 							for _, coord in pairs(target["coords"]) do
-- 								tinsert(Codex.targetList[target["name"]]["coords"], coord)                     
-- 							end
-- 						else
-- 							tinsert(Codex.targetList[target["name"]]["objectives"], objective["text"])
--                         end
-- 					end
--                     colorIndex = colorIndex + 1
--                 end
-- 			end
-- 		else
-- 			local mapMarker = CreateMapTurnInMarker(questValue["name"])
-- 			local minimapMarker = CreateMinimapTurnInMarker(questValue["name"])
-- 			local x = questValue["turnin"]["coords"][1]
-- 			local y = questValue["turnin"]["coords"][2]
-- 			local zoneID = questValue["turnin"]["coords"][3]
-- 			Codex.HBDP:AddWorldMapIconMap("Map", mapMarker, Codex["Zones"][zoneID], x, y, HBD_PINS_WORLDMAP_SHOW_PARENT)
-- 			Codex.HBDP:AddMinimapIconMap("Map", minimapMarker, Codex["Zones"][zoneID], x, y, true, false)
-- 		end
-- 	end
-- 	for name, target in pairs(Codex.targetList) do
-- 		for _, coord in pairs(target["coords"]) do
-- 			local mapMarker = CreateMapMarker(name, target["level"], target["objectives"], target["color"])
-- 			local minimapMarker = CreateMinimapMarker(name, target["level"], target["objectives"], target["color"])
-- 			Codex.HBDP:AddWorldMapIconMap("Map", mapMarker, Codex["Zones"][coord[3]], coord[1], coord[2], HBD_PINS_WORLDMAP_SHOW_PARENT)
-- 			Codex.HBDP:AddMinimapIconMap("Map", minimapMarker, Codex["Zones"][coord[3]], coord[1], coord[2], true, false)			
-- 		end
-- 	end

-- end


function CreateMapMarker(target, level, objectives, color)
    local marker = CreateFrame("Frame", nil, UIParent)
    marker:SetFrameStrata("HIGH")
    marker:SetWidth(10)
    marker:SetHeight(10)
    marker:SetParent(WorldMapFrame)

    local texture = marker:CreateTexture(nil, "HIGH")
    texture:SetTexture("Interface\\Addons\\ClassicCodex\\img\\Icon.blp")
    texture:SetAllPoints(marker)
    texture:SetVertexColor(color[1], color[2], color[3], 1)

    marker.texture = texture
    marker:SetPoint("CENTER", 0, 0)
    marker:Hide()
    marker:SetScript("OnEnter", function(self, button)
		GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR_LEFT")
		if level then
			GameTooltip:SetText(target.." ["..level.."]", 1, 1, 1, 1, true)
		else
			GameTooltip:SetText(target, 1, 1, 1, 1, true)
		end
		for _, name in pairs(objectives) do
			GameTooltip:AddLine(name, 1, 1, 1)
		end
        GameTooltip:Show()
    end)
    marker:SetScript("OnLeave", function(self, button)
        GameTooltip:Hide()
    end)

    return marker
end

function CreateMinimapMarker(target, level, objectives, color)
    local marker = CreateFrame("Frame", nil, UIParent)
    marker:SetFrameStrata("HIGH")
    marker:SetWidth(10)
    marker:SetHeight(10)

    local texture = marker:CreateTexture(nil, "HIGH")
    texture:SetTexture("Interface\\Addons\\ClassicCodex\\img\\Icon.blp")
    texture:SetAllPoints(marker)
    texture:SetVertexColor(color[1], color[2], color[3], 1)

    marker.texture = texture
    marker:SetPoint("CENTER", 0, 0)
    marker:Hide()
    marker:SetScript("OnEnter", function(self, button)
        GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR_LEFT")
		if level then
			GameTooltip:SetText(target.." ["..level.."]", 1, 1, 1, 1, true)
		else
			GameTooltip:SetText(target, 1, 1, 1, 1, true)
		end
		for _, name in pairs(objectives) do
			GameTooltip:AddLine(name, 1, 1, 1)
		end
        GameTooltip:Show()
    end)
    marker:SetScript("OnLeave", function(self, button)
        GameTooltip:Hide()
    end)

    return marker
end

function CreateMapTurnInMarker(name)
	local marker = CreateFrame("Frame", nil, UIParent)
	marker:SetFrameStrata("HIGH")
	marker:SetWidth(14)
	marker:SetHeight(14)
	marker:SetParent(WorldMapFrame)

	local texture = marker:CreateTexture(nil, "HIGH")
	texture:SetTexture("Interface\\Addons\\ClassicCodex\\img\\handin.tga")
	texture:SetAllPoints(marker)

	marker.texture = texture
	marker:SetPoint("CENTER", 0, 0)
	marker:Hide()
    marker:SetScript("OnEnter", function(self, button)
        GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR_LEFT")
        GameTooltip:SetText(name, 1, 1, 1, 1, true)
        GameTooltip:Show()
    end)
    marker:SetScript("OnLeave", function(self, button)
        GameTooltip:Hide()
    end)

	return marker
end

function CreateMinimapTurnInMarker(name)
	local marker = CreateFrame("Frame", nil, UIParent)
	marker:SetFrameStrata("HIGH")
	marker:SetWidth(14)
	marker:SetHeight(14)

	local texture = marker:CreateTexture(nil, "HIGH")
	texture:SetTexture("Interface\\Addons\\ClassicCodex\\img\\handin.tga")
	texture:SetAllPoints(marker)

	marker.texture = texture
	marker:SetPoint("CENTER", 0, 0)
	marker:Hide()
    marker:SetScript("OnEnter", function(self, button)
        GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR_LEFT")
        GameTooltip:SetText(name, 1, 1, 1, 1, true)
        GameTooltip:Show()
    end)
    marker:SetScript("OnLeave", function(self, button)
        GameTooltip:Hide()
    end)

	return marker
end

CodexMap:RegisterEvent("ZONE_CHANGED")
CodexMap:RegisterEvent("ZONE_CHANGED_NEW_AREA")
CodexMap:SetScript("OnEvent", function(self, event, ...)
	CodexMap:UpdateNodes()
end)
