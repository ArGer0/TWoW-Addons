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
-- the "class" CharacterIdentifier
function statCompareClass.CharacterIdentifier()

	-- create the local class instance
	local classInstance = {};
	local classMetatable =	{
								__metatable = classInstance;
								__index = classInstance;
							};

	-- the constructor for an object of this class
	function classInstance:create(valueName, actualizeValuesMethod)
	
		-- simply create a table
		local objectInstance = {};

		-- the actual and saved values
		objectInstance.name = valueName;
		objectInstance.actualValue = nil;
		objectInstance.savedValue = nil;
		
		-- the actualize method depends on the actualizeValuesMethod 
		function objectInstance:actualize()
		
			-- should return true if the values changed since last call of this method
			local ret = false;

			-- get the values from the actualizeValuesMethod
			local actualFirst, actualSecond = actualizeValuesMethod();

			-- if there ist no actual value yet, create an empty object
			if (self.actualValue == nil) then
				self.actualValue = statcompare.character.CharacterValueText:create(self.name);
			end;
			
			-- check if there was changes
			ret = self.actualValue.value ~= actualFirst;
			ret = ret or self.actualValue.detail ~= actualSecond;
			
			-- set the new values
			self.actualValue.value = actualFirst;
			self.actualValue.detail = actualSecond;
			
			-- return the actualize status		
			return ret;
		end;
		
		-- set the class metatable for this instance
		setmetatable(objectInstance, classMetatable);
	
		-- then initialize the object by calling the actualize method on it
		objectInstance:actualize();

		-- and return the object
		return objectInstance;
	end;

	-- the method for getting text
	function classMetatable:__tostring()
		local ret = "The character identifier has this values: \n";
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
	
	-- and return the "class" instance
	return classInstance;
end;
statcompare.character.CharacterIdentifier = statCompareClass.CharacterIdentifier();
