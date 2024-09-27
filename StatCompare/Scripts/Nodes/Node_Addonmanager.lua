--	################################################
--
--	StatCompare
--	by FireBirdSR [DE]Ionsai
--
--	Improved comparison of all character stats
--	Node: Handler for registering statcompare to the great AddonManager written by Alleris 
--
--	################################################

--- local instance
local thisNode = 	{
						--- the name of this window
						name = "Addonmanager"
					};
 
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- with this method the node will get initialised and connected to the UI frame.<br/><br/>
-- @return <b>boolean</b> - if the initialisation was not successful or the UI frame could not be connected<br/>
function thisNode:init()
	local methodName = self.name .. ":init";
	scUtils:logBegin(methodName);

	-- only do something if the AddonManager is present yet
	if (AddonManager) then
	
		-- the description text from the locale instance
		local descriptionText = statcompare.locale:getText(self.name, "Description");
		
		-- the activate method
		local activateMethod = function()
			local activityNode = statcompare.nodes:getNode("Activity");
			activityNode:activate();
		end;
		
		-- and the deactivate method
		local deactivateMethod = function()
			local activityNode = statcompare.nodes:getNode("Activity");
			activityNode:deactivate();
		end;

		-- the table for descriping the addon 
		local addon = {
				            name = statcompare.identifier.name,
				            description = descriptionText,
				            category = "Leveling",
				            version = statcompare.identifier.version,
				            author = statcompare.identifier.author,
							miniButton = nil,
							onClickScript = nil;
				            enableScript = activateMethod,
				            disableScript = deactivateMethod,
				            icon = statcompare.identifier.path .. "/Images/StatCompare_Logo.tga",
		};
		
		-- if the method for registering addon by the complete table is present then use it otherwise
		-- register the addon with the explicit values
		if (AddonManager.RegisterAddonTable) then
			AddonManager.RegisterAddonTable(addon);
		else
			AddonManager.RegisterAddon(addon.name, addon.description, addon.icon, addon.category, addon.configFrame, addon.slashCommands, addon.miniButton, addon.onClickScript);
		end;
		
		-- addonmanager enables the registered addons by default. Therefore StatCompare has to be
		-- activated at start, so simply call the activate method
		activateMethod();
		
		-- then debug the registering
		scUtils:printDebug(methodName, "StatCompare successfully registered to AddonManager");
	end;
		
	scUtils:logEnd(methodName);
	return true;
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- at the very end return the local windowInstance for the initial load process
return thisNode;