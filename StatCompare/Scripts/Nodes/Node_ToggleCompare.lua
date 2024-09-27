--	################################################
--
--	StatCompare
--	by FireBirdSR [DE]Ionsai
--
--	Improved comparison of all character stats
--	Node: ButtonHandler for toggle compare button 
--
--	################################################

--- local instance
local thisNode = 	{
						--- the name of this window
						name = "ToggleCompare",
						
						--- the actual status of the button
						status = false, 
						
						--- the button instance within the UI
						uiInstance = nil
					};
 
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- this method handles a onClick event on the frame this node is registered on.<br/><br/>
function thisNode:onClick()

	-- simply switch the status
	self.status = not self.status;

	-- and handle the switched status
	self:handleButtonStatus();
	
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- this method handles the status of the registered button.<br/><br/>
function thisNode:handleButtonStatus()
	local methodName = self.name .. ":handleButtonStatus";
	scUtils:logBegin(methodName);

	-- only do something if the uiElement is registered
	if (self.uiInstance ~= nil) then

		-- first do the changes to the button text and tooltip
		scUtils:printDebug(methodName, "handle textual changes on UI-element");

		-- get the text for actual status from the locale instance and set the text to the uiElement	
		local statusText = "Label_" .. tostring(self.status);
		local labelText = statcompare.locale:getText(self.name, statusText);
		self.uiInstance:SetText(labelText);
		
		-- if the tooltip is visible for this button call the onLeave and onEnter events for reloading 
		-- the tooltip text with the new status
		if (GameTooltip:IsVisible() == true) then
			self:onLeave();
			self:onEnter();
		end;

		-- then call the save method on character node if there is no compare point yet
		-- get the character node and check for compare point
		if (self.status == true) then 
			local characterNode = statcompare.nodes:getNode("Character");
			if (not characterNode:isComparePointAvailable()) then
				scUtils:printDebug(methodName, "remember point of comparison");
				characterNode:saveComparePoint();
			else
				scUtils:printDebug(methodName, "a point of comparison is already set");
			end;
		end;

		-- now show or hide the compare stats node and the button for reset saved stats
		local comparedStatsNode = statcompare.nodes:getNode("ComparedStats");
		local savedStatsNode = statcompare.nodes:getNode("SavedStats");
		local resetComparePointNode = statcompare.nodes:getNode("ResetComparePoint");

		if (self.status == true) then 
			scUtils:printDebug(methodName, "make the compare nodes visible");
			comparedStatsNode:show();
			savedStatsNode:show();
			resetComparePointNode:show();
		else
			scUtils:printDebug(methodName, "hide the compare nodes");
			comparedStatsNode:hide();
			savedStatsNode:hide();
			resetComparePointNode:hide();
		end;
		
	end;
	
	scUtils:logEnd(methodName);
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- this method handles a onEnter event on the frame this node is registered on.<br/><br/>
function thisNode:onEnter()

	-- create a tooltip anchored to this button
	GameTooltip:ClearAllAnchors();
	GameTooltip:SetOwner(self.uiInstance, "ANCHOR_RIGHT", -3, -30);
	GameTooltip:ClearLines();

	local tooltipText = "Tooltip_" .. tostring(self.status);
	GameTooltip:SetText(statcompare.locale:getText(self.name, tooltipText));
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
		
		-- try to handle the actual status
		scUtils:printDebug(methodName, "try to handle the actual status");
		self:handleButtonStatus();
		
		-- if everthing is ok, return true
		ret = true;
	end;
		
	scUtils:logEnd(methodName);
	return ret;
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- at the very end return the local windowInstance for the initial load process
return thisNode;