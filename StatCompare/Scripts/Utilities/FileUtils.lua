--	################################################
--
--	FileUtils
--	by FireBirdSR [DE]Ionsai
--
--	provides utilities for handling with files
--  needs loaded utility named "TextUtils"
--
--	################################################

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- reads a file from filsystem and activates the included lua script.<br/><br/>
-- @param filename <b>string</b> - the name of file to load with path related to addon root<br/><br/>
-- @return <b>boolean</b> - true or false according to the ability of loading.<br/>
function scUtils:loadFile(filename)
	local func, err = loadfile(filename);
	if (err) then
		scUtils:print(scUtils:getTextWithColor("RED", err));
		return false, err;
	end;
	dofile(filename);
	return true;
end;