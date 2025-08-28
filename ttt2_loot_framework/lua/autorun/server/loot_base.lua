if not LOOT_BASE then
    LOOT_BASE = {}
    LOOT_BASE.RegisteredItems = {}
end

-- my convars
local cvar_LootFrameworkEnabled = CreateConVar("ttt2_lootframework_enabled", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "Enable the Loot Framework?", 0, 1)

function LOOT_BASE:RegisterItem(uniqueID, data)
	-- no dupes
    if self.RegisteredItems[uniqueID] then return end

    -- store the data
    self.RegisteredItems[uniqueID] = data or {}
	
	-- print the data
	print("PRINTING DATA TABLE ON REGISTRATION!")
	PrintTable(data)

    -- make convars for that specific item
    CreateConVar("loot_" .. uniqueID .. "_can_spawn", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "Can this item spawn?")
    CreateConVar("loot_" .. uniqueID .. "_spawn_chance", 100, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "Percent chance this item will spawn in a round")
	
	local convarMaxPerRoundDefault = 1
	if data.itemMaxSpawn then
		convarMaxPerRoundDefault = data.itemMaxSpawn
	end
	CreateConVar("loot_" .. uniqueID .. "_max_per_round", convarMaxPerRoundDefault, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED}, "Maximum number of this item to spawn per round")
    
end

-- get all items that CAN SPAWN
function LOOT_BASE:GetAllowedItems()
    local allowed = {}
    for uniqueID, data in pairs(self.RegisteredItems) do
        if GetConVar("loot_" .. uniqueID .. "_can_spawn"):GetBool() then
            table.insert(allowed, {
                id = uniqueID,
                data = data,
                chance = GetConVar("loot_" .. uniqueID .. "_spawn_chance"):GetInt(),
                maxItems = GetConVar("loot_" .. uniqueID .. "_max_per_round"):GetInt()
            })
        end
    end
    return allowed
end

-- spawn the items on spawnpoints
function LOOT_BASE:SpawnAllLoot()
	-- get all the spawns
	local spawns = ents.FindByClass("item_*")
	local numSpawns = #spawns
	
	-- get all items that are allowed to spawn
    local items = self:GetAllowedItems()
	
	-- debug
	print("PRINTING ITEMS THAT ARE ALLOWED TO SPAWN")
	PrintTable(items)
	
	-- begin spawning
    for _, item in ipairs(items) do
		-- check the chance for this item to spawn
		local spawnChance = math.random(0, 100)
		if spawnChance > item.chance then
			print(item.data.itemClassName .. " was skipped from spawning this round. Rolled a " .. spawnChance .. " which is MORE than set chance: " .. item.chance .. ".")
			continue
		end
		
		-- how many can we spawn?
		local numToSpawn = math.random(0, item.maxItems)
		
		local amount
		if(numSpawns < numToSpawn) then
			amount = numSpawns
		else
			amount = numToSpawn
		end
		
		print("SPAWNING " .. amount .. " OF THIS ITEM: " .. item.data.itemClassName)
		
		-- spawn time
		for i = 1, amount do
			local index = math.random(#spawns)
			local spwn = spawns[index]
			local spwn_name = spwn:GetClass()
			local ent = ents.Create(item.data.itemClassName)

			ent:SetPos(spwn:GetPos())
			
			local ang = ent:GetAngles()
			ang:RotateAroundAxis(ang:Up(), 90)
			ent:SetAngles(ang)
			
			ent:Spawn()
			ent:PhysWake()
		end
    end
end

if SERVER then
	-- when round starts, spawn my stuff
	hook.Add("TTTBeginRound", "BeginRound_SpawnAllLoot", function()
		-- check to see if we are disabled
		if cvar_LootFrameworkEnabled == 0 then return end
		-- if not, spawn tha loot
		LOOT_BASE:SpawnAllLoot()
	end)
end