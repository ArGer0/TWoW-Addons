--	################################################
--
--	StatCompare
--	by FireBirdSR [DE]Ionsai
--
--	Improved comparison of all character stats
--	Node: Achor frame for hooking all character frame contents 
--
--	################################################

--- local instance
local thisNode = 	{
						--- the name of this window
						name = "AnchorFrame",
						
						--- the configuration table
						configuration = {},
						
						--- the activity switch
						activity = false,
						
						--- the frame instace within the UI
						frameInstance = nil,
		
						--- the table for all values of the character frame				
						characterFrame =	{
												--- the frame instance of the character frame
												instance = nil,
												
												--- the timer for hiding the character frame
												timer = nil,
												
												--- the table for storing all hooked elements
												hookedElements = {},
												
												--- the table for storing all elements hided
												hidedElements = {}
											}
					};

-- init the default configuration of this window instance
thisNode.configuration["X"] = 100;
thisNode.configuration["Y"] = 100;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- this method handles a onMouseDown event on the frame this node is registered on.<br/><br/>
-- @param key <b>string</b> - the mousebotton clicked<br/>
function thisNode:onMouseDown(key)

	-- left MouseButton should start moving the frame 
	if (key == "LBUTTON") then
		self.frameInstance:StartMoving();
	end;
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- this method handles a onMouseUp event on the frame this node is registered on.<br/><br/>
function thisNode:onMouseUp()

	-- stop moving of the frame
	self.frameInstance:StopMovingOrSizing();
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- this method handles a onDragStop event on the frame this node is registered on.<br/><br/>
function thisNode:onDragStop()

	-- get the new position and save it for the configuration
	self.configuration["X"], self.configuration["Y"] = self.frameInstance:GetPos();
	statcompare.config:saveConfig();
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- this method handles a onUpdate event on the frame this node is registered on.<br/><br/>
function thisNode:onUpdate()

	-- only do something, if the node is active yet and the characterframe is bound
	if (self.activity == true and self.characterFrame.instance ~= nil) then
	
		-- the character frame cannot be moved out of screen when its not visible. therefore it has to be moved
		-- after some milliseconds this node is schown.	
		self.characterFrame.instance:ClearAllAnchors();
		self.characterFrame.instance:SetAnchor("TOPLEFT", "BOTTOMRIGHT", "UIParent", 10, 10);
	end;
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- like the name said, this method checks if the node (and the complete function of this addon) is active.<br/><br/>
-- @return <b>boolean</b> - TRUE means that the node is active<br/>
function thisNode:isActive()

	-- simply check the activity switch
	ret = self.activity;
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- this method hooks one content frame of the character frame.<br/><br/>
function thisNode:hookElement(elementName, anchorPoint, relativePoint, relativeTo, x, y)

	-- get the frame instance
	local elementInstance = getglobal(elementName);
	
	-- if this instance could get correctly 
	if (elementInstance ~= nil and type(elementInstance) == "table" and elementInstance.GetName) then
	
		-- try to get the current anchor point for restore later
		scUtils:rememberAnchor(elementInstance);

		-- set the new anchor point	
		elementInstance:ClearAllAnchors();
		elementInstance:SetAnchor(anchorPoint, relativePoint, relativeTo, x, y);
		
		-- if the instance is a frame then set the level above the anchor frame
		if (elementInstance.SetFrameLevel) then
			elementInstance:SetFrameLevel(1);
		end;
		
		-- and store the frame in the hooked frames table
		self.characterFrame.hookedElements[elementInstance:GetName()] = elementInstance;
	end;
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- this method hides one content frame of the character frame.<br/><br/>
function thisNode:hideElement(elementName)

	-- get the frame instance
	local elementInstance = getglobal(elementName);
	
	-- if this instance could get correctly 
	if (elementInstance ~= nil and type(elementInstance) == "table" and elementInstance.GetName and elementInstance.Hide) then
	
		-- hide the frame
		elementInstance:Hide();
		
		-- and store the frame in the hooked frames table
		self.characterFrame.hidedElements[elementInstance:GetName()] = elementInstance;
	end;
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- this method makes the UI frame visible and hook all contents of the character frame.<br/><br/>
function thisNode:activate()
	local methodName = self.name .. ":activate";
	scUtils:logBegin(methodName);

	-- only do something, if the node is not active yet and the characterframe is bound
	if (self.activity == false and self.characterFrame.instance ~= nil) then

		-- try to hook the content frames of the character frame
		scUtils:printDebug(methodName, "hook all character frame content");
		local thisName = self.frameInstance:GetName();
		self:hookElement("EquipmentFrame", "TOPRIGHT", "TOPRIGHT", thisName, -42, 18);	-- equipment 
		self:hookElement("PracticedFrame", "TOPRIGHT", "TOPRIGHT", thisName, -42, 33);	-- weapon practiced
		self:hookElement("CCFrame", "TOPRIGHT", "TOPRIGHT", thisName, -42, 33);			-- crafting
		self:hookElement("CEFrame", "TOPRIGHT", "TOPRIGHT", thisName, -42, 33);			-- emotes
		self:hookElement("CharacterClassListFrame", "TOPRIGHT", "TOPRIGHT", thisName, -42, 33);	-- Character classes
		self:hookElement("CharacterExperienceFrame", "TOPRIGHT", "TOPRIGHT", thisName, -42, 33);	-- PVP Expierence
		
		self:hookElement("CharacterFrameTab1", "TOPRIGHT", "TOPRIGHT", thisName, -9, 40);	-- tab for equipment
		self:hookElement("CharacterFrameTab2", "TOPRIGHT", "BOTTOMRIGHT", "CharacterFrameTab1", 0, 1);	-- tab for weapon practiced
		self:hookElement("CharacterFrameTab3", "TOPRIGHT", "BOTTOMRIGHT", "CharacterFrameTab2", 0, 1);	-- tab for crafting
		self:hookElement("CharacterFrameTab4", "TOPRIGHT", "BOTTOMRIGHT", "CharacterFrameTab3", 0, 1);	-- this is a hidden or non visible tab ?!?
		self:hookElement("CharacterFrameTab5", "TOPRIGHT", "BOTTOMRIGHT", "CharacterFrameTab3", 0, 1);	-- tab for emotes
		self:hookElement("CharacterFrameTab6", "TOPRIGHT", "BOTTOMRIGHT", "CharacterFrameTab5", 0, 1);	-- tab for Character classes
		self:hookElement("CharacterFrameTab7", "TOPRIGHT", "BOTTOMRIGHT", "CharacterFrameTab6", 0, 1);	-- tab for PVP Expierence
		
		self:hookElement("CharacterCloseButton", "TOPRIGHT", "TOPRIGHT", thisName, -3, 3);	-- Button for closing character frame
		
		-- hide some things
		scUtils:printDebug(methodName, "hide some character framne contents");
		self:hideElement("EquipmentMainClassFrame");
		self:hideElement("EquipmentDeputyClassFrame");
		self:hideElement("IntroductionFrame");
		
		-- get the old anchor of the character frame
		scUtils:rememberAnchor(self.characterFrame.instance);
		
		-- at the end, make the UI frame visible
		scUtils:printDebug(methodName, "make the ui frame visible");
		self.frameInstance:Show();
		
		-- and toggle the activity switch
		self.activity = true;
	end;
		
	scUtils:logEnd(methodName);
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- this method hides the UI frame and unregister all events.<br/><br/>
function thisNode:deactivate()
	local methodName = self.name .. ":deactivate";
	scUtils:logBegin(methodName);

	-- only do something, if the node is active yet
	if (self.activity == true and self.characterFrame.instance ~= nil) then
	
		-- try to unhook all frames hooked formerly
		scUtils:printDebug(methodName, "unhook all character frame content");
		for elementName, elementInstance in pairs(self.characterFrame.hookedElements) do
			scUtils:restoreAnchor(elementInstance);
		end;

		-- try to show all frames hided formerly
		scUtils:printDebug(methodName, "show all elements formerly hided");
		for elementName, elementInstance in pairs(self.characterFrame.hidedElements) do
			elementInstance:Show();
		end;

		-- at the end, make the UI frame visible
		scUtils:printDebug(methodName, "make the ui frame invisible");
		self.frameInstance:Hide();

		-- anchor the character frame back to the uiParent (Do this in a normal way and the try to restore the remembered anchor)
		scUtils:printDebug(methodName, "reanchor the character frame");
		local scale = GetUIScale();
		self.characterFrame.instance:ClearAllAnchors();
		self.characterFrame.instance:SetAnchor("TOPLEFT", "TOPLEFT", "UIParent", 100, 100);
		scUtils:restoreAnchor(self.characterFrame.instance);

		-- and toggle the activity switch
		self.activity = false;
	end;
		
	scUtils:logEnd(methodName);
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- with this method the node will get initialised and connected to the UI frame.<br/><br/>
-- @return <b>boolean</b> - if the initialisation was not successful or the UI frame could not be connected<br/>
function thisNode:init()
	local methodName = self.name .. ":init";
	scUtils:logBegin(methodName);
	local ret = false;

	-- first try to locate the UI frame
	local uiFrame = getglobal("StatCompare_Frame_" .. self.name);
	if (uiFrame ~= nil) then
	
		-- register the instances
		scUtils:printDebug(methodName, "register the instances");
		self.frameInstance = uiFrame;
		uiFrame.nodeAnchor = thisNode;
		
		local characterFrame = getglobal("CharacterFrame");
		if (characterFrame ~= nil and type(characterFrame) == "table") then
			self.characterFrame.instance = characterFrame;
		end;
		
		-- try to set all texts from locale
		scUtils:printDebug(methodName, "try to set all texts from locale");
		local frameTexts = statcompare.locale:getCategory(self.name);
		for key, value in pairs(frameTexts) do
			local fontInstance = getglobal(self.name .. "_" .. key);
			if (fontInstance ~= nil) then
				fontInstance:SetText(value);
			end;
		end;

		-- apply settings to the UI-Frame if it is set already
		if (self.frameInstance ~= nil) then
			local scale = GetUIScale();
			self.frameInstance:ClearAllAnchors();
			self.frameInstance:SetAnchor("TOPLEFT", "TOPLEFT", "UIParent", self.configuration["X"]/scale, self.configuration["Y"]/scale);
		end;
		
		-- if everthing is ok, return true
		ret = true;
	end;
		
	scUtils:logEnd(methodName);
	return ret;
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- this method applies the given configuration to this node instance.<br/><br/>
-- @param settings <b>table</b> - the settings for this node<br/>
function thisNode:applyConfiguration(settings)
	local methodName = self.name .. ":applyConfiguration";
	scUtils:logBegin(methodName);
	
	-- only do something if the given settings are of type table
	if (type(settings) ~= "table") then
		scUtils:printDebug(methodName, "the given settings is not of type table");

	else
		-- overwrite the value for every key that is remembered in the default configuration
		for key, value in pairs(self.configuration) do
			local newValue = settings[key];
			if (newValue ~= nil) then
				self.configuration[key] = newValue;
			end;
		end;
	end;
	
	scUtils:logEnd(methodName);
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--- this method return the configuration from this node.<br/><br/>
-- @return <b>table</b> - the settings from this nodes<br/>
function thisNode:getConfiguration()
	local methodName = self.name .. ":getConfiguration";
	scUtils:logBegin(methodName);
	local ret = {};
	
	-- simply return the configuration table from the instance table
	ret = self.configuration;
	
	scUtils:logEnd(methodName);
	return ret;
end;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- at the very end return the local windowInstance for the initial load process
return thisNode;