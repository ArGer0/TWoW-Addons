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
				["NEW_CONFIG"] = "Addon " .. scUtils:getTextWithColor("GREEN", statcompare.identifier.name .. " " .. statcompare.identifier.version) .. " a \195\169tablis une nouvelle configuration par d\195\169faut.",
				["CONFIG_SAVED"] = "La configuration a \195\169t\195\169 sauvegard\195\169.",
				["SWITCHED_ON"] = "Addon " .. scUtils:getTextWithColor("GREEN", statcompare.identifier.name .. " " .. statcompare.identifier.version) .. " est activ\195\169.",
				["SWITCHED_OFF"] = "Addon " .. scUtils:getTextWithColor("GREEN", statcompare.identifier.name .. " " .. statcompare.identifier.version) .. " est d\195\169sactiv\195\169.",
				["WELCOME_ON"] = "Addon " .. scUtils:getTextWithColor("GREEN", statcompare.identifier.name .. " " .. statcompare.identifier.version) .. " est charg\195\169 et activ\195\169.",
				["WELCOME_OFF"] = "Addon " .. scUtils:getTextWithColor("GREEN", statcompare.identifier.name .. " " .. statcompare.identifier.version) .. " est charg\195\169 et laiss\195\169 d\195\169sactiv\195\169."
		},
		["LABELS"] = {
				["ANCHOR_HELP_VERSION"] = scUtils:getTextWithColor("GREEN", statcompare.identifier.name .. " " .. statcompare.identifier.version),
				["ANCHOR_LEFT"] = "Clik Souris-G: Affiche Zeige Character-Status-Fenster",
				["ANCHOR_SHIFT_LEFT"] =	"shift+L: déplace la fenêtre",
				["ANCHOR_RIGHT"] = "Clik Souris-D: Compare Character-Status-Vergleich"
		},
		["ERRORS"] = {
				["LOAD_NODES"] = scUtils:getTextWithColor("GREEN", statcompare.identifier.name .. " " .. statcompare.identifier.version) .. " Nodes n/' ont pas pu être charg\195\169!",
				["CONFIG_NOT_EXISTS"] = scUtils:getTextWithColor("GREEN", statcompare.identifier.name .. " " .. statcompare.identifier.version) .. " config n/' a pas pu être sauvegard\195\169e, car la structure n/' a pas encore été créée !"
		},

		["ActualStats"] = {
				["SubTitle_Attributes"] = "Attribut",
				["SubTitle_Resistances"] = "R\195\169sistance"
		},
		["ToggleCompare"] = {
				["Label_false"] = "Comparer",
				["Label_true"] = "Ne pas Comparer",
				["Tooltip_false"] = "Avec ce bouton on initalise un point de comparaison et affiche la comparaison des attributs, si aucune comparaison effectué.",
				["Tooltip_true"] = "Avec ce bouton on désactive l'affichage des valeurs comparées."
		},
		["ResetComparePoint"] = {
				["Label"] = "R\195\169initialiser",
				["Tooltip"] = "Avec ce bouton on initialise aux valeurs des attributs actuels."
		},
		["Addonmanager"] = {
				["Description"] = "L'addon permet de visualiser et comparer les changement des valeur d'attributs suite à des modifications d'équipement à 2 moments donnés."
		}
}