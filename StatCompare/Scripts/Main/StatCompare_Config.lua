--	################################################
--
--	StatCompare
--	by FireBirdSR [DE]Ionsai
--
--	Improved comparison of all character stats 
--
--	################################################

--- this is for the ROM API SaveVariables method because it really does not function correctly if
-- we use "object orientated" values
statcompareConfig = {};

--- the configuration class for StatCompare addon
statcompare.config = {};

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- this method checks if the configuration is loaded and create a default configuration if no
-- configuration node is got<br/><br/>
-- @return <b>boolean</b> - true if everything is ok<br/>
function statcompare.config:checkConfig()
	local methodName = "statcompare.config:checkConfig";
	scUtils:logBegin(methodName);
	local ret = true;

	-- if the varaibles were not set during the load process set the default coniguration
	-- (do the same if the version is not correct properly)
	local createNewConfig = false;
	createNewConfig = createNewConfig or statcompareConfig == nil;
	createNewConfig = createNewConfig or statcompareConfig["version"] == nil;
	createNewConfig = createNewConfig or statcompareConfig["version"] ~= statcompare.identifier.version;
	
	if (createNewConfig == true) then
		scUtils:print(statcompare.locale:getText("MESSAGES", "NEW_CONFIG"));
		
		-- create new Config node
		statcompareConfig = {};
		
		-- set the version of addon
		statcompareConfig["version"] = statcompare.identifier.version;
		
		-- save the structure to ROM file
		SaveVariables("statcompareConfig");
		scUtils:printDebug(methodName, "Config saved");
	end;

	scUtils:logEnd(methodName);
	return true;
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- this method checks if the configuration is loaded and applys the default configuration if no
-- configuration node got
function statcompare.config:saveConfig()
	local methodName = "statcompare.config:saveConfig";
	scUtils:logBegin(methodName);

	-- only do something if the config is initialized
	if (not statcompareConfig or statcompareConfig == nil or statcompareConfig["version"] == nil) then
		scUtils:print(statcompare.locale:getText("ERRORS", "CONFIG_NOT_EXISTS"));
	
	-- else collect the configuration from the nodes and save it
	else
		-- collect the configuration from the nodes
		statcompareConfig["nodes"] = statcompare.nodes:collectConfiguration();
	
		-- save the structure to ROM file
		SaveVariables("statcompareConfig");
		scUtils:printDebug(methodName, "Config saved");
	end;

	scUtils:logEnd(methodName);
end;


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- this method simply returns the configuration for this addon<br/><br/>
-- @return <b>table</b> - the whole configuration table<br/>
function statcompare.config:getSettings()
	return statcompareConfig;
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- this method returns the configuration for one special node<br/><br/>
-- @return <b>table</b> - the configuration table for this node. NIL if the config for the 
-- 						specified node could not be found<br/>
function statcompare.config:getSettingsForNode(nodeName)
	local methodName = "statcompare.config:getSettingsForNode";
	scUtils:logBegin(methodName);
	local ret = nil;
	
	-- get the table for the nodes
	local nodeTable = statcompareConfig["nodes"];
	
	-- go thru this table and search for nodeName
	if (nodeTable ~= nil and type(nodeTable) == "table") then
		for settingsKey, settingsValue in pairs(nodeTable) do
			if (settingsKey == nodeName and settingsValue ~= nil) then
				ret = settingsValue;
			end;
		end;
	end;
	
	scUtils:logEnd(methodName);
	return ret;
end;