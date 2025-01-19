-- Author:svenp (sven.pegels@gmail.com)
-- Name:Crop Growth Stage Info
-- Version: 1.1.0.0
-- Description: Script mod for displaying the exact growth stage of the field currently standing on, and which type of tires are required
-- Icon:
-- Hide: no
-- Credits to Yumi/Yumi-Modding's 'Additional Field Info' mod for showing the proper way of adding lines to the field info box

GrowthInfo = {};

function GrowthInfo:loadMap(name)
	print("Info - GrowthInfo: Loading mod")
	if not g_modIsLoaded["FS22_precisionFarming"] then
		print("Info - GrowthInfo: Precision Farming DLC not present")
		PlayerHUDUpdater.fieldAddFruit = Utils.appendedFunction(PlayerHUDUpdater.fieldAddFruit, GrowthInfo.fieldAddGrowth);
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
	if (self.fruitTypes == nil) then
		self.fruitTypes = g_currentMission.fruitTypeManager.indexToFruitType;
	end

	if (data == nil or box == nil) then
		do return end;
	end

	-- nil checks: when field does not contain a crop (plowed/cultivated), fruit data will be nil
	local fruitIndex = data.fruitTypeMax;
	if (fruitIndex ~= nil and data.fruits ~= nil) then
		local currentGrowthState = data.fruits[fruitIndex];
		local maxGrowthState = self.fruitTypes[fruitIndex].numGrowthStates - 1; -- numGrowthStates includes the harvesting state, therefore -1
		
		-- Growth stage info
		if (currentGrowthState ~= nil and currentGrowthState > 0 and currentGrowthState <= maxGrowthState) then
			-- Crop is in the one of the 'growing' states
			if (currentGrowthState >= self.fruitTypes[fruitIndex].minForageGrowthState) then
				-- Crop can be harvested by forage harvester already
				box:addLine(g_i18n:getText("label_Growth_Stage"), string.format("%s/%s (%s)", currentGrowthState, maxGrowthState, g_i18n:getText("text_Foragable")));
			else
				-- Crop cannot be harvested by forage harvester yet
				box:addLine(g_i18n:getText("label_Growth_Stage"), string.format("%s/%s", currentGrowthState, maxGrowthState));
			end
		end

		-- Wheel type info
		local destructionInfo = self.fruitTypes[fruitIndex].destruction
		if (currentGrowthState ~= nil and destructionInfo.filterStart ~= nil and destructionInfo.filterEnd ~= nil) then
			-- Crops like SugarBeets have the cutState (harvested state) within the bounds of the crop destruction filter. Therefore, explicitly exclude that state
			local narrowWheelsRequired = currentGrowthState >= destructionInfo.filterStart 
										and currentGrowthState <= destructionInfo.filterEnd 
										and currentGrowthState ~= self.fruitTypes[fruitIndex].cutState
			local wheelsText = (narrowWheelsRequired and g_i18n:getText("text_Narrow_Wheels")) or g_i18n:getText("text_All_Wheels")
			box:addLine(g_i18n:getText("label_Required_Wheels"), wheelsText);
		end
	end
end


if g_client ~= nil then
	-- client side mod only
	addModEventListener(GrowthInfo);
end
