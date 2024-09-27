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
-- the "class" CharacterResistance
function statCompareClass.CharacterResistance()

	-- create the local class instance
	local classInstance = {};
	local classMetatable =	{
								__metatable = classInstance;
								__index = classInstance;
							};

	-- the constructor for an object of this class
	function classInstance:create(valueName)
	
		-- simply create a table
		local objectInstance = {};

		-- the actual and saved values
		objectInstance.name = valueName;
		objectInstance.actualValue = nil;
		objectInstance.savedValue = nil; 
		
		-- set the class metatable for this instance
		setmetatable(objectInstance, classMetatable);
	
		-- then initialize the object by calling the actualize method on it
		objectInstance:actualize();

		-- and return the object
		return objectInstance;
	end;

	-- the method for getting text
	function classMetatable:__tostring()
		local ret = "The character resistance " .. self.name .. " has this values: \n";
		if (self.actualValue) then
			ret = ret .. "   actual: " .. tostring(self.actualValue) .. "\n";
		end;
		if (self.savedValue) then
			ret = ret .. "   saved: " .. tostring(self.savedValue) .. "\n";
		end;
		return ret;
	end;
	
	-- the method for remebering the actual values
	function classInstance:saveValues()
		if (self.actualValue and self.actualValue.comparable) then
			self.savedValue = self.actualValue:copy();
		end;
	end;
	
	-- the method for comparing the values
	function classInstance:compareValues()
	
		-- this should return the difference between the actual and the saved value 
		local ret = nil;
	
		-- only do something, if both values are set and the type is comparable
		if (self.actualValue and self.savedValue and self.actualValue.comparable) then

			-- create the compared object
			ret = statcompare.character.CharacterValueInt:create(self.name);
			
			-- and set the values
			ret.value = self.actualValue.value - self.savedValue.value;
		end;
		
		-- and return
		return ret;
	end;
	
	-- the method for actualizing the ability from ROM API
	function classInstance:actualize()
	
		-- should return true if the values changed since last call of this method
		local ret = false;
	
		-- first load all resistences from the ROM API
		local erde, wasser, feuer, wind, licht, dunkelheit = GetPlayerResistance();
		
		-- if the actual values was not set
		if (self.actualValue == nil) then
			self.actualValue = statcompare.character.CharacterValueInt:create(self.name);
		end;

		-- then try to locate the correct one
		local correctResistance = 0;
		if (self.name == "EARTH") then
			correctResistance = erde;
		elseif (self.name == "WATER") then
			correctResistance = wasser;
		elseif (self.name == "FIRE") then
			correctResistance = feuer;
		elseif (self.name == "WIND") then
			correctResistance = wind;
		elseif (self.name == "LIGHT") then
			correctResistance = licht;
		elseif (self.name == "DARK") then
			correctResistance = dunkelheit;
		end;
		
		-- check if there was changes
		ret = self.actualValue.value ~= correctResistance;
		
		-- set the new values
		self.actualValue.value = correctResistance;
		
		-- return the actualize status		
		return ret;
	end;	
	
	-- and return the "class" instance
	return classInstance;
end;
statcompare.character.CharacterResistance = statCompareClass.CharacterResistance();
