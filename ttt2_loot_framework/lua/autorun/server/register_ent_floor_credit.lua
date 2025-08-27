-- this hook will register the item to the database
hook.Add("Initialize", "LOOTBASERegister_FloorCredit", function()
    if not LOOT_BASE then return end

	-- when registering item, spaces are ILLEGAL
    LOOT_BASE:RegisterItem("floorcredit", {
	itemClassName = "ent_floor_credit",
	itemMaxSpawn = 10
	})
end)