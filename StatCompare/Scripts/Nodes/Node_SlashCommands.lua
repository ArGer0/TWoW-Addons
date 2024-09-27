--	################################################
--
--	StatCompare
--	by FireBirdSR [DE]Ionsai
--
--	Improved comparison of all character stats
--	Node: Handler for SlashCommands 
--
--	################################################

--- local instance
local thisNode = 	{
						--- the name of this window
						name = "SlashCommands"
					};
 
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- with this method the node will get initialised and connected to the UI frame.<br/><br/>
-- @return <b>boolean</b> - if the initialisation was not successful or the UI frame could not be connected<br/>
function thisNode:init()
	local methodName = self.name .. ":init";
	scUtils:logBegin(methodName);
	local ret = false;

	-- only do register the SlashCommands if the AddonManager is not present because the activity is
	-- handled by the little check button then
	if (not AddonManager) then

		-- create the method to handle slashcommands 
		local slashCommandHandler = function (frameInstance, msg)
			local methodName = "slashCommandHandler";
			scUtils:logBegin(methodName);
		
			-- ask for the reload UI command
			if (msg == "reloadUI") then
				ReloadUI();
				
			-- else toggle the activity node
			else
				local activityNode = statcompare.nodes:getNode("Activity");
				if (activityNode ~= nil and activityNode.toggleActivity) then
					activityNode:toggleActivity();
				end;
			end;
			
			scUtils:logEnd(methodName);
		end;

		-- register SlashCommands with this method
		SLASH_StatCompare1 = "/statcompare"
		SLASH_StatCompare2 = "/SC"
		SlashCmdList["StatCompare"] = function(frameInstance, msg) slashCommandHandler(frameInstance, msg) end;
	
		-- and debug a status message
		scUtils:printDebug(methodName, "SlashCommand handler registered successfully");
		ret = true;
	else
		scUtils:printDebug(methodName, "SlashCommand handler not registered cause the addonmanager is loaded");
	end;
		
	scUtils:logEnd(methodName);
	return ret;
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- at the very end return the local windowInstance for the initial load process
return thisNode;