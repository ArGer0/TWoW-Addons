--	################################################
--
--	StatCompare
--	by FireBirdSR [DE]Ionsai
--
--	Improved comparison of all character stats
--	Node: ButtonHandler for reset compare point button 
--
--	################################################

--- local instance
local thisNode = 	{
						--- the name of this window
						name = "ResetComparePoint",
						
						--- the button instance within the UI
						uiInstance = nil
					};
 
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- this method makes the uiInstance visible.<br/><br/>
function thisNode:show()
	if (self.uiInstance ~= nil) then
		self.uiInstance:Show();
	end;
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- this method makes the uiInstance invisible.<br/><br/>
function thisNode:hide()
	if (self.uiInstance ~= nil) then
		self.uiInstance:Hide();
	end;
end;
 
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- this method handles a onClick event on the frame this node is registered on.<br/><br/>
function thisNode:onClick()
	local methodName = self.name .. ":onClick";
	scUtils:logBegin(methodName);

	-- simply call the save method on character node 
	local characterNode = statcompare.nodes:getNode("Character");
	characterNode:saveComparePoint();
	
	scUtils:logEnd(methodName);
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- this method handles a onEnter event on the frame this node is registered on.<br/><br/>
function thisNode:onEnter()

	-- create a tooltip anchored to this button
	GameTooltip:ClearAllAnchors();
	GameTooltip:SetOwner(self.uiInstance, "ANCHOR_RIGHT", -3, -30);
	GameTooltip:ClearLines();

	GameTooltip:SetText(statcompare.locale:getText(self.name, "Tooltip"));
	GameTooltip:Show();
	
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- this method handles a onLeave event on the frame this node is registered on.<br/><br/>
function thisNode:onLeave()

	-- simply hide the game tooltip
	GameTooltip:Hide();
	
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- with this method the node will get initialised and connected to the UI element.<br/><br/>
-- @return <b>boolean</b> - if the initialisation was not successful or the UI element could not be connected<br/>
function thisNode:init()
	local methodName = self.name .. ":init";
	scUtils:logBegin(methodName);
	local ret = false;
	
	-- first try to locate the UI element
	local uiElement = getglobal("StatCompare_Button_" .. self.name);
	if (uiElement ~= nil) then
	
		-- register the instances
		scUtils:printDebug(methodName, "register the instances");
		self.uiInstance = uiElement;
		uiElement.nodeAnchor = thisNode;
		
		-- try to set the button text from locale
		scUtils:printDebug(methodName, "try to set the button text from locale");
		local frameTexts = statcompare.locale:getText(self.name, "Label");
		self.uiInstance:SetText(frameTexts);
		
		-- if everthing is ok, return true
		ret = true;
	end;
		
	scUtils:logEnd(methodName);
	return ret;
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- at the very end return the local windowInstance for the initial load process
return thisNode;