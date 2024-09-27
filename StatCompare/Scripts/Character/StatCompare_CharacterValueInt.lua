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
-- the "class" CharacterValueInt
function statCompareClass.CharacterValueInt()

	-- create the local class instance
	local classInstance = {};
	local classMetatable =	{
								__metatable = classInstance;
								__index = classInstance;
							};

	-- this type is comparable	
	classInstance.comparable = true;
	
	-- the constructor for an object of this class
	function classInstance:create(valueName)
	
		-- simply create a table
		local objectInstance = {};

		-- the name and value
		objectInstance.name = valueName;
		objectInstance.value = 0;
		objectInstance.detail = 0;
		
		-- set the class metatable for this instance
		setmetatable(objectInstance, classMetatable);
	
		-- and return the object
		return objectInstance;
	end;
	
	-- the method for getting text
	function classInstance:toDetailedString()
		local ret = "";

		-- set the color for the value display according to the difference between value and detail value 		
		local valueColor = "WHITE";
		if (self.value and self.detail) then
			if (self.value > self.detail) then
				valueColor = "GREEN";
			elseif (self.value < self.detail) then
				valueColor = "RED";
			end;
		end;

		-- and append the two variables to the return string		
		ret = ret .. scUtils:getTextWithColor(valueColor, tostring(self.value));
		if (self.detail ~= 0 or self.value ~= 0) then
			ret = ret .. scUtils:getTextWithColor("WHITE", " (" .. tostring(self.detail) .. ")");
		end;
		
		return ret;
	end;

	-- the method for getting text (only value without detail)
	function classInstance:toSimpleString()
		local ret = "";

		-- set the color for the value display according to the difference between value and detail value 		
		local valueColor = "WHITE";
		if (self.value and self.detail) then
			if (self.value > self.detail) then
				valueColor = "GREEN";
			elseif (self.value < self.detail) then
				valueColor = "RED";
			end;
		end;

		ret = scUtils:getTextWithColor(valueColor, tostring(self.value));
		
		return ret;
	end;

	-- the method for getting text (only simple value but colored dependent to positive or negative value)
	function classInstance:toCompareString()
		local ret = "";

		-- only return a value when the stored value is not equals zero
		if (self.value ~= nil and self.value ~= 0) then
			-- set the color for the value display 		
			local valueColor = "WHITE";
			if (self.value > 0) then
				valueColor = "GREEN";
			elseif (self.value < 0) then
				valueColor = "RED";
			end;
	
			ret = scUtils:getTextWithColor(valueColor, tostring(self.value));
		end;
		
		return ret;
	end;

	-- the method for copy an object instance
	function classInstance:copy()
		local newObject = classInstance:create(self.name);
		newObject.value = self.value;
		newObject.detail = self.detail;
		return newObject;
	end;

	-- and return the "class" instance
	return classInstance;
end;
statcompare.character.CharacterValueInt = statCompareClass.CharacterValueInt();
