--	################################################
--
--	StatCompare
--	by FireBirdSR [DE]Ionsai
--
--	Locale EN 
--
--	################################################

statcompare.locale.localeInstance = {
		["MESSAGES"] = {
				["NEW_CONFIG"] = "Addon " .. scUtils:getTextWithColor("GREEN", statcompare.identifier.name .. " " .. statcompare.identifier.version) .. " created a new default configuration.",
				["CONFIG_SAVED"] = "Configuration saved.",
				["SWITCHED_ON"] = "Addon " .. scUtils:getTextWithColor("GREEN", statcompare.identifier.name .. " " .. statcompare.identifier.version) .. " is activated.",
				["SWITCHED_OFF"] = "Addon " .. scUtils:getTextWithColor("GREEN", statcompare.identifier.name .. " " .. statcompare.identifier.version) .. " is deactivated.",
				["WELCOME_ON"] = "Addon " .. scUtils:getTextWithColor("GREEN", statcompare.identifier.name .. " " .. statcompare.identifier.version) .. " is loaded and activated.",
				["WELCOME_OFF"] = "Addon " .. scUtils:getTextWithColor("GREEN", statcompare.identifier.name .. " " .. statcompare.identifier.version) .. " is loaded but not activated yet."
		},
		["LABELS"] = {
				["ANCHOR_HELP_VERSION"] = scUtils:getTextWithColor("GREEN", statcompare.identifier.name .. " " .. statcompare.identifier.version),
				["ANCHOR_LEFT"] = "left mouse: show the current character status window",
				["ANCHOR_SHIFT_LEFT"] =	"shift left: move this anchor window",
				["ANCHOR_RIGHT"] = "right mouse: start the character status compare"
		},
		["ERRORS"] = {
				["LOAD_NODES"] = scUtils:getTextWithColor("GREEN", statcompare.identifier.name .. " " .. statcompare.identifier.version) .. " could not load own nodes!",
				["CONFIG_NOT_EXISTS"] = scUtils:getTextWithColor("GREEN", statcompare.identifier.name .. " " .. statcompare.identifier.version) .. " could not save the coniguration cause there is no structure to save!"
		},

		["ActualStats"] = {
				["SubTitle_Attributes"] = "Attributes",
				["SubTitle_Resistances"] = "Resistances"
		},
		["ToggleCompare"] = {
				["Label_false"] = "Compare values",
				["Label_true"] = "Disable compare",
				["Tooltip_false"] = "This button shows the compare screen. If there is no compare point set, it will be done by clicking this button too.",
				["Tooltip_true"] = "This button hides the compare screen."
		},
		["ResetComparePoint"] = {
				["Label"] = "Reset stats",
				["Tooltip"] = "This button resets the values to compare to the actual character stats."
		},
		["Addonmanager"] = {
				["Description"] = "With this addon you have the ability for compare character stats at two particular times."
		}
}