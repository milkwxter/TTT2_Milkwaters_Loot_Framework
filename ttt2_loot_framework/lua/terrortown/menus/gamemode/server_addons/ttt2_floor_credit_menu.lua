CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"
CLGAMEMODESUBMENU.title = "ttt2_floorcredit_title"

-- actual menu stuff
function CLGAMEMODESUBMENU:Populate(parent)
    local form = vgui.CreateTTT2Form(parent, "ttt2_floorcredit_form1")
	form:MakeHelp({
        label = "ttt2_floorcredit_help1",
    })
	form:MakeCheckBox({
        label = "ttt2_floorcredit_label_enabled",
        serverConvar = "loot_floorcredit_can_spawn",
    })
	form:MakeSlider({
        label = "ttt2_floorcredit_label_maxItems",
        serverConvar = "loot_floorcredit_max_per_round",
        min = 0,
        max = 10,
        decimal = 0,
    })
	form:MakeSlider({
        label = "ttt2_floorcredit_label_pctRounds",
        serverConvar = "loot_floorcredit_spawn_chance",
        min = 0,
        max = 100,
        decimal = 0,
    })
end