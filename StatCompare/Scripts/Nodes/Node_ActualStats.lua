--	################################################
--
--	StatCompare
--	by FireBirdSR [DE]Ionsai
--
--	Improved comparison of all character stats
--	Node: Actual stats window 
--
--	################################################

--- local instance
local thisNode = 	{
						--- the name of this window
						name = "ActualStats",
						
						--- the frame instace within the UI
						frameInstance = nil
					};
 
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- this method is called when the character stats are updated.<br/><br/>
-- @param updatedStats - <b>table</b> - the updated stats<br/>
function thisNode:onStatsUpdate(updatedStats)

	-- only do something if the stats are not null
	if (updatedStats ~= nil) then
		self:actualizeValues(updatedStats);
	end;
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- this method handles a onShow event on the frame this node is registered on.<br/><br/>
function thisNode:onShow()

	-- register this frame on the character node for stats update
	local characterNode = statcompare.nodes:getNode("Character");
	characterNode:addNotify(self);
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- this method handles a onHide event on the frame this node is registered on.<br/><br/>
function thisNode:onHide()

	-- remove this frame from the character node
	local characterNode = statcompare.nodes:getNode("Character");
	characterNode:removeNotify(self);
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- this method actualize all values given.<br/><br/>
-- @param valuesToUpdate - <b>table</b> - the stats to update<br/>
function thisNode:actualizeValues(valuesToUpdate)
	local methodName = self.name .. ":actualizeValues";
	scUtils:logBegin(methodName);

	-- only do something if the given values are a table
	if (valuesToUpdate ~= nil and type(valuesToUpdate) == "table") then
	
		-- go thru the table and set the values with the same index
		for key, value in pairs(valuesToUpdate) do
		
			-- try to find the label instance
			local fontInstance = getglobal(self.name .. "_Value_" .. key);
			if (fontInstance ~= nil) then
			
				-- only actualize this font instance if the parent is the frameInstance of this node
				if (fontInstance:GetParent() == self.frameInstance) then
				
					-- only actualize if there is an actualValue present (there is no value if the first
					-- actualize of character stats is not done yet)
					if (value.actualValue) then
					
						-- The resistances should only be printed in simple strings, all others schould be printed
						-- in the detailed way
						if (string.sub(key, 1, string.len("Resistance")) == "Resistance") then
							fontInstance:SetText(value.actualValue:toSimpleString());
						else					
							fontInstance:SetText(value.actualValue:toDetailedString());
						end;
					end;
				end;
			end;
		end;
	end;
		
	scUtils:logEnd(methodName);
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- with this method the node will get initialised and connected to the UI frame.<br/><br/>
-- @return <b>boolean</b> - if the initialisation was not successful or the UI frame could not be connected<br/>
function thisNode:init()
	local methodName = self.name .. ":init";
	scUtils:logBegin(methodName);
	local ret = false;
	
	-- first try to locate the UI frame
	local uiFrame = getglobal("StatCompare_Frame_" .. self.name);
	if (uiFrame ~= nil) then
	
		-- register the instances
		scUtils:printDebug(methodName, "register the instances");
		self.frameInstance = uiFrame;
		uiFrame.nodeAnchor = thisNode;
		
		-- try to set all texts from locale
		scUtils:printDebug(methodName, "try to set all texts from locale");
		local frameTexts = statcompare.locale:getCategory(self.name);
		for key, value in pairs(frameTexts) do
			local fontInstance = getglobal(self.name .. "_" .. key);
			if (fontInstance ~= nil) then
				fontInstance:SetText(value);
			end;
		end;

		-- if everthing is ok, return true
		ret = true;
	end;
		
	scUtils:logEnd(methodName);
	return ret;
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- at the very end return the local windowInstance for the initial load process
return thisNode;