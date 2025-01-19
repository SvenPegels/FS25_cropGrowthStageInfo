-- Author:svenp (github.com/SvenPegels)
-- Name:Crop Growth Stage Info
-- Version: 1.0.0.0
-- Description: Script mod for displaying the exact growth stage of the field currently standing on, and which type of tires are required
-- Icon:
-- Hide: no
-- Credits to Yumi/Yumi-Modding's 'Additional Field Info' mod for showing the proper way of adding lines to the field info box

-- #TODO: Change moddesc version to 94

GrowthInfo = {};

print("Info - GrowthInfo: Initializing")
print(PlayerHUDUpdater)
-- DebugUtil.printTableRecursively(PlayerHUDUpdater, "-", 0, 1)
-- DebugUtil.printTableRecursively(PlayerHUDUpdater, "-", 0, 2)
-- DebugUtil.printTableRecursively(PlayerHUDUpdater, "-", 0, 3)
-- DebugUtil.printTableRecursively(PlayerHUDUpdater, "-", 0, 4)
-- DebugUtil.printTableRecursively(PlayerHUDUpdater, "-", 0, 5)

function GrowthInfo:loadMap(name)
	print("Info - GrowthInfo: Loading mod")
	-- print("Debug - GrowthInfo: g_currentMission1")
	-- DebugUtil.printTableRecursively(g_currentMission, "-", 0, 1)
	-- print("Debug - GrowthInfo: g_currentMission.growthSystem1")
	-- DebugUtil.printTableRecursively(g_currentMission.growthSystem, "-", 0, 1)
	-- print("Debug - GrowthInfo: g_currentMission.foliageSystem1")
	-- DebugUtil.printTableRecursively(g_currentMission.foliageSystem, "-", 0, 1)
	-- print("Debug - GrowthInfo: g_currentMission.missionInfo.foliageTypes1")
	-- DebugUtil.printTableRecursively(g_currentMission.missionInfo.foliageTypes, "-", 0, 1)
	-- DebugUtil.printTableRecursively(g_currentMission, "-", 0, 2)
	-- DebugUtil.printTableRecursively(g_currentMission, "-", 0, 3)
	-- DebugUtil.printTableRecursively(g_currentMission, "-", 0, 4)
	-- DebugUtil.printTableRecursively(g_currentMission, "-", 0, 5)
	if not g_modIsLoaded["FS25_precisionFarming"] then
		print("Info - GrowthInfo: Precision Farming DLC not present")
		PlayerHUDUpdater.fieldAddField = Utils.prependedFunction(PlayerHUDUpdater.fieldAddField, GrowthInfo.fieldAddGrowth);

		-- PlayerHUDUpdater.fieldAddFarmland = Utils.appendedFunction(PlayerHUDUpdater.fieldAddFarmland, GrowthInfo.fieldAddGrowthA);
		-- PlayerHUDUpdater.fieldAddWeed = Utils.appendedFunction(PlayerHUDUpdater.fieldAddWeed, GrowthInfo.fieldAddGrowthB);
		-- PlayerHUDUpdater.fieldAddField = Utils.appendedFunction(PlayerHUDUpdater.fieldAddField, GrowthInfo.fieldAddGrowthC);
		-- -- fieldAddFarmland
		-- -- fieldAddWeed
		-- -- fieldAddField
		-- PlayerHUDUpdater.fieldAddFarmland = Utils.prependedFunction(PlayerHUDUpdater.fieldAddFarmland, GrowthInfo.fieldAddGrowthD);
		-- PlayerHUDUpdater.fieldAddWeed = Utils.prependedFunction(PlayerHUDUpdater.fieldAddWeed, GrowthInfo.fieldAddGrowthE);
		-- PlayerHUDUpdater.fieldAddField = Utils.prependedFunction(PlayerHUDUpdater.fieldAddField, GrowthInfo.fieldAddGrowthF);
	else
		print("Info - GrowthInfo: Precision Farming DLC present")
		-- The Precision Farming DLC seems to overwrite PlayerHUDUpdater.fieldAddFruit, causing it and any prepended/appended function to not be called. Therefore prepend it to .fieldAddWeed
		PlayerHUDUpdater.fieldAddWeed = Utils.prependedFunction(PlayerHUDUpdater.fieldAddWeed, GrowthInfo.fieldAddGrowth);
	end
