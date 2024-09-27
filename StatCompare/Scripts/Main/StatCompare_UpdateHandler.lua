--	################################################
--
--	StatCompare
--	by FireBirdSR [DE]Ionsai
--
--	Improved comparison of all character stats 
--
--	################################################

--- the updateHandler class for StatCompare addon
statcompare.updateHandler = 	{
									--- the nodes which are registered to the update handler
									nodesToUpdate = scUtils:OrderedTable()
								};

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- this method adds one node to the list of nodes to update<br/><br/>
-- @param nodeToUpdate - <b>table</b> - the node which should be updated every time the update method is called<br/>
function statcompare.updateHandler:add(nodeToUpdate)
	local methodName = "statcompare.updateHandler:add";
	scUtils:logBegin(methodName);

	-- only add this instance if it has the onUpdate method and the name attribute
	if (nodeToUpdate ~= null and type(nodeToUpdate) == "table" and nodeToUpdate.onUpdate and nodeToUpdate.name) then
		self.nodesToUpdate[nodeToUpdate.name] = nodeToUpdate;
	end;

	scUtils:logEnd(methodName);
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- this method removes one node from the list of nodes to update<br/><br/>
-- @param nodeToRemove - <b>table</b> - the node which should be removed from the update method<br/>
function statcompare.updateHandler:remove(nodeToRemove)
	local methodName = "statcompare.updateHandler:remove";
	scUtils:logBegin(methodName);

	-- is only possible if the name attribute is set
	if (nodeToRemove ~= null and type(nodeToRemove) == "table" and nodeToRemove.name) then
		self.nodesToUpdate:remove(nodeToRemove.name);
	end;

	scUtils:logEnd(methodName);
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- this method calls the update method on every instance registered before<br/><br/>
function statcompare.updateHandler:onUpdate()

	-- simply go thru the list and call the update method for every instance registered
	for nodeName, nodeInstance in self.nodesToUpdate:pairs() do
		if (nodeInstance ~= nil and nodeInstance.onUpdate) then
			nodeInstance:onUpdate();
		end;
	end;
end;

