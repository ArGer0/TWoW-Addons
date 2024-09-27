--	################################################
--
--	StatCompare
--	by FireBirdSR [DE]Ionsai
--
--	Improved comparison of all character stats
--	Node: Activity Handler 
--
--	################################################

--- local instance
local thisNode = 	{
						--- the name of this window
						name = "Activity",
						
						--- the configuration table
						configuration = {},
						
						--- the list of node to activate and deactivate
						nodeList = scUtils:OrderedTable()
					};
 
-- init the default configuration of this window instance
thisNode.configuration["ACTIVITY"] = true;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- like the name said, this method checks if the node (and the complete function of this addon) is active.<br/><br/>
-- @return <b>boolean</b> - TRUE means that the node is active<br/>
function thisNode:isActive()

	-- simply check the configuration entry
	return thisNode.configuration["ACTIVITY"];
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- like the name said, this method toggles the activity of this node (and therefore the functionality of the whole addon).<br/><br/>
function thisNode:toggleActivity()
	local methodName = self.name .. ":toggleActivity";
	scUtils:logBegin(methodName);

	-- toggle the activity-field
	thisNode.configuration["ACTIVITY"] = not thisNode.configuration["ACTIVITY"];

	-- if this node is active then deactivate all registered nodes, otherwise activate they
	if (self:isActive() == false) then
		for nodeName, nodeInstance in self.nodeList:pairs() do
			if (nodeInstance ~= nil and nodeInstance.deactivate ~= nil) then
				nodeInstance:deactivate();
			end;
		end;
		scUtils:print(statcompare.locale:getText("MESSAGES", "SWITCHED_OFF"));
	else
		for nodeName, nodeInstance in self.nodeList:pairs() do
			if (nodeInstance ~= nil and nodeInstance.activate ~= nil) then
				nodeInstance:activate();
			end;
		end;
		scUtils:print(statcompare.locale:getText("MESSAGES", "SWITCHED_ON"));
	end;
		
	-- save the configuration because the changed activity status is a part of it
	statcompare.config:saveConfig();
	
	scUtils:logEnd(methodName);
end;

--- this method activates StatCompare
function thisNode:activate()
	if (self:isActive() == false) then
		self:toggleActivity();
	end;
end;

--- this method deactivates StatCompare
function thisNode:deactivate()
	if (self:isActive() == true) then
		self:toggleActivity();
	end;
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- with this method the node will get initialised and connected to the UI frame.<br/><br/>
-- @return <b>boolean</b> - if the initialisation was not successful or the UI frame could not be connected<br/>
function thisNode:init()
	local methodName = self.name .. ":init";
	scUtils:logBegin(methodName);
	local ret = false;

	-- load all nodes which should be observed into the nodelist
	self.nodeList["AnchorFrame"] = statcompare.nodes:getNode("AnchorFrame");
	self.nodeList["ActualClasses"] = statcompare.nodes:getNode("ActualClasses");
	self.nodeList["Character"] = statcompare.nodes:getNode("Character");

	-- if this node is active then deactivate all registered nodes, otherwise activate they
	if (self:isActive() == true) then
		for nodeName, nodeInstance in self.nodeList:pairs() do
			if (nodeInstance ~= nil and nodeInstance.activate ~= nil) then
				nodeInstance:activate();
			end;
		end;
		scUtils:print(statcompare.locale:getText("MESSAGES", "WELCOME_ON"));
	else
		scUtils:print(statcompare.locale:getText("MESSAGES", "WELCOME_OFF"));
	end;

	-- if everything is done simply return true
	ret = true;
		
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