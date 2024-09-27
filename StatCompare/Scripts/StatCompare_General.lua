--	################################################
--
--	StatCompare
--	by FireBirdSR [DE]Ionsai
--
--	Improved comparison of all character stats 
--
--	################################################

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- this method is called when onloadEvent was raised.<br/><br/>
function statcompare:onLoad(frameInstance)
	local methodName = "onLoad";
	scUtils:logBegin(methodName);

	-- register for varaibles loaded event 
	frameInstance:RegisterEvent("VARIABLES_LOADED");
	
	scUtils:logEnd(methodName);
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- this method is called when the general frame is updated.<br/><br/>
function statcompare:onUpdate(frameInstance)

	-- simply call the updateHandler
	statcompare.updateHandler:onUpdate();
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- this method is called when an event was catched.<br/><br/>
function statcompare:onEvent(frameInstance, event,...)
	local methodName = "onEvent";
	scUtils:logBegin(methodName);

	-- check for the variables loaded event
	if (event == "VARIABLES_LOADED") then
 
		-- a boolean variable for the special loading steps
		local processOK = true;

		-- initialize locale
		processOK = processOK and statcompare.locale:init(); 

		-- then check if the configuration is loaded correctly
		if (processOK == true) then
			processOK = statcompare.config:checkConfig();
		end; 

		-- load all nodes
		-- do it after locale initialization because of setting texts to frames
		-- do it after configuration check because of nodes initialization with loaded config
		if (processOK == true) then
			processOK = statcompare.nodes:loadNodes();
		end;
		
	-- on all other event debug a message
	else
		scUtils:printDebug(methodName, "Unhandled event: " .. event);
	end;

	scUtils:logEnd(methodName);
end;
