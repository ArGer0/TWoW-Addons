--	################################################
--
--	StatCompare
--	by FireBirdSR [DE]Ionsai
--
--	Improved comparison of all character stats 
--
--	################################################

--- node namespace of statCompare Addon
statcompare.nodes = 	{
							--- the table with loaded nodes
							nodelist = scUtils:OrderedTable()
						};


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- this method initially loads all nodes needed.<br/><br/>
-- @return <b>boolean</b> - true if everything is ok, false if the loading process gets errors<br/>
function statcompare.nodes:loadNodes()
	local methodName = "statcompare.nodes:loadNodes";
	scUtils:logBegin(methodName);
	local ret = false;

	-- load all nodes
	ret = true and self:loadOne("Node_Character.lua");
	ret = ret and self:loadOne("Node_AnchorFrame.lua");
	ret = ret and self:loadOne("Node_ActualStats.lua");
	ret = ret and self:loadOne("Node_SavedStats.lua");
	ret = ret and self:loadOne("Node_ComparedStats.lua");
	ret = ret and self:loadOne("Node_ActualClasses.lua");
	ret = ret and self:loadOne("Node_Activity.lua");
	ret = ret and self:loadOne("Node_ResetComparePoint.lua");
	ret = ret and self:loadOne("Node_ToggleCompare.lua");
	ret = ret and self:loadOne("Node_Addonmanager.lua");
	ret = ret and self:loadOne("Node_SlashCommands.lua");

	-- go thru all loaded nodes and apply the config to it
	if (ret == true) then
		for nodeName, nodeInstance in self.nodelist:pairs() do
			local nodeConfig = statcompare.config:getSettingsForNode(nodeName);
			if (nodeConfig ~= nil and nodeInstance.applyConfiguration ~= nil) then
				nodeInstance:applyConfiguration(nodeConfig);
			end;
		end;
	end;

	-- call the initilization method on every node loaded
	if (ret == true) then
		for nodeName, nodeInstance in self.nodelist:pairs() do
			if (ret == true and nodeInstance.init ~= nil) then
				ret = nodeInstance:init();
			end;
		end;
	end;

	-- save the configuration because the default configuration of all nodes schould be wrote back
	statcompare.config:saveConfig();

	scUtils:logEnd(methodName);
	return ret;
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- this method loads a node in one file and add it to the nodelist table.<br/><br/>
-- @param fileToLoad <b>string</b> - the filename to load (without path)<br/>
-- @return <b>boolean</b> - true if everything is ok, false if the loading process gets errors<br/>
function statcompare.nodes:loadOne(fileToLoad)
	local methodName = "statcompare.nodes:loadOne";
	scUtils:logBegin(methodName);
	local ret = false;

	-- the path to the file to load
	local fileName = statcompare.identifier.path .. "/Scripts/Nodes/" .. fileToLoad;

	-- try to load the file
	local func, err = scUtils:loadFile(fileName);
	
	-- if an error occurs simply return "false"
	if (err) then
		ret = false;
		
	-- else try to parse the file to a node instance
	else
		local nodeInstance = dofile(fileName);
		if (nodeInstance ~= nil and nodeInstance.name ~= nil) then
			self.nodelist[nodeInstance.name] = nodeInstance;
			ret = true;
		end;
	end;

	scUtils:logEnd(methodName);
	return ret;
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- this method collects the configuration from all nodes in the nodelist.<br/><br/>
-- @return <b>table</b> - the settings from the nodes (indiced by nodeName)<br/>
function statcompare.nodes:collectConfiguration()
	local methodName = "statcompare.nodes:collectConfiguration";
	scUtils:logBegin(methodName);
	local ret = {};

	-- simple go thru the nodes table and get the configuration from every one
	for nodeName, nodeInstance in self.nodelist:pairs() do
		if (nodeInstance.getConfiguration ~= nil) then
			local nodeConfig = nodeInstance:getConfiguration();
			if (nodeConfig ~= nil) then
				ret[nodeName] = nodeConfig;
			end;
		end;
	end;

	scUtils:logEnd(methodName);
	return ret;
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- this method return a node with a specefied name from the list if this node is already loaded.<br/><br/>
-- @param nodename <b>string</b> - the name of the node<br/>
-- @return <b>table</b> - the node instance<br/>
function statcompare.nodes:getNode(nodeName)
	local methodName = "statcompare.nodes:getNode";
	local ret = {};

	-- only do something if the given parameter is not null
	if (nodeName ~= nil) then

		-- simple get the named node from node table and refer the return value to it
		local nodeInstance = self.nodelist[nodeName];
		if (nodeInstance ~= nil) then
			ret = nodeInstance;
		else
			scUtils:printDebug(methodName, "the requested node could not be found");
		end;
	end;

	return ret;
end;


