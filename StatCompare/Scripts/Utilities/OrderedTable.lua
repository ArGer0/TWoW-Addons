--	################################################
--
--	OrderedTable
--
--	provides a lua table over which you can iterate in a specific order.
--	inspired by code examples on lua-users.org
--
--	################################################

function scUtils:OrderedTable(t)

	-- metatable for the functions
	local metatable = {};
	
	-- set methods to metatable
	metatable.__index = {
	
		-- a table for the key order
		_keyOrder = {},
		
		-- the new pairs method
		pairs = function(self)
			local i = 0;
			local function iter(self)
				i = i + 1;
				local k = self._keyOrder[i];
				if k then
					return k, self[k];
				end;
			end;
			return iter, self;
		end,
		
		-- the method for remove one element
		remove = function(self, keyToRemove)
			if (self[keyToRemove]) then
				self[keyToRemove] = nil;
				for ind, key in ipairs(self._keyOrder) do
					if (key == keyToRemove) then
						table.remove(self._keyOrder, ind);
						return;
					end;
				end;
			end;
		end
	};
	
	-- the index handling write inserts the new key into the keyOrder-table
	metatable.__newindex = function(self, k, v)
		if (k ~= nil and v ~= nil) then
			rawset(self, k, v);
			table.insert(self._keyOrder, k);
		end;      
	end;
	
	-- transform metatable
	return setmetatable(t or {}, metatable);
end;
