--	################################################
--
--	StatCompare
--	by FireBirdSR [DE]Ionsai
--
--	Improved comparison of all character stats 
--
--	################################################

--- locale namespace of statCompare Addon
statcompare.locale = 	{
							--- the language setting from the ROM API
							language = "DE",
							
							--- the locale specific contents (messages, errors and labels)
							localeInstance = {}
						};

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- this method initially loads the locale specific settings.<br/><br/>
-- @return <b>boolean</b> - true if everything is ok, false if the loading process gets errors<br/>
function statcompare.locale:init()
	local methodName = "statcompare.locale:init";
	scUtils:logBegin(methodName);
	local ret = false;

	-- the default locale file location (German)
	local defaultPath = statcompare.identifier.path .. "/Scripts/locales/lang_" .. statcompare.locale.language .. ".lua";

	-- get the language from ROM API
	statcompare.locale.language = GetLanguage():upper();
	
	-- the path to the specific locale file
	local localePath = statcompare.identifier.path .. "/Scripts/locales/lang_" .. statcompare.locale.language .. ".lua";
	
	-- try to load the specific locale
	ret = scUtils:loadFile(localePath);
	
	-- if it wasn't successful, try to load the default locale
	if (ret == false) then
		ret = scUtils:loadFile(defaultPath);
	end; 

	-- even if the default locale could not be loaded print an error message
	if (ret == false) then
		scUtils:print(scUtils:getTextWithColor("RED", "Could not load locale for addon StatCompare"));
	end; 

	scUtils:logEnd(methodName);
	return ret;
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- this method returns the locale specific text indiced by a category and an identifier.<br/><br/>
-- @param category <b>string</b> - the category of the text
-- @param identifier <b>string</b> - the identifier within the category<br/><br/>
-- @return <b>string</b> - the locale specific text. empty string if text could not be found<br/>
function statcompare.locale:getText(category, identifier)
	local methodName = "statcompare.locale:getText";
	scUtils:logBegin(methodName);
	local ret = "";

	-- repeat only if the the locale was loaded correctly
	if (self.localeInstance and self.localeInstance ~= nil) then
		ret = self.localeInstance[category][identifier];
	end;

	scUtils:logEnd(methodName);
	return ret;
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- this method returns a complete locale specific category as a table.<br/><br/>
-- @param category <b>string</b> - the category of the text
-- @return <b>table</b> - all texts within this category (empty table, if the category was not found)<br/>
function statcompare.locale:getCategory(category)
	local methodName = "statcompare.locale:getCategory";
	scUtils:logBegin(methodName);
	local ret = {};

	-- repeat only if the the locale was loaded correctly
	if (self.localeInstance and self.localeInstance ~= nil and self.localeInstance[category] ~= nil) then
		ret = self.localeInstance[category];
	end;

	scUtils:logEnd(methodName);
	return ret;
end;
