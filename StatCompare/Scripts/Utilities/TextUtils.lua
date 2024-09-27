--	################################################
--
--	TextUtils
--	by FireBirdSR [DE]Ionsai
--
--	provides utilities for printing text with different colors
--	inspiration taken from colors by Caandera. thanks a lot!
--
--	################################################

--- the record with named color codes
scUtils.COLOR_INDICES = {
								["BLACK"]	= "cff000000",
								["WHITE"]	= "cffffffff",	
								["RED"] 	= "cffff0000",
								["GREEN"] 	= "cff00ff00",
								["BLUE"] 	= "cff0000ff",
								["ORANGE"]	= "cffff8800",
								["YELLOW"]	= "cffffff00",
								["GOLD"]	= "cffc5b358",
								["SILVER"]	= "cffc5b358"
						};

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- this method returns a colored text in the kind of ROM needed<br/><br/>
-- @param inColor <b>string</b> - the name of the color (indeced like in color code structure)
-- @param inText <b>string</b> - the text to handle<br/><br/>
-- @return <b>string</b> - the text with color in ROM notation<br/>
function scUtils:getTextWithColor(inColor, inText)
	if (inText ~= nil and inColor ~= nil) then
		return string.format("|" .. scUtils.COLOR_INDICES[inColor] .. inText .. "|r");
	end;
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- this method prints a text to the default chat frame<br/><br/>
-- @param inText <b>string</b> - the text to write out<br/><br/>
function scUtils:print(inText)
	if (inText ~= nil) then
		DEFAULT_CHAT_FRAME:AddMessage(tostring(inText));
	end;
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- this method prints the content of a table to the default chat frame<br/><br/>
-- @param inTable <b>table structure</b> - the table to write out<br/><br/>
function scUtils:printDeep(inTable)
	for k,v in pairs(inTable) do
		scUtils:print(k .. " -> " .. tostring(v));
	end;
end;
