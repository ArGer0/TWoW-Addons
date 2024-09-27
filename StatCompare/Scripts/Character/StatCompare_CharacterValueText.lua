--	################################################
--
--	StatCompare
--	by FireBirdSR [DE]Ionsai
--
--	Improved comparison of all character stats
--	"Classes" for character values 
--
--	################################################

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- the "class" CharacterValueText
function statCompareClass.CharacterValueText()

	-- create the local class instance
	local classInstance = {};
	local classMetatable =	{
								__metatable = classInstance;
								__index = classInstance;
							};

	-- this type is not comparable	
	classInstance.comparable = false;
	
	-- the constructor for an object of this class
	function classInstance:create(valueName)
	
		-- simply create a table
		local objectInstance = {};

		-- the name and value
		objectInstance.name = valueName;
		objectInstance.value = "";
		objectInstance.detail = "";
		
		-- set the class metatable for this instance
		setmetatable(objectInstance, classMetatable);
	
		-- and return the object
		return objectInstance;
	end;

	-- the method for getting text
	function classInstance:toDetailedString()
		local ret = "";
		if (self.value and self.value ~= "") then
			ret = ret .. tostring(self.value);
		end;
		if (self.detail and self.detail ~= "" and tostring(self.detail) ~= "0") then
			ret = ret .. " (" .. tostring(self.detail) .. ")";
		end;
		return ret;
	end;
	
	-- the method for getting text (only value without detail)
	function classInstance:toSimpleString()
		local ret = "";
		if (self.value and self.value ~= "") then
			ret = ret .. tostring(self.value);
		end;
		return ret;
	end;

	-- and return the "class" instance
	return classInstance;
end;
statcompare.character.CharacterValueText = statCompareClass.CharacterValueText();