end

function GrowthInfo:deleteMap(savegame)
	print("Info - GrowthInfo: Exiting")
end

--[[
	Adds additional lines to the 'Field Info' box in the bottom right of the screen for:
	- Current growth state (and whether it can be forage harvested)
	- Required tire type to prevent crop destruction
]]
function GrowthInfo:fieldAddGrowth(data, box)
	-- if (self.nameToFruitType == nil) then
	-- 	self.nameToFruitType = g_fruitTypeManager.nameToFruitType;
	-- end
	if (self.indexToFruitType == nil) then
		self.indexToFruitType = g_fruitTypeManager.indexToFruitType;
	end

	if (data == nil or box == nil) then
		print("Debug - GrowthInfo: No data, returning early")
		do return end;
	end

	box:addLine("data", "will be here");
	-- print("Debug - GrowthInfo: data1")
	-- DebugUtil.printTableRecursively(data, "-", 0, 1)
	-- print("Debug - GrowthInfo: data2")
	-- DebugUtil.printTableRecursively(data, "-", 0, 2)
	-- print("Debug - GrowthInfo: data3")
	-- DebugUtil.printTableRecursively(data, "-", 0, 3)
	-- print("Debug - GrowthInfo: data4")
	-- DebugUtil.printTableRecursively(data, "-", 0, 4)
	-- print("Debug - GrowthInfo: data5")
	-- DebugUtil.printTableRecursively(data, "-", 0, 5)

	
	-- print("Debug - GrowthInfo: box1")
	-- DebugUtil.printTableRecursively(box, "-", 0, 1)
	-- print("Debug - GrowthInfo: box2")
	-- DebugUtil.printTableRecursively(box, "-", 0, 2)
	-- print("Debug - GrowthInfo: box3")
	-- DebugUtil.printTableRecursively(box, "-", 0, 3)
	-- print("Debug - GrowthInfo: box4")
	-- DebugUtil.printTableRecursively(box, "-", 0, 4)
	-- print("Debug - GrowthInfo: box5")
	-- DebugUtil.printTableRecursively(box, "-", 0, 5)

	-- nil checks: when field does not contain a crop (plowed/cultivated), fruit data will be nil
	local fruitTypeIndex = data.fruitTypeIndex;
	print("Debug - GrowthInfo: Fruit index = ")
	print(fruitTypeIndex)
	if (fruitTypeIndex ~= nil and fruitTypeIndex ~= 0) then
		fruitType = self.indexToFruitType[fruitTypeIndex]
		print("Debug - GrowthInfo: Got fruit type index")
		local currentGrowthState = data.growthState;
		local maxGrowthState = fruitType.numGrowthStates - 1; -- numGrowthStates includes the harvesting state, therefore -1
		
		-- Growth stage info
		-- if (currentGrowthState ~= nil and currentGrowthState > 0 and currentGrowthState <= maxGrowthState) then
		if (currentGrowthState ~= nil and currentGrowthState > 0) then --#TODO: For testing only, release should also check if currentGS <= maxGS
			print("Debug - GrowthInfo: Got growth state")
			-- Crop is in the one of the 'growing' states
			if (currentGrowthState >= fruitType.minForageGrowthState) then
				print("Debug - GrowthInfo: Forage true")
				-- Crop can be harvested by forage harvester already
				box:addLine(g_i18n:getText("label_Growth_Stage"), string.format("%s/%s (%s)", currentGrowthState, maxGrowthState, g_i18n:getText("text_Foragable")));
			else
				print("Debug - GrowthInfo: Normal true")
				-- Crop cannot be harvested by forage harvester yet
				box:addLine(g_i18n:getText("label_Growth_Stage"), string.format("%s/%s", currentGrowthState, maxGrowthState));
			end
		end

	-- 	-- Wheel type info
	-- 	local destructionInfo = self.indexToFruitType[fruitTypeIndex].destruction
	-- 	if (currentGrowthState ~= nil and destructionInfo.filterStart ~= nil and destructionInfo.filterEnd ~= nil) then
	-- 		-- Crops like SugarBeets have the cutState (harvested state) within the bounds of the crop destruction filter. Therefore, explicitly exclude that state
	-- 		local narrowWheelsRequired = currentGrowthState >= destructionInfo.filterStart 
	-- 									and currentGrowthState <= destructionInfo.filterEnd 
	-- 									and currentGrowthState ~= self.indexToFruitType[fruitTypeIndex].cutState
	-- 		local wheelsText = (narrowWheelsRequired and g_i18n:getText("text_Narrow_Wheels")) or g_i18n:getText("text_All_Wheels")
	-- 		box:addLine(g_i18n:getText("label_Required_Wheels"), wheelsText);
	-- 	end
	end
