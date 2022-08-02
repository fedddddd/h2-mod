require("language")

function createdivider(menu, text)
	local element = LUI.UIElement.new({
		leftAnchor = true,
		rightAnchor = true,
		left = 0,
		right = 0,
		topAnchor = true,
		bottomAnchor = false,
		top = 0,
		bottom = 33.33
	})

	element.scrollingToNext = true
	element:addElement(LUI.MenuBuilder.BuildRegisteredType("h1_option_menu_titlebar", {
		title_bar_text = Engine.ToUpperCase(Engine.Localize(text))
	}))

	menu.list:addElement(element)
end

LUI.addmenubutton("pc_controls", {
    index = 4,
    text = "@MENU_GENERAL",
    description = Engine.Localize("@MENU_GENERAL_DESC"),
    callback = function()
        LUI.FlowManager.RequestAddMenu(nil, "settings_menu")
    end
})

LUI.MenuBuilder.m_types_build["settings_menu"] = function(a1)
    local menu = LUI.MenuTemplate.new(a1, {
		menu_title = "@MENU_GENERAL",
		menu_list_divider_top_offset = -(LUI.H1MenuTab.tabChangeHoldingElementHeight + H1MenuDims.spacing),
		menu_width = GenericMenuDims.OptionMenuWidth
	})

    createdivider(menu, "@LUA_MENU_UPDATES")

    LUI.Options.CreateOptionButton(
        menu, 
        "cg_auto_update", 
        "@LUA_MENU_AUTO_UPDATE", 
        "@LUA_MENU_AUTO_UPDATE_DESC", 
        {
            {
                text = "@LUA_MENU_ENABLED",
                value = true
            },
            {
                text = "@LUA_MENU_DISABLED",
                value = false
            }
        }
    )

    menu:AddButton("@LUA_MENU_CHECK_UPDATES", function()
        LUI.tryupdating(false)
    end, nil, true, nil, {
        desc_text = Engine.Localize("@LUA_MENU_CHECK_UPDATES_DESC")
    })

    createdivider(menu, "@LUA_MENU_DRAWING")

    LUI.Options.CreateOptionButton(
        menu, 
        "cg_drawFPS", 
        "@LUA_MENU_DRAW_FPS", 
        "@LUA_MENU_DRAW_FPS_DESC", 
        {
            {
                text = "@LUA_MENU_DISABLED",
                value = 0
            },
            {
                text = "@LUA_MENU_FPS_ONLY",
                value = 1
            },
            {
                text = "@LUA_MENU_FPS_AND_VIEWPOS",
                value = 2
            }
        }
    )

    LUI.Options.CreateOptionButton(
        menu, 
        "cg_drawSpeed", 
        "@LUA_MENU_DRAW_SPEED", 
        "@LUA_MENU_DRAW_SPEED_DESC", 
        {
            {
                text = "@LUA_MENU_ENABLED",
                value = true
            },
            {
                text = "@LUA_MENU_DISABLED",
                value = false
            }
        }
    )

    LUI.Options.CreateOptionButton(
        menu, 
        "cg_speedGraph", 
        "@LUA_MENU_DRAW_SPEEDGRAPH", 
        "@LUA_MENU_DRAW_SPEEDGRAPH_DESC",
        {
            {
                text = "@LUA_MENU_ENABLED",
                value = true
            },
            {
                text = "@LUA_MENU_DISABLED",
                value = false
            }
        }
    )

    createdivider(menu, "@LUA_MENU_RENDERING")

    LUI.Options.CreateOptionButton(
        menu, 
        "r_fullbright", 
        "@LUA_MENU_R_FULLBRIGHT", 
        "@LUA_MENU_R_FULLBRIGHT_DESC", 
        {
            {
                text = "@LUA_MENU_DISABLED",
                value = 0
            },
            {
                text = "@LUA_MENU_ENABLED",
                value = 1
            },
            {
                text = "@LUA_MENU_MODE2",
                value = 2
            },
            {
                text = "@LUA_MENU_MODE3",
                value = 3
            }
        }
    )

    createdivider(menu, "@LUA_MENU_AUDIO_OPTIONS")

    LUI.Options.CreateOptionButton(
        menu, 
        "snd_musicDisabledForCustomSoundtrack", 
        "@LUA_MENU_MUSIC", 
        "@LUA_MENU_MUSIC_DESC", 
        {
            {
                text = "@LUA_MENU_DISABLED",
                value = true
            },
            {
                text = "@LUA_MENU_ENABLED",
                value = false
            },
        }
    )

    createdivider(menu, "@MENU_GAME_BEGINNING")

    LUI.Options.CreateOptionButton(
        menu, 
        "intro", 
        "@LUA_MENU_INTRO", 
        "@LUA_MENU_INTRO_DESC", 
        {
            {
                text = "@LUA_MENU_DISABLED",
                value = false
            },
            {
                text = "@LUA_MENU_ENABLED",
                value = true
            },
        }
    )

	LUI.Options.InitScrollingList(menu.list, nil)
	LUI.Options.AddOptionTextInfo(menu)

    menu:AddBackButton()

    return menu
end
