--	################################################
--
--	GuiUtils
--	by FireBirdSR [DE]Ionsai
--
--	provides utilities for handling ROM GUI elements
--
--	################################################

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- this method tries to store the current anchor point into a variable within the gui instance<br/><br/>
-- @param guiInstance <b>table</b> - the intstance of the gui element<br/><br/>
function scUtils:rememberAnchor(guiInstance)

	-- if this instance is a table 
	if (guiInstance ~= nil and type(guiInstance) == "table") then
	
		-- try to get the current anchor point for later restore
		if (guiInstance.GetAnchor) then
		
			-- create a table and fill the anchor values
			local o = {};
			o.anchorPoint, o.relativePoint, o.parentFrame, o.x, o.y = guiInstance:GetAnchor();
			
			-- the relativeTo should be a name
			if (o.parentFrame ~= nil and o.parentFrame.GetName) then
				o.parentFrame = o.parentFrame:GetName();
			end;
			
			-- store this table within the gui instance
			guiInstance.originalAnchor = o;
		end;
	end;
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- this method tries to restore the remembered anchor point of a gui instance<br/><br/>
-- @param guiInstance <b>table</b> - the intstance of the gui element<br/><br/>
function scUtils:restoreAnchor(guiInstance)

	-- if this instance is a table 
	if (guiInstance ~= nil and type(guiInstance) == "table") then
	
		-- only do something if the anchor point is remembered fromerly
		if (guiInstance.originalAnchor) then
		
			local o = guiInstance.originalAnchor;
		
			-- set the original anchor
			guiInstance:ClearAllAnchors();
			guiInstance:SetAnchor(o.anchorPoint, o.relativePoint, o.parentFrame, o.x, o.y);
		end;
	end;
end;