end

function GrowthInfo:fieldAddGrowthA(data, box)
	-- if (self.indexToFruitType == nil) then
	-- 	self.indexToFruitType = g_currentMission.fruitTypeManager.indexToFruitType;
	-- end

	if (data == nil or box == nil) then
		print("Debug - cropGrowth: A nill")
		do return end;
	end

	box:addLine("A", "AAA");

	-- nil checks: when field does not contain a crop (plowed/cultivated), fruit data will be nil
	-- local fruitIndex = data.fruitTypeMax;
	-- if (fruitIndex ~= nil and data.fruits ~= nil) then
	-- 	local currentGrowthState = data.fruits[fruitIndex];
	-- 	local maxGrowthState = self.indexToFruitType[fruitIndex].numGrowthStates - 1; -- numGrowthStates includes the harvesting state, therefore -1
		
	-- 	-- Growth stage info
	-- 	if (currentGrowthState ~= nil and currentGrowthState > 0 and currentGrowthState <= maxGrowthState) then
	-- 		-- Crop is in the one of the 'growing' states
	-- 		if (currentGrowthState >= self.indexToFruitType[fruitIndex].minForageGrowthState) then
	-- 			-- Crop can be harvested by forage harvester already
	-- 			box:addLine(g_i18n:getText("label_Growth_Stage"), string.format("%s/%s (%s)", currentGrowthState, maxGrowthState, g_i18n:getText("text_Foragable")));
	-- 		else
	-- 			-- Crop cannot be harvested by forage harvester yet
	-- 			box:addLine(g_i18n:getText("label_Growth_Stage"), string.format("%s/%s", currentGrowthState, maxGrowthState));
	-- 		end
	-- 	end

	-- 	-- Wheel type info
	-- 	local destructionInfo = self.indexToFruitType[fruitIndex].destruction
	-- 	if (currentGrowthState ~= nil and destructionInfo.filterStart ~= nil and destructionInfo.filterEnd ~= nil) then
	-- 		-- Crops like SugarBeets have the cutState (harvested state) within the bounds of the crop destruction filter. Therefore, explicitly exclude that state
	-- 		local narrowWheelsRequired = currentGrowthState >= destructionInfo.filterStart 
	-- 									and currentGrowthState <= destructionInfo.filterEnd 
	-- 									and currentGrowthState ~= self.indexToFruitType[fruitIndex].cutState
	-- 		local wheelsText = (narrowWheelsRequired and g_i18n:getText("text_Narrow_Wheels")) or g_i18n:getText("text_All_Wheels")
	-- 		box:addLine(g_i18n:getText("label_Required_Wheels"), wheelsText);
	-- 	end
	-- end
end

