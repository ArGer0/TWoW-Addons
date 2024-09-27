--	################################################
--
--	StatCompare
--	by FireBirdSR [DE]Ionsai
--
--	Locale RU (by Zveroboy)
--
--	################################################

statcompare.locale.localeInstance = {
		["MESSAGES"] = {
				["NEW_CONFIG"] = "Аддон " .. scUtils:getTextWithColor("GREEN", statcompare.identifier.name .. " " .. statcompare.identifier.version) .. " создана новая конфигурация.",
				["CONFIG_SAVED"] = "Настройки сохранены.",
				["SWITCHED_ON"] = "Аддон " .. scUtils:getTextWithColor("GREEN", statcompare.identifier.name .. " " .. statcompare.identifier.version) .. " включен.",
				["SWITCHED_OFF"] = "Аддон " .. scUtils:getTextWithColor("GREEN", statcompare.identifier.name .. " " .. statcompare.identifier.version) .. " выключен.",
				["WELCOME_ON"] = "Аддон " .. scUtils:getTextWithColor("GREEN", statcompare.identifier.name .. " " .. statcompare.identifier.version) .. " загружен и включен. Для изменения /sc.",
				["WELCOME_OFF"] = "Аддон " .. scUtils:getTextWithColor("GREEN", statcompare.identifier.name .. " " .. statcompare.identifier.version) .. " загружен, но сейчас отключен. Для изменения /sc."
		},
		["LABELS"] = {
				["ANCHOR_HELP_VERSION"] = scUtils:getTextWithColor("GREEN", statcompare.identifier.name .. " " .. statcompare.identifier.version),
				["ANCHOR_LEFT"] = "Левая кнопка: показывает показывает окно с текущими параметрами",
				["ANCHOR_SHIFT_LEFT"] =	"shift+левая кнопка: переместить окно",
				["ANCHOR_RIGHT"] = "Правая кнопка мыши: start the character status compare"
		},
		["ERRORS"] = {
				["LOAD_NODES"] = scUtils:getTextWithColor("GREEN", statcompare.identifier.name .. " " .. statcompare.identifier.version) .. " не возможно загрузить свои компоненты!",
				["CONFIG_NOT_EXISTS"] = scUtils:getTextWithColor("GREEN", statcompare.identifier.name .. " " .. statcompare.identifier.version) .. " не возможно сохранить натройки, т.к. не правильная структура!"
		},

		["ActualStats"] = {
				["SubTitle_Attributes"] = "Атрибуты",
				["SubTitle_Resistances"] = "Защита от:"
		},
		["ToggleCompare"] = {
				["Label_false"] = "Сравнить",
				["Label_true"] = "Закрыть",
				["Tooltip_false"] = "Эта кнопка показывает окно сравнения.",
				["Tooltip_true"] = "Эта кнопка скрывает окно сравнения."
		},
		["ResetComparePoint"] = {
				["Label"] = "Установить",
				["Tooltip"] = "Эта кнопка устанавливает текущие параметры для сравнения."
		},
		["Addonmanager"] = {
				["Description"] = "С этим аддоном у Вас естьт возможность сравнивать атрибуты разных статов."
		}
}