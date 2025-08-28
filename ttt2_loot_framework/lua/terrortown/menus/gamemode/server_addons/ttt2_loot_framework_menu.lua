CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"
CLGAMEMODESUBMENU.title = "ttt2_lootframework_title"

-- actual menu stuff
function CLGAMEMODESUBMENU:Populate(parent)
    local form = vgui.CreateTTT2Form(parent, "ttt2_lootframework_form1")
	form:MakeHelp({
        label = "ttt2_lootframework_help1",
    })
	form:MakeCheckBox({
        label = "ttt2_lootframework_label_enabled",
        serverConvar = "ttt2_lootframework_enabled",
    })
end