function GrowthInfo:fieldAddGrowthB(data, box)
	-- if (self.indexToFruitType == nil) then
	-- 	self.indexToFruitType = g_currentMission.fruitTypeManager.indexToFruitType;
	-- end

	if (data == nil or box == nil) then
		print("Debug - cropGrowth: B nill")
		do return end;
	end

	box:addLine("B", "BBB");

	-- nil checks: when field does not contain a crop (plowed/cultivated), fruit data will be nil
	-- local fruitIndex = data.fruitTypeMax;
	-- if (fruitIndex ~= nil and data.fruits ~= nil) then
	-- 	local currentGrowthState = data.fruits[fruitIndex];
	-- 	local maxGrowthState = self.indexToFruitType[fruitIndex].numGrowthStates - 1; -- numGrowthStates includes the harvesting state, therefore -1
		
	-- 	-- Growth stage info
	-- 	if (currentGrowthState ~= nil and currentGrowthState > 0 and currentGrowthState <= maxGrowthState) then
	-- 		-- Crop is in the one of the 'growing' states
	-- 		if (currentGrowthState >= self.indexToFruitType[fruitIndex].minForageGrowthState) then
	-- 			-- Crop can be harvested by forage harvester already
	-- 			box:addLine(g_i18n:getText("label_Growth_Stage"), string.format("%s/%s (%s)", currentGrowthState, maxGrowthState, g_i18n:getText("text_Foragable")));
	-- 		else
	-- 			-- Crop cannot be harvested by forage harvester yet
	-- 			box:addLine(g_i18n:getText("label_Growth_Stage"), string.format("%s/%s", currentGrowthState, maxGrowthState));
	-- 		end
	-- 	end

	-- 	-- Wheel type info
	-- 	local destructionInfo = self.indexToFruitType[fruitIndex].destruction
	-- 	if (currentGrowthState ~= nil and destructionInfo.filterStart ~= nil and destructionInfo.filterEnd ~= nil) then
	-- 		-- Crops like SugarBeets have the cutState (harvested state) within the bounds of the crop destruction filter. Therefore, explicitly exclude that state
	-- 		local narrowWheelsRequired = currentGrowthState >= destructionInfo.filterStart 
	-- 									and currentGrowthState <= destructionInfo.filterEnd 
	-- 									and currentGrowthState ~= self.indexToFruitType[fruitIndex].cutState
	-- 		local wheelsText = (narrowWheelsRequired and g_i18n:getText("text_Narrow_Wheels")) or g_i18n:getText("text_All_Wheels")
	-- 		box:addLine(g_i18n:getText("label_Required_Wheels"), wheelsText);
	-- 	end
	-- end
end

function GrowthInfo:fieldAddGrowthC(data, box)
	-- if (self.indexToFruitType == nil) then
	-- 	self.indexToFruitType = g_currentMission.fruitTypeManager.indexToFruitType;
	-- end

	if (data == nil or box == nil) then
		print("Debug - cropGrowth: C nill")
		do return end;
	end

	box:addLine("C", "CCC");

	-- nil checks: when field does not contain a crop (plowed/cultivated), fruit data will be nil
	-- local fruitIndex = data.fruitTypeMax;
	-- if (fruitIndex ~= nil and data.fruits ~= nil) then
	-- 	local currentGrowthState = data.fruits[fruitIndex];
	-- 	local maxGrowthState = self.indexToFruitType[fruitIndex].numGrowthStates - 1; -- numGrowthStates includes the harvesting state, therefore -1
		
	-- 	-- Growth stage info
	-- 	if (currentGrowthState ~= nil and currentGrowthState > 0 and currentGrowthState <= maxGrowthState) then
	-- 		-- Crop is in the one of the 'growing' states
	-- 		if (currentGrowthState >= self.indexToFruitType[fruitIndex].minForageGrowthState) then
	-- 			-- Crop can be harvested by forage harvester already
	-- 			box:addLine(g_i18n:getText("label_Growth_Stage"), string.format("%s/%s (%s)", currentGrowthState, maxGrowthState, g_i18n:getText("text_Foragable")));
	-- 		else
	-- 			-- Crop cannot be harvested by forage harvester yet
	-- 			box:addLine(g_i18n:getText("label_Growth_Stage"), string.format("%s/%s", currentGrowthState, maxGrowthState));
	-- 		end
	-- 	end

	-- 	-- Wheel type info
	-- 	local destructionInfo = self.indexToFruitType[fruitIndex].destruction
	-- 	if (currentGrowthState ~= nil and destructionInfo.filterStart ~= nil and destructionInfo.filterEnd ~= nil) then
	-- 		-- Crops like SugarBeets have the cutState (harvested state) within the bounds of the crop destruction filter. Therefore, explicitly exclude that state
	-- 		local narrowWheelsRequired = currentGrowthState >= destructionInfo.filterStart 
	-- 									and currentGrowthState <= destructionInfo.filterEnd 
	-- 									and currentGrowthState ~= self.indexToFruitType[fruitIndex].cutState
	-- 		local wheelsText = (narrowWheelsRequired and g_i18n:getText("text_Narrow_Wheels")) or g_i18n:getText("text_All_Wheels")
	-- 		box:addLine(g_i18n:getText("label_Required_Wheels"), wheelsText);
	-- 	end
	-- end
end

function GrowthInfo:fieldAddGrowthD(data, box)
	-- if (self.indexToFruitType == nil) then
	-- 	self.indexToFruitType = g_currentMission.fruitTypeManager.indexToFruitType;
	-- end

	if (data == nil or box == nil) then
		print("Debug - cropGrowth: C nill")
		do return end;
	end

	box:addLine("D", "DDD");

	-- nil checks: when field does not contain a crop (plowed/cultivated), fruit data will be nil
	-- local fruitIndex = data.fruitTypeMax;
	-- if (fruitIndex ~= nil and data.fruits ~= nil) then
	-- 	local currentGrowthState = data.fruits[fruitIndex];
	-- 	local maxGrowthState = self.indexToFruitType[fruitIndex].numGrowthStates - 1; -- numGrowthStates includes the harvesting state, therefore -1
		
	-- 	-- Growth stage info
	-- 	if (currentGrowthState ~= nil and currentGrowthState > 0 and currentGrowthState <= maxGrowthState) then
	-- 		-- Crop is in the one of the 'growing' states
	-- 		if (currentGrowthState >= self.indexToFruitType[fruitIndex].minForageGrowthState) then
	-- 			-- Crop can be harvested by forage harvester already
	-- 			box:addLine(g_i18n:getText("label_Growth_Stage"), string.format("%s/%s (%s)", currentGrowthState, maxGrowthState, g_i18n:getText("text_Foragable")));
	-- 		else
	-- 			-- Crop cannot be harvested by forage harvester yet
	-- 			box:addLine(g_i18n:getText("label_Growth_Stage"), string.format("%s/%s", currentGrowthState, maxGrowthState));
	-- 		end
	-- 	end

	-- 	-- Wheel type info
	-- 	local destructionInfo = self.indexToFruitType[fruitIndex].destruction
	-- 	if (currentGrowthState ~= nil and destructionInfo.filterStart ~= nil and destructionInfo.filterEnd ~= nil) then
	-- 		-- Crops like SugarBeets have the cutState (harvested state) within the bounds of the crop destruction filter. Therefore, explicitly exclude that state
	-- 		local narrowWheelsRequired = currentGrowthState >= destructionInfo.filterStart 
	-- 									and currentGrowthState <= destructionInfo.filterEnd 
	-- 									and currentGrowthState ~= self.indexToFruitType[fruitIndex].cutState
	-- 		local wheelsText = (narrowWheelsRequired and g_i18n:getText("text_Narrow_Wheels")) or g_i18n:getText("text_All_Wheels")
	-- 		box:addLine(g_i18n:getText("label_Required_Wheels"), wheelsText);
	-- 	end
	-- end
end

function GrowthInfo:fieldAddGrowthE(data, box)
	-- if (self.indexToFruitType == nil) then
	-- 	self.indexToFruitType = g_currentMission.fruitTypeManager.indexToFruitType;
	-- end

	if (data == nil or box == nil) then
		print("Debug - cropGrowth: C nill")
		do return end;
	end

	box:addLine("E", "EEE");

	-- nil checks: when field does not contain a crop (plowed/cultivated), fruit data will be nil
	-- local fruitIndex = data.fruitTypeMax;
	-- if (fruitIndex ~= nil and data.fruits ~= nil) then
	-- 	local currentGrowthState = data.fruits[fruitIndex];
	-- 	local maxGrowthState = self.indexToFruitType[fruitIndex].numGrowthStates - 1; -- numGrowthStates includes the harvesting state, therefore -1
		
	-- 	-- Growth stage info
	-- 	if (currentGrowthState ~= nil and currentGrowthState > 0 and currentGrowthState <= maxGrowthState) then
	-- 		-- Crop is in the one of the 'growing' states
	-- 		if (currentGrowthState >= self.indexToFruitType[fruitIndex].minForageGrowthState) then
	-- 			-- Crop can be harvested by forage harvester already
	-- 			box:addLine(g_i18n:getText("label_Growth_Stage"), string.format("%s/%s (%s)", currentGrowthState, maxGrowthState, g_i18n:getText("text_Foragable")));
	-- 		else
	-- 			-- Crop cannot be harvested by forage harvester yet
	-- 			box:addLine(g_i18n:getText("label_Growth_Stage"), string.format("%s/%s", currentGrowthState, maxGrowthState));
	-- 		end
	-- 	end

	-- 	-- Wheel type info
	-- 	local destructionInfo = self.indexToFruitType[fruitIndex].destruction
	-- 	if (currentGrowthState ~= nil and destructionInfo.filterStart ~= nil and destructionInfo.filterEnd ~= nil) then
	-- 		-- Crops like SugarBeets have the cutState (harvested state) within the bounds of the crop destruction filter. Therefore, explicitly exclude that state
	-- 		local narrowWheelsRequired = currentGrowthState >= destructionInfo.filterStart 
	-- 									and currentGrowthState <= destructionInfo.filterEnd 
	-- 									and currentGrowthState ~= self.indexToFruitType[fruitIndex].cutState
	-- 		local wheelsText = (narrowWheelsRequired and g_i18n:getText("text_Narrow_Wheels")) or g_i18n:getText("text_All_Wheels")
	-- 		box:addLine(g_i18n:getText("label_Required_Wheels"), wheelsText);
	-- 	end
	-- end
end

function GrowthInfo:fieldAddGrowthF(data, box)
	-- if (self.indexToFruitType == nil) then
	-- 	self.indexToFruitType = g_currentMission.fruitTypeManager.indexToFruitType;
	-- end

	if (data == nil or box == nil) then
		print("Debug - cropGrowth: C nill")
		do return end;
	end

	box:addLine("F", "FFF");

	-- nil checks: when field does not contain a crop (plowed/cultivated), fruit data will be nil
	-- local fruitIndex = data.fruitTypeMax;
	-- if (fruitIndex ~= nil and data.fruits ~= nil) then
	-- 	local currentGrowthState = data.fruits[fruitIndex];
	-- 	local maxGrowthState = self.indexToFruitType[fruitIndex].numGrowthStates - 1; -- numGrowthStates includes the harvesting state, therefore -1
		
	-- 	-- Growth stage info
	-- 	if (currentGrowthState ~= nil and currentGrowthState > 0 and currentGrowthState <= maxGrowthState) then
	-- 		-- Crop is in the one of the 'growing' states
	-- 		if (currentGrowthState >= self.indexToFruitType[fruitIndex].minForageGrowthState) then
	-- 			-- Crop can be harvested by forage harvester already
	-- 			box:addLine(g_i18n:getText("label_Growth_Stage"), string.format("%s/%s (%s)", currentGrowthState, maxGrowthState, g_i18n:getText("text_Foragable")));
	-- 		else
	-- 			-- Crop cannot be harvested by forage harvester yet
	-- 			box:addLine(g_i18n:getText("label_Growth_Stage"), string.format("%s/%s", currentGrowthState, maxGrowthState));
	-- 		end
	-- 	end

	-- 	-- Wheel type info
	-- 	local destructionInfo = self.indexToFruitType[fruitIndex].destruction
	-- 	if (currentGrowthState ~= nil and destructionInfo.filterStart ~= nil and destructionInfo.filterEnd ~= nil) then
	-- 		-- Crops like SugarBeets have the cutState (harvested state) within the bounds of the crop destruction filter. Therefore, explicitly exclude that state
	-- 		local narrowWheelsRequired = currentGrowthState >= destructionInfo.filterStart 
	-- 									and currentGrowthState <= destructionInfo.filterEnd 
	-- 									and currentGrowthState ~= self.indexToFruitType[fruitIndex].cutState
	-- 		local wheelsText = (narrowWheelsRequired and g_i18n:getText("text_Narrow_Wheels")) or g_i18n:getText("text_All_Wheels")
	-- 		box:addLine(g_i18n:getText("label_Required_Wheels"), wheelsText);
	-- 	end
	-- end
end


if g_client ~= nil then
	-- client side mod only
	addModEventListener(GrowthInfo);
end
