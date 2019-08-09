CodexMap = CreateFrame("Frame")
CodexMap.HBDP = LibStub("HereBeDragons-Pins-2.0")
CodexMap.HBD = LibStub("HereBeDragons-2.0")
CodexMap.nodes = {}
CodexMap.tooltips = {}
CodexMap.markers = {}
CodexMap.minimapMarkers = {}

CodexMap.objectiveList = {}
CodexMap.colorListIndex = 1
CodexMap.colorList = {
	[1] = {0.901, 0.098, 0.294},--redish
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
	-- [22] = {0, 0, 0}, --black
}

CodexMap.searchColor = {0, 0, 0}

CodexMap.zones = {
    [1] = 1426, --Dun Morogh
	[3] = 1418, --Badlands
	[4] = 1419, --Blasted Lands
	[8] = 1435, --Swamp of Sorrows
	[10] = 1431, --Duskwood
	[11] = 1437, --Wetlands
	[12] = 1429, --Elwynn Forest
	[14] = 1411, --Durotar
	[15] = 1445, --Dustwallow Marsh
	[16] = 1447, --Azshara
	[17] = 1413, --The Barrens
	[28] = 1422, --Western Plaguelands
	[33] = 1434, --Stranglethorn Vale
	[36] = 1416, --Alterac Mountains
	[38] = 1432, --Loch Modan
	[40] = 1436, --Westfall
	[41] = 1430, --Deadwind Pass
	[44] = 1433, --Redridge Mountains
	[45] = 1417, --Arathi Highlands
	[46] = 1428, --Burning Steppes
	[47] = 1425, --The Hinterlands
	[51] = 1427, --Searing Gorge
	[69] = 1433, --Lakeshire
	[85] = 1420, --Tirisfal Glades
	[130] = 1421, --Silverpine Forest
	[139] = 1423, --Eastern Plaguelands
	[141] = 1438, --Teldrassil
	[148] = 1439, --Darkshore
	[215] = 1412, --Mulgore
	[267] = 1424, --Hillsbrad Foothills
	[331] = 1440, --Ashenval
	[357] = 1444, --Feralas
	[361] = 1448, --Felwood
	[400] = 1441, --Thousand Needles
	[405] = 1443, --Desolace
	[406] = 1442, --Stonetalon Mountains
	[440] = 1446, --Tanaris
	[490] = 1449, --Un'Goro Crater
	[493] = 1450, --Moonglade
	[618] = 1452, --Winterspring
	[1377] = 1451, --Silithus
	[1497] = 1458, --Undercity
	[1519] = 1453, --Stormwind City
	[1537] = 1455, --Ironforge
	[1637] = 1454, --Orgrimmar
	[1638] = 1456, --Thunder Bluff
	[1657] = 1457, --Darnassus
	[2597] = 1459, --Alterac Valley
	[3277] = 1460, --Warsong Gulch
	[3358] = 1461, --Arathi Basin
}

CodexMap.tooltip = CreateFrame("Frame", "CodexMapTooltip", GameTooltip)
CodexMap.tooltip:SetScript("OnShow", function()
	local focus = GetMouseFocus()
	
	if focus and focus.title then return end

	if focus and focus.GetName and strsub((focus:GetName() or ""), 0, 10) == "QuestTimer" then return end

	local name = getglobal("GameTooltipTextLeft1") and getglobal("GameTooltipTextLeft1"):GetText()

	if name and CodexMap.tooltips[name] then
		for title, meta in pairs(CodexMap.tooltips[name]) do
			CodexMap:ShowTooltip(meta, GameTooltip)
			GameTooltip:Show()
		end
	end
end)

local layers = {
	["Interface\\Addons\\ClassicCodex\\img\\available.tga"] = 1,
	["Interface\\Addons\\ClassicCodex\\img\\available_c.tga"] = 2,
	["Interface\\Addons\\ClassicCodex\\img\\complete.tga"] = 3,
	["Interface\\Addons\\ClassicCodex\\img\\complete_c.tga"] = 4,
	["Interface\\Addons\\ClassicCodex\\img\\icon_vendor.tga"] = 5,
}

local function GetLayerByTexture(texture)
	if layers[texture] then return layers[texture] else return 1 end
end

local function isEmpty(tabl)
	for key, value in pairs(tabl) do
		return false
	end
	return true
end

local function buildObjectiveList(node)
	for _, meta in pairs(node) do
		if meta.uuid and not CodexMap.objectiveList[meta.uuid] then
			CodexMap.objectiveList[meta.uuid] = 1
		end
	end
end

function CodexMap:GetTooltipColor(min, max)
	local perc = min / max
	local r1, g1, b1, r2, g2, b2
	if perc <= 0.5 then
		perc = perc * 2
		r1, g1, b1 = 1, 0, 0
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

function CodexMap:ShowMapId(map)
	if map then
		if not UISpecialFrames["WorldMapFrame"] then
			table.insert(UISpecialFrames, "WorldMapFrame")
		end

		-- CodexMap:UpdateNodes()
		WorldMapFrame:Show()
		for worldMapId, mapId in pairs(CodexMap.zones) do
			if worldMapId == map then
				WorldMapFrame:SetMapID(mapId)
				CodexMap:UpdateNodes()
				return true
			end
		end
	end

	return nil
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
							local _, _, monsterName, objNum, objNeeded = strfind(text, Codex:SanitizePattern(QUEST_MONSTERS_KILLED))
							if meta["spawn"] == monsterName then
								foundObjective = true
								local r, g, b = CodexMap:GetTooltipColor(objNum, objNeeded)
								tooltip:AddLine("|cffaaaaaa- |r" .. monsterName .. ": " .. objNum .. "/" .. objNeeded, r, g, b)
							end
						elseif table.getn(meta["item"]) > 0 and type == "item" and meta["dropRate"] then
							-- Loot
							local _, _, itemName, objNum, objNeeded = strfind(text, Codex:SanitizePattern(QUEST_OBJECTS_FOUND))

							for mid, item in pairs(meta["item"]) do
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
							local _, _, itemName, objNum, objNeeded = strfind(text, Codex:SanitizePattern(QUEST_OBJECTS_FOUND))

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

			meta["itemLink"] = itemColor .. "|Hitem:" .. meta["itemId"] .. ":0:0:0|h[" .. meta["item"][1] .. "]|h|r"
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
	local layer = GetLayerByTexture(meta["texture"])
	local spawn = meta["spawn"]
	local item = meta["item"]

	if not CodexMap.nodes[addon] then CodexMap.nodes[addon] = {} end
	if not CodexMap.nodes[addon][map] then CodexMap.nodes[addon][map] = {} end
	if not CodexMap.nodes[addon][map][coords] then CodexMap.nodes[addon][map][coords] = {} end

	if item and CodexMap.nodes[addon][map][coords][title] and getn(CodexMap.nodes[addon][map][coords][title].item) > 0 then
		-- Check if item exists
		for id, name in pairs(CodexMap.nodes[addon][map][coords][title].item) do
			if name == item then
				return
			end
		end
		table.insert(CodexMap.nodes[addon][map][coords][title].item, item)
	end

	if CodexMap.nodes[addon][map][coords][title] and CodexMap.nodes[addon][map][coords][title].layer and layer and CodexMap.nodes[addon][map][coords][title].layer >= layer then
		return
	end

	local node = {}
	for key, value in pairs(meta) do
		node[key] = value
	end
	node.item = {[1] = item}

	CodexMap.nodes[addon][map][coords][title] = node

	if spawn and title then
		CodexMap.tooltips[spawn] = CodexMap.tooltips[spawn] or {}
		CodexMap.tooltips[spawn][title] = CodexMap.tooltips[spawn][title] or node
	end
end

function CodexMap:DeleteNode(addon, title)
	if not addon then
		CodexMap.tooltips = {}
	else
		for key, value in pairs(CodexMap.tooltips) do
			for k, v in pairs(value) do
				if (title and k == title) or (not title and v.addon == addon) then
					CodexMap.tooltips[key][k] = nil
				end
			end
		end
	end 

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
			end
		end
	end
end

function CodexMap:CreateMapMarker(node)
	local marker = CreateFrame("Button", nil, UIParent)
	marker:SetFrameStrata("HIGH")
	marker:SetWidth(10)
	marker:SetHeight(10)
	marker:SetParent(WorldMapFrame)
	
	local texture = marker:CreateTexture(nil, "HIGH")
	texture:SetAllPoints(marker)
	marker.tex = texture
	marker:SetPoint("CENTER", 0, 0)
	marker:Hide()

	marker:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR_LEFT")
		GameTooltip:SetText(marker.spawn, .3, 1, .8)
		GameTooltip:AddDoubleLine("Level: ", (marker.level or UNKNOWN), .8, .8, .8, 1, 1, 1)

		for title, meta in pairs(marker.node) do
			CodexMap:ShowTooltip(meta, GameTooltip)
		end
	end)

	marker:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)


	return marker
end

function CodexMap:CreateMinimapMarker(node)
	local marker = CreateFrame("Button", nil, UIParent)
	marker:SetFrameStrata("HIGH")
	marker:SetWidth(10)
	marker:SetHeight(10)
	
	local texture = marker:CreateTexture(nil, "HIGH")
	texture:SetAllPoints(marker)
	marker.tex = texture
	marker:SetPoint("CENTER", 0, 0)
	marker:Hide()

	marker:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR_LEFT")
		GameTooltip:SetText(marker.spawn, .3, 1, .8)
		GameTooltip:AddDoubleLine("Level: ", (marker.level or UNKNOWN), .8, .8, .8, 1, 1, 1)

		for title, meta in pairs(marker.node) do
			CodexMap:ShowTooltip(meta, GameTooltip)
		end
	end)

	marker:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)

	return marker
end

function CodexMap:UpdateNode(frame, node)
	frame.layer = 0

	for title, meta in pairs(node) do
		meta.layer = GetLayerByTexture(meta.texture)

		if meta.spawn and (meta.layer > frame.layer or not frame.spawn) then
			-- set title and texture to the entry with highest layer
			-- and add core information
			frame.layer = meta.layer
			frame.spawn = meta.spawn
			frame.spawnId = meta.spawnId
			frame.spawnType = meta.spawnType
			frame.respawn = meta.respawn
			frame.level = meta.level
			frame.questId = meta.questId
			frame.texture = meta.texture
			frame.color = meta.color
			frame.title = meta.title
			frame.uuid = meta.uuid
			frame.search = meta.search
		end
	end

	frame.tex:SetVertexColor(1, 1, 1)

	if not frame.texture then
		frame:SetWidth(10)
		frame:SetHeight(10)
		frame.tex:SetTexture("Interface\\Addons\\ClassicCodex\\img\\icon.tga")

		frame:SetScript("OnClick", function(self)
			if IsShiftKeyDown() then
				CodexMap:DeleteNode(frame.node[frame.title].addon, frame.title)
				CodexMap:UpdateNodes()
			end
		end)
	else
		frame:SetWidth(14)
		frame:SetHeight(14)
		frame.tex:SetTexture(frame.texture)
	end

	if not frame.color then 
		if frame.uuid and CodexMap.objectiveList[frame.uuid] and CodexMap.objectiveList[frame.uuid] == 1 and frame.layer ~= 5 then
			local r, g, b = unpack(CodexMap.colorList[CodexMap.colorListIndex])
			frame.tex:SetVertexColor(r, g, b, 1)
			CodexMap.objectiveList[frame.uuid] = CodexMap.colorList[CodexMap.colorListIndex]
			CodexMap.colorListIndex = CodexMap.colorListIndex + 1
			if CodexMap.colorListIndex > getn(CodexMap.colorList) then
				CodexMap.colorListIndex = 1
			end
		elseif frame.uuid and CodexMap.objectiveList[frame.uuid] and frame.layer ~= 5 then
			local color = CodexMap.objectiveList[frame.uuid]
			frame.tex:SetVertexColor(color[1], color[2], color[3])
		elseif frame.search then
			frame.tex:SetVertexColor(CodexMap.searchColor[1], CodexMap.searchColor[2], CodexMap.searchColor[3], 1)
		end
	else
		local r, g, b = unpack(frame.color)
		if r > 0 or g > 0 or b > 0 then
			frame.tex:SetVertexColor(r, g, b, 1)
		end
	end


	frame.node = node
end


function CodexMap:UpdateNodes()
	-- local worldMapId = C_Map.GetBestMapForUnit("player")

	local i = 0

	CodexMap.objectiveList = {}
	CodexMap.colorListIndex = 1

	CodexMap.HBDP:RemoveAllWorldMapIcons("Map")
	CodexMap.HBDP:RemoveAllMinimapIcons("Map")

	-- refresh all nodes
	for addon in pairs(CodexMap.nodes) do
		for mapId in pairs(CodexMap.nodes[addon]) do
			worldMapId = CodexMap.zones[mapId]
			for coords, node in pairs(CodexMap.nodes[addon][mapId]) do

				buildObjectiveList(node)

				if not CodexMap.markers[i] or not CodexMap.minimapMarkers[i] then
					CodexMap.markers[i] = CodexMap:CreateMapMarker(node)
					CodexMap.minimapMarkers[i] = CodexMap:CreateMinimapMarker(node)
				end

				CodexMap:UpdateNode(CodexMap.markers[i], node)
				CodexMap:UpdateNode(CodexMap.minimapMarkers[i], node)

				local _, _, x, y = strfind(coords, "(.*)|(.*)")
				x = x / 100
				y = y / 100
			
				CodexMap.HBDP:AddWorldMapIconMap("Map", CodexMap.markers[i], worldMapId, x, y, HBD_PINS_WORLDMAP_SHOW_PARENT)
				CodexMap.HBDP:AddMinimapIconMap("Map", CodexMap.minimapMarkers[i], worldMapId, x, y, true, false)

				i = i + 1
			end
		end
	end

end

CodexMap:RegisterEvent("ZONE_CHANGED")
CodexMap:RegisterEvent("ZONE_CHANGED_NEW_AREA")
CodexMap:SetScript("OnEvent", function(self, event, ...)
	CodexMap:UpdateNodes()
end)
