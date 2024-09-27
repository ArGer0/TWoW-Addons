--	################################################
--
--	StatCompare
--	by FireBirdSR [DE]Ionsai
--
--	Locale DE 
--
--	################################################

statcompare.locale.localeInstance = {
		["MESSAGES"] = {
				["NEW_CONFIG"] = "Addon " .. scUtils:getTextWithColor("GREEN", statcompare.identifier.name .. " " .. statcompare.identifier.version) .. " hat eine neue Default-Konfiguration erstellt.",
				["CONFIG_SAVED"] = "Die Konfiguration wurde gespeichert.",
				["SWITCHED_ON"] = "Addon " .. scUtils:getTextWithColor("GREEN", statcompare.identifier.name .. " " .. statcompare.identifier.version) .. " wurde aktiviert.",
				["SWITCHED_OFF"] = "Addon " .. scUtils:getTextWithColor("GREEN", statcompare.identifier.name .. " " .. statcompare.identifier.version) .. " wurde deaktiviert.",
				["WELCOME_ON"] = "Addon " .. scUtils:getTextWithColor("GREEN", statcompare.identifier.name .. " " .. statcompare.identifier.version) .. " wurde geladen und aktiviert.",
				["WELCOME_OFF"] = "Addon " .. scUtils:getTextWithColor("GREEN", statcompare.identifier.name .. " " .. statcompare.identifier.version) .. " wurde geladen und deaktiviert belassen."
		},
		["LABELS"] = {
				["ANCHOR_HELP_VERSION"] = scUtils:getTextWithColor("GREEN", statcompare.identifier.name .. " " .. statcompare.identifier.version),
				["ANCHOR_LEFT"] = "L-Mausklick: Zeige Character-Status-Fenster",
				["ANCHOR_SHIFT_LEFT"] =	"shift+L: bewege dieses Fenster",
				["ANCHOR_RIGHT"] = "R-Mausklick: Character-Status-Vergleich"
		},
		["ERRORS"] = {
				["LOAD_NODES"] = scUtils:getTextWithColor("GREEN", statcompare.identifier.name .. " " .. statcompare.identifier.version) .. " konnte seine Nodes nicht laden!",
				["CONFIG_NOT_EXISTS"] = scUtils:getTextWithColor("GREEN", statcompare.identifier.name .. " " .. statcompare.identifier.version) .. " konnte seine Konfiguration nicht speichern, weil noch keine Struktur erstellt wurde!"
		},

		["ActualStats"] = {
				["SubTitle_Attributes"] = "Attribute",
				["SubTitle_Resistances"] = "Widerstandskraft"
		},
		["ToggleCompare"] = {
				["Label_false"] = "Vergleichen",
				["Label_true"] = "Ohne Vergleich",
				["Tooltip_false"] = "Mit diesem Button wird der Vergleich der Status-Werte eingeblendet. Wenn noch kein Vergleichspunkt festgelegt wurde, wird dies mit dem Klick gleich getan.",
				["Tooltip_true"] = "Mit diesem Button wird der Vergleich der Status-Werte wieder ausgeblendet."
		},
		["ResetComparePoint"] = {
				["Label"] = "Zur\195\188cksetzen",
				["Tooltip"] = "Mit diesem Button werden die zu vergleichenden Charakter-Werte auf die aktuell g\195\188ltigen Werte gesetzt."
		},
		["Addonmanager"] = {
				["Description"] = "Dieses Addon erm\195\182glicht das Vergleichen aller Charakter-Stati zu zwei Zeitpunkten."
		}
}