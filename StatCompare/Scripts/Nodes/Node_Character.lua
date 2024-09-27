--	################################################
--
--	StatCompare
--	by FireBirdSR [DE]Ionsai
--
--	Improved comparison of all character stats
--	Node: Character stats node 
--
--	################################################

--- local instance
local thisNode = 	{
						--- the name of this window
						name = "Character",
						
						--- the activity switch
						activity = false,
						
						--- the configuration table
						configuration = {},
						
						--- this is the list of nodes which wants to be notified if there are stats changes
						nodesToNotify = scUtils:OrderedTable(),
	
						--- the table for stat handling
						characterStats = 	{
												--- the timer instance for update
												lastUpdated = nil,

												--- the complete table with all stats objects
												statsTable = nil,
							
												--- a local copy for all stats which has changed at last update point
												actualizedStats = {}
											}
					};
 
-- init the default configuration of this window instance
thisNode.configuration["UPDATE"] = 0.3;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- this method is called when the general frame is updated.<br/><br/>
function thisNode:onUpdate()
	local methodName = self.name .. ":onUpdate";

	-- only do something this instance is active and the original character frame is visible
	-- (the onShow and onHide events doesn't work on the inner frames. therefore check the visibility of the
	-- original character frame. if this is not visible yet, there is no reason for updaing the character stats.
	-- I khnow, that is a recurcive dependency, but I don't know, how to resolve it.)
	local characterIsVisible = getglobal("CharacterFrame") ~= nil and getglobal("CharacterFrame"):IsVisible();
	if (self.activity == true and characterIsVisible == true) then
		
		-- if the updateTimer is reached, then actualize all statistics and reset the updateTimer
		local actualTime = GetTime();
		if (self.characterStats.lastUpdated == nil or actualTime - self.characterStats.lastUpdated > self.configuration["UPDATE"]) then
		
			-- clean the changed-table
			self.characterStats.actualizedStats = {};
		
			-- update all character stats referenced in this instance
			for statName, statInstance in pairs(self.characterStats.statsTable) do
				local changed = statInstance:actualize();
				if (changed == true) then
					self.characterStats.actualizedStats[statName] = statInstance;
				end;
			end;
			
			-- go thru the whole table of observer nodes and call the update method on every node
			for nodeName, nodeInstance in self.nodesToNotify:pairs() do
				if (nodeInstance ~= nil and nodeInstance.onStatsUpdate) then
					nodeInstance:onStatsUpdate(self.characterStats.actualizedStats);
				end;
			end;
			
			-- set the last updated time
			self.characterStats.lastUpdated = GetTime();
		end;
	end;
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- this method adds one node to the list of nodes to notify<br/><br/>
-- @param nodeToNotify - <b>table</b> - the node which should be notified every time the stats updated<br/>
function thisNode:addNotify(nodeToNotify)
	local methodName = self.name .. ":addNotify";
	scUtils:logBegin(methodName);

	-- only add this instance if it has the onStatsUpdate method and the name attribute
	if (nodeToNotify ~= null and type(nodeToNotify) == "table" and nodeToNotify.onStatsUpdate and nodeToNotify.name) then
	
		-- add the node to the liste to notify
		self.nodesToNotify[nodeToNotify.name] = nodeToNotify;
		
		-- and call the update method with all character stats
		nodeToNotify:onStatsUpdate(self.characterStats.statsTable);
	end;

	scUtils:logEnd(methodName);
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- this method removes one node from the list of nodes to notify<br/><br/>
-- @param nodeToRemove - <b>table</b> - the node which should be removed from the update notifier<br/>
function thisNode:removeNotify(nodeToRemove)
	local methodName = self.name .. ":removeNotify";
	scUtils:logBegin(methodName);

	-- is only possible if the name attribute is set
	if (nodeToRemove ~= null and type(nodeToRemove) == "table" and nodeToRemove.name) then
		self.nodesToNotify:remove(nodeToRemove.name);
	end;

	scUtils:logEnd(methodName);
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- this method proves if the is a point of comparison is set yet.<br/><br/>
function thisNode:isComparePointAvailable()
	
	-- the return value
	local ret = false;
	
	-- check every element of the actual stats table for saved values 
	for statName, statInstance in pairs(self.characterStats.statsTable) do
		if (statInstance.savedValue and statInstance.savedValue ~= nil) then
			ret = true;
		end;
	end;

	-- and return the value
	return ret;	
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- this method saves the actual stats as a point of comparison.<br/><br/>
function thisNode:saveComparePoint()
	local methodName = self.name .. ":saveComparePoint";
	scUtils:logBegin(methodName);

	-- go thru all stats and call the save method 
	for statName, statInstance in pairs(self.characterStats.statsTable) do
		if (statInstance.saveValues) then
			statInstance:saveValues();
		end;
	end;

	-- and now notify all nodes which are registered to this instance with the complete stats array
	-- because there is the possibility that they have to actualize all values to display
	for nodeName, nodeInstance in self.nodesToNotify:pairs() do
		if (nodeInstance ~= nil and nodeInstance.onStatsUpdate) then
			nodeInstance:onStatsUpdate(self.characterStats.statsTable);
		end;
	end;

	scUtils:logEnd(methodName);
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- this method activates the update of the stats.<br/><br/>
function thisNode:activate()
	local methodName = self.name .. ":activate";
	scUtils:logBegin(methodName);

	-- simply set the activity to true
	self.activity = true;
	
	-- and register this node instance to the general updateHandler
	statcompare.updateHandler:add(thisNode);
		
	scUtils:logEnd(methodName);
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- this method switches the handling of update method off.<br/><br/>
function thisNode:deactivate()
	local methodName = self.name .. ":deactivate";
	scUtils:logBegin(methodName);

	-- simply set the activity to false
	self.activity = false;

	-- reset the last UpdateTimer
	self.characterStats.lastUpdated = nil;

	-- and remove this node instance from the general updateHandler
	statcompare.updateHandler:remove(thisNode);
		
	scUtils:logEnd(methodName);
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- with this method the node will get initialised.<br/><br/>
-- @return <b>boolean</b> - if the initialisation was successful<br/>
function thisNode:init()
	local methodName = self.name .. ":init";
	scUtils:logBegin(methodName);
	local ret = true;

	-- create the table for the character stats
	scUtils:printDebug(methodName, "create the table for the character stats");
	self.characterStats.statsTable = {};

	-- fill identifier values into table
	scUtils:printDebug(methodName, "fill identifier values into table");
	local nameActualizeMethod = function()
		return UnitName("player"), UnitTitle("player");
	end; 
	self.characterStats.statsTable["Name"] = statcompare.character.CharacterIdentifier:create("Name", nameActualizeMethod);
	local mainActualizeMethod = function() 
		local mainClass, secondClass = UnitClass("player");
		local mainLvl, secondLvl = UnitLevel("player");
		return mainClass, mainLvl;
	end;
	self.characterStats.statsTable["MainClass"] = statcompare.character.CharacterIdentifier:create("MainClass", mainActualizeMethod);
	local secondActualizeMethod = function() 
		local mainClass, secondClass = UnitClass("player");
		local mainLvl, secondLvl = UnitLevel("player");
		return secondClass, secondLvl;
	end;
	self.characterStats.statsTable["SecondClass"] = statcompare.character.CharacterIdentifier:create("SecondClass", secondActualizeMethod);
	local reputationActualizeMethod = function() 
		return GetPlayerGoodEvil(), "";
	end;
	self.characterStats.statsTable["Reputation"] = statcompare.character.CharacterIdentifier:create("Reputation", reputationActualizeMethod);
	local honorActualizeMethod = function() 
		return GetPlayerHonorPoint(), "";
	end;
	self.characterStats.statsTable["Honor"] = statcompare.character.CharacterIdentifier:create("Honor", honorActualizeMethod);

	-- then get the character abilities
	scUtils:printDebug(methodName, "fill ability values into table");
	self.characterStats.statsTable["Strength"] = statcompare.character.CharacterAbility:create("STR");
	self.characterStats.statsTable["Agility"] = statcompare.character.CharacterAbility:create("AGI");
	self.characterStats.statsTable["Stamina"] = statcompare.character.CharacterAbility:create("STA");
	self.characterStats.statsTable["Intelligence"] = statcompare.character.CharacterAbility:create("INT");
	self.characterStats.statsTable["Mind"] = statcompare.character.CharacterAbility:create("MND");

	-- then get the dps value
	self.characterStats.statsTable["Dps"] = statcompare.character.CharacterAbility:create("DPS");

	-- then get the melee fight statistics
	self.characterStats.statsTable["Melee_Damage"] = statcompare.character.CharacterAbility:create("MELEE_MAIN_DAMAGE");
	self.characterStats.statsTable["Melee_Attack"] = statcompare.character.CharacterAbility:create("MELEE_ATTACK");
	self.characterStats.statsTable["Melee_Critical"] = statcompare.character.CharacterAbility:create("MELEE_CRITICAL");
	self.characterStats.statsTable["Melee_Hit"] = statcompare.character.CharacterAbility:create("PHYSICAL_HIT");

	-- then get the range fight statistics
	self.characterStats.statsTable["Range_Damage"] = statcompare.character.CharacterAbility:create("RANGE_DAMAGE");
	self.characterStats.statsTable["Range_Attack"] = statcompare.character.CharacterAbility:create("RANGE_ATTACK");
	self.characterStats.statsTable["Range_Critical"] = statcompare.character.CharacterAbility:create("RANGE_CRITICAL");
	self.characterStats.statsTable["Range_Hit"] = statcompare.character.CharacterAbility:create("PHYSICAL_HIT");

	-- then get the magical fight statistics
	self.characterStats.statsTable["Magical_Damage"] = statcompare.character.CharacterAbility:create("MAGIC_DAMAGE");
	self.characterStats.statsTable["Magical_Attack"] = statcompare.character.CharacterAbility:create("MAGIC_ATTACK");
	self.characterStats.statsTable["Magical_Critical"] = statcompare.character.CharacterAbility:create("MAGIC_CRITICAL");
	self.characterStats.statsTable["Magical_Heal"] = statcompare.character.CharacterAbility:create("MAGIC_HEAL");
	self.characterStats.statsTable["Magical_Hit"] = statcompare.character.CharacterAbility:create("MAGIC_HIT");

	-- then get the physical defence
	self.characterStats.statsTable["Physical_Defense"] = statcompare.character.CharacterAbility:create("PHYSICAL_DEFENCE");
	self.characterStats.statsTable["Physical_Parry"] = statcompare.character.CharacterAbility:create("PHYSICAL_PARRY");
	self.characterStats.statsTable["Physical_Dodge"] = statcompare.character.CharacterAbility:create("PHYSICAL_DODGE");
	self.characterStats.statsTable["Physical_Critical"] = statcompare.character.CharacterAbility:create("PHYSICAL_RESIST_CRITICAL");

	-- then get the magical defence
	self.characterStats.statsTable["Magical_Defense"] = statcompare.character.CharacterAbility:create("MAGIC_DEFENCE");
	self.characterStats.statsTable["Magical_Dodge"] = statcompare.character.CharacterAbility:create("MAGIC_DODGE");
	self.characterStats.statsTable["Magical_Resist_Critical"] = statcompare.character.CharacterAbility:create("MAGIC_RESIST_CRITICAL");

	-- after ths try to get the resistences
	scUtils:printDebug(methodName, "fill resistance values into table");
	self.characterStats.statsTable["Resistance_Earth"] = statcompare.character.CharacterResistance:create("EARTH");
	self.characterStats.statsTable["Resistance_Water"] = statcompare.character.CharacterResistance:create("WATER");
	self.characterStats.statsTable["Resistance_Fire"] = statcompare.character.CharacterResistance:create("FIRE");
	self.characterStats.statsTable["Resistance_Wind"] = statcompare.character.CharacterResistance:create("WIND");
	self.characterStats.statsTable["Resistance_Light"] = statcompare.character.CharacterResistance:create("LIGHT");
	self.characterStats.statsTable["Resistance_Dark"] = statcompare.character.CharacterResistance:create("DARK");
		
	scUtils:logEnd(methodName);
	return ret;
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- this method applies the given configuration to this node instance.<br/><br/>
-- @param settings <b>table</b> - the settings for this node<br/>
function thisNode:applyConfiguration(settings)
	local methodName = self.name .. ":applyConfiguration";
	scUtils:logBegin(methodName);
	
	-- only do something if the given settings are of type table
	if (type(settings) ~= "table") then
		scUtils:printDebug(methodName, "the given settings is not of type table");

	else
		-- overwrite the value for every key that is remembered in the default configuration
		for key, value in pairs(self.configuration) do
			local newValue = settings[key];
			if (newValue ~= nil) then
				self.configuration[key] = newValue;
			end;
		end;
	end;
	
	scUtils:logEnd(methodName);
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- this method return the configuration from this node.<br/><br/>
-- @return <b>table</b> - the settings from this nodes<br/>
function thisNode:getConfiguration()
	local methodName = self.name .. ":getConfiguration";
	scUtils:logBegin(methodName);
	local ret = {};
	
	-- simply return the configuration table from the instance table
	ret = self.configuration;
	
	scUtils:logEnd(methodName);
	return ret;
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- at the very end return the local windowInstance for the initial load process
return thisNode;