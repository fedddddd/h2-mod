game:addlocalizedstring("MENU_english", "English")
game:addlocalizedstring("MENU_french", "Français")
game:addlocalizedstring("MENU_german", "Deutsch")
game:addlocalizedstring("MENU_italian", "Italiano")
game:addlocalizedstring("MENU_spanish", "Español")
game:addlocalizedstring("MENU_russian", "Русский")
game:addlocalizedstring("MENU_polish", "Polski")
game:addlocalizedstring("MENU_portuguese", "Português")
game:addlocalizedstring("MENU_japanese_full", "日本語")
game:addlocalizedstring("MENU_japanese_partial", "日本語(一部)")
game:addlocalizedstring("MENU_traditional_chinese", "繁體中文")
game:addlocalizedstring("MENU_simplified_chinese", "简体中文")
game:addlocalizedstring("MENU_arabic", "العربية")
game:addlocalizedstring("MENU_czech", "České")
game:addlocalizedstring("MENU_spanishna", "Español (América Latina)") -- text only (English dubbing)
game:addlocalizedstring("MENU_korean", "한국어")
game:addlocalizedstring("MENU_english_safe", "English (Safe)")
game:addlocalizedstring("MENU_russian_partial", "Русский (Англ. озвучка)") -- text only (English dubbing)

LUI.addmenubutton("pc_controls", {
	index = 4,
	text = "@LUA_MENU_CHOOSE_LANGUAGE",
	description = Engine.Localize("@LUA_MENU_CHOOSE_LANGUAGE_DESC"),
	callback = function()
		LUI.FlowManager.RequestAddMenu(nil, "choose_language_menu")
	end
})

local universalfont = RegisterFont("fallback/fonts/default.otf", 30)

local function setuniversalfont(lang)
	LUI.MenuGenericButtons.ButtonLabelFont.Font = universalfont
end

LUI.MenuBuilder.registerType("choose_language_menu", function(a1)
	local menu = LUI.MenuTemplate.new(a1, {
		menu_title = "@LUA_MENU_CHOOSE_LANGUAGE",
		menu_list_divider_top_offset = -(LUI.H1MenuTab.tabChangeHoldingElementHeight + H1MenuDims.spacing),
		menu_width = 240,
		uppercase_title = true
	})

	local languages = Engine.GetSupportedLanguages()

	for i = 1, #languages do
		local id = languages[i].id

		local lang = Engine.GetCurrentLanguage()

		setuniversalfont(id)
				
		local button = menu:AddButton("", function()
			LUI.FlowManager.RequestAddMenu(nil, "choose_language_confirm_popup", false, nil, true, {
				language = languages[i].id
			})
		end, languages[i].id == Engine.GetCurrentLanguage(), true, nil, {
			desc_text = Engine.Localize("LOCALE_" .. (languages[i].id))
		})

		overrideyoffset = nil

		local label = button:getFirstDescendentById("text_label")
		label:setText(Engine.ToUpperCase(languages[i].name))
	end

	LUI.Options.InitScrollingList(menu.list, nil, {
		rows = 10
	})

	LUI.Options.AddOptionTextInfo(menu)
	menu:AddBackButton()

	return menu
end)

-- global patch
LUI.UIButtonText.IsOffsetedLanguage = function()
	return false
end

-- pol/rus patch

if (not Engine.InFrontend()) then
	local weaponinfodef = LUI.MenuBuilder.m_definitions["WeaponInfoHudDef"]
	LUI.MenuBuilder.m_definitions["WeaponInfoHudDef"] = function(...)
		local rus = CoD.Language.Russian
		CoD.Language.Russian = 1337
		local pol = CoD.Language.Polish
		CoD.Language.Polish = 1338
		local res = weaponinfodef(...)
		CoD.Language.Russian = rus
		CoD.Language.Polish = pol
		return res
	end
else
	local levelselectmenu = LUI.sp_menus.LevelSelectMenu
	local setupinfobox = levelselectmenu.SetupInfoBoxLeftForArcadeMode
	levelselectmenu.SetupInfoBoxLeftForArcadeMode = function(...)
		local rus = CoD.Language.Russian
		CoD.Language.Russian = 1337
		local pol = CoD.Language.Polish
		CoD.Language.Polish = 1338
		local res = setupinfobox(...)
		CoD.Language.Russian = rus
		CoD.Language.Polish = pol
		return res
	end
end

-- ara/ces/pol/rus patch

local lang = Engine.GetCurrentLanguage()
if (lang == 5 or lang == 6 or lang == 12 or lang == 13 or lang == 17) then
	local scale = function (size)
		return size * 720 / 1080
	end

	CoD.TextSettings.SP_HudAmmoStatusText = {
		Font = RegisterFont("fonts/bank.ttf", 16),
		Height = 16
	}
	
	CoD.TextSettings.SP_HudAmmoCounterFont = {
		Font = RegisterFont("fonts/bank.ttf", 34),
		Height = 34
	}
	
	CoD.TextSettings.HudAmmoCounterFont = {
		Font = RegisterFont("fonts/bank.ttf", 105),
		Height = 64
	}
	
	CoD.TextSettings.H2TitleFont = {
		Font = RegisterFont("fonts/bank.ttf", 56),
		Height = scale(56)
	}
end