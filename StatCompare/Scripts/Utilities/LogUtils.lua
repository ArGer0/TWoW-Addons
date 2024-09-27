--	################################################
--
--	LogUtils
--	by FireBirdSR [DE]Ionsai
--
--	provides some functionality for logging to defaul chat frame
--  needs loaded utility named "TextUtils"
--
--	################################################

--- the instance of logging process
scUtils.logging = 	{
						level = 0,
						debugEnabled = false,
						debugFrame = nil
					};

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- this method return the chat frame where the debug output should go in<br/><br/>
-- @return <b>table</b> - the debug chat frame
function scUtils:getDebugFrame()
	local ret = nil;
	
	-- if debug frame is already set, then simply return it
	if (scUtils.logging.debugFrame ~= nil) then
		ret = scUtils.logging.debugFrame;
	
	-- search thru all chatframes for one which messageType is only "Channel"
	else
		for chatIndex = 1, 10 do
		    local chatFrame = getglobal("ChatFrame" .. chatIndex);
		    if (ret == nil and chatFrame ~= nil and chatFrame.isInitialized ~= nil and chatFrame.isInitialized == 1) then
			    if (#chatFrame.messageTypeList <= 1 and chatFrame.messageTypeList[1] == "CHANNEL") then
			        scUtils.logging.debugFrame = chatFrame;
			        ret = chatFrame;
			    end;
			end;
		end;
		
		-- if no frame is found, take the default chat frame
		if (ret == nil) then
			ret = DEFAULT_CHAT_FRAME;
		end;
	end;	
	
	return ret;
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- method for adding a debug message to the default chat frame<br/><br/>
-- @param methodName <b>string</b> - the name of method which is calling this method
-- @param text <b>string</b> - the text to write out
function scUtils:printDebug(methodName, text)
	if (scUtils.logging.debugEnabled == true and methodName ~= nil) then
		local logText = "";
		for i = 0, scUtils.logging.level, 1 do
			logText = logText .. " .";
		end;
		logText = logText .. scUtils:getTextWithColor("WHITE", "[" .. methodName .. "] ") .. text;
		local debugFrame = scUtils:getDebugFrame();
		debugFrame:AddMessage(logText);
	end;
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- method for adding a begin log to the debug output.<br/>
-- The begin log increases the level of text indention by one character<br/><br/>
-- @param methodName <b>string</b> - the name of method which is calling this method
function scUtils:logBegin(methodName)
	if (methodName ~= nil) then
		scUtils:printDebug(methodName, scUtils:getTextWithColor("ORANGE", "Begin"));
		scUtils.logging.level = scUtils.logging.level + 1;
	end;
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- method for adding a end log to the debug output.<br/>
-- The end log decreases the level of text indention by one character<br/><br/>
-- @param methodName <b>string</b> - the name of method which is calling this method
function scUtils:logEnd(methodName)
	if (methodName ~= nil) then
		if (scUtils.logging.level > 0) then scUtils.logging.level = scUtils.logging.level - 1; end;
		scUtils:printDebug(methodName, scUtils:getTextWithColor("ORANGE", "End"));
	end;
end;
