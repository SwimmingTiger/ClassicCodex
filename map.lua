if (tonumber(string.sub(Codex.Build, 1,1)) > 2) then
	return
end
Codex.targetList = {}
Codex["DotColorList"] = {
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
Codex["DotzColorList"] = {
	[1] = {
		1,
		0,
		0,
	},
	[2] = {
		0,
		1,
		0,
	},
	[3] = {
		0,
		0,
		1,
	},
	[4] = {
		1,
		1,
		0,
	},
	[5] = {
		1,
		0,
		1,
	},
	[6] = {
		0,
		1,
		1,
	},
	[7] = {
		1,
		0.5,
		0,
	},
	[8] = {
		1,
		0,
		0.5,
	},
	[9] = {
		0.5,
		1,
		0,
	},
	[10] = {
		0,
		1,
		0.5,
	},
	[11] = {
		0.5,
		0,
		1,
	},
	[12] = {
		0,
		0.5,
		1,
	},
	[13] = {
		0,
		0.2,
		1,
	},
	[14] = {
		0,
		1,
		0.2,
	},
	[15] = {
		1,
		0.2,
		0.4,
	},
	[16] = {
		1,
		0.6,
		0.1,
	},
	[17] = {
		0.6,
		0.2,
		0.1,
	},
	[18] = {
		0.2,
		0.9,
		0.1,
	},
}
Codex["Zones"] = {
	[1] = 1426,   --Dun Morogh 
	[3] = 1418,   --Badlands 
	[4] = 1419,   --Blasted Lands 
	[8] = 1435,   --Swamp of Sorrows 
	[10] = 1431,   --Duskwood 
	[11] = 1437,   --Wetlands 
	[12] = 1429,   --Elwynn Forest  
	[14] = 1411,   --Durotar  
	[15] = 1445,   --Dustwallow Marsh  
	[16] = 1447,   --Azshara  
	[17] = 1413,   --The Barrens  
	[28] = 1422,   --Western Plaguelands  
	[33] = 1434,   --Stranglethorn Vale  
	[36] = 1416,   --Alterac Mountains  
	[38] = 1432,   --Loch Modan  
	[40] = 1436,   --Westfall  
	[41] = 1430,   --Deadwind Pass  
	[44] = 1433,   --Redridge Mountains  
	[45] = 1417,   --Arathi Highlands  
	[46] = 1428,   --Burning Steppes  
	[47] = 1425,   --The Hinterlands  
	[51] = 1427,   --Searing Gorge  
	[69] = 1433,   --Lakeshire  
	[85] = 1420,   --Tirisfal Glades  
	[130] = 1421,   --Silverpine Forest  
	[139] = 1423,   --Eastern Plaguelands  
	[141] = 1438,   --Teldrassil  
	[148] = 1439,   --Darkshore  
	[215] = 1412,   --Mulgore  
	[267] = 1424,   --Hillsbrad Foothills  
	[331] = 1440,   --Ashenvale  
	[357] = 1444,   --Feralas  
	[361] = 1448,   --Felwood  
	[400] = 1441,   --Thousand Needles  
	[405] = 1443,   --Desolace  
	[406] = 1442,   --Stonetalon Mountains  
	[440] = 1446,   --Tanaris  
	[490] = 1449,   --Un'Goro Crater  
	[493] = 1450,   --Moonglade  
	[618] = 1452,   --Winterspring  
	[1377] = 1451,   --Silithus 
	[1497] = 1458,   --Undercity 
	[1519] = 1453,   --Stormwind City 
	[1537] = 1455,   --Ironforge 
	[1637] = 1454,   --Orgrimmar 
	[1638] = 1456,   --Thunder Bluff 
	[1657] = 1457,   --Darnassus 
	[2597] = 1459,   --Alterac Valley 
	[3277] = 1460,   --Warsong Gulch 
	[3358] = 1461,   --Arathi Basin 
}

function Codex.UpdateMap()
    local index = 1
    local colorIndex = 1
    Codex.targetList = {}
    Codex.HBDP:RemoveAllWorldMapIcons("Map")
	Codex.HBDP:RemoveAllMinimapIcons("Map")
    for questID, questValue in pairs(Codex.QuestLog) do
        if not questValue["isComplete"] then
            for objectiveKey, objective in pairs(questValue["objectives"]) do
				if not objective["isComplete"] then
					for targetKey, target in pairs(objective["targets"]) do
						if Codex.targetList[target["name"]] == nil then
							Codex.targetList[target["name"]] = {["coords"] = {}, ["level"] = nil, ["objectives"] = {}, ["color"] = Codex["DotColorList"][colorIndex]}
							if target["level"] then
								Codex.targetList[target["name"]]["level"] = target["level"]
							end

							tinsert(Codex.targetList[target["name"]]["objectives"], objective["text"])
							for _, coord in pairs(target["coords"]) do
								tinsert(Codex.targetList[target["name"]]["coords"], coord)                     
							end
						else
							tinsert(Codex.targetList[target["name"]]["objectives"], objective["text"])
                        end
					end
                    colorIndex = colorIndex + 1
                end
			end
		else
			local mapMarker = CreateMapTurnInMarker(questValue["name"])
			local minimapMarker = CreateMinimapTurnInMarker(questValue["name"])
			local x = questValue["turnin"]["coords"][1]
			local y = questValue["turnin"]["coords"][2]
			local zoneID = questValue["turnin"]["coords"][3]
			Codex.HBDP:AddWorldMapIconMap("Map", mapMarker, Codex["Zones"][zoneID], x, y, HBD_PINS_WORLDMAP_SHOW_PARENT)
			Codex.HBDP:AddMinimapIconMap("Map", minimapMarker, Codex["Zones"][zoneID], x, y, true, false)
		end
	end
	for name, target in pairs(Codex.targetList) do
		for _, coord in pairs(target["coords"]) do
			local mapMarker = CreateMapMarker(name, target["level"], target["objectives"], target["color"])
			local minimapMarker = CreateMinimapMarker(name, target["level"], target["objectives"], target["color"])
			Codex.HBDP:AddWorldMapIconMap("Map", mapMarker, Codex["Zones"][coord[3]], coord[1], coord[2], HBD_PINS_WORLDMAP_SHOW_PARENT)
			Codex.HBDP:AddMinimapIconMap("Map", minimapMarker, Codex["Zones"][coord[3]], coord[1], coord[2], true, false)			
		end
	end

end


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
    marker.P = 0
    marker.A = 0
    marker.D = 0
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
    marker.P = 0
    marker.A = 0
    marker.D = 0
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
	marker.A = 0
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
	marker.A = 0
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
