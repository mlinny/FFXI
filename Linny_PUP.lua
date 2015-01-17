-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    -- List of pet weaponskills to check for
    petWeaponskills = S{"Slapstick", "Knockout", "Magic Mortar",
        "Chimera Ripper", "String Clipper",  "Cannibal Blade", "Bone Crusher", "String Shredder",
        "Arcuballista", "Daze", "Armor Piercer", "Armor Shatterer"}
    
    -- Map automaton heads to combat roles
    petModes = {
        ['Harlequin Head'] = 'Melee',
        ['Sharpshot Head'] = 'Ranged',
        ['Valoredge Head'] = 'Tank',
        ['Stormwaker Head'] = 'Magic',
        ['Soulsoother Head'] = 'Heal',
        ['Spiritreaver Head'] = 'Nuke'
        }

    -- Subset of modes that use magic
    magicPetModes = S{'Nuke','Heal','Magic'}
    
    -- Var to track the current pet mode.
    state.PetMode = M{['description']='Pet Mode', 'None', 'Melee', 'Ranged', 'Tank', 'Magic', 'Heal', 'Nuke'}
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    --state.OffenseMode:options('Normal', 'Acc', 'Fodder')
    state.OffenseMode:options('None', 'Master', 'Auto')
    state.HybridMode:options('Atk', 'DT', 'Accu', 'Evasion')
    state.WeaponskillMode:options('Normal', 'Acc', 'Fodder')
    state.PhysicalDefenseMode:options('PDT', 'Evasion', 'MDT')
	--state.PhysicalDefenseMode:options('PDT', 'Evasion', 'MDT')

    -- Default maneuvers 1, 2, 3 and 4 for each pet mode.
    defaultManeuvers = {
        ['Melee'] = {'Fire Maneuver', 'Thunder Maneuver', 'Wind Maneuver', 'Light Maneuver'},
        ['Ranged'] = {'Wind Maneuver', 'Fire Maneuver', 'Thunder Maneuver', 'Light Maneuver'},
        ['Tank'] = {'Earth Maneuver', 'Dark Maneuver', 'Light Maneuver', 'Wind Maneuver'},
        ['Magic'] = {'Ice Maneuver', 'Light Maneuver', 'Dark Maneuver', 'Earth Maneuver'},
        ['Heal'] = {'Light Maneuver', 'Dark Maneuver', 'Water Maneuver', 'Earth Maneuver'},
        ['Nuke'] = {'Ice Maneuver', 'Dark Maneuver', 'Light Maneuver', 'Earth Maneuver'}
    }

    update_pet_mode()
    select_default_macro_book()
end


-- Define sets used by this job file.
function init_gear_sets()
    
    -- Precast Sets
	capePetWS = {Name = "Dispersal Mantle", augments="STR+2", "Pet: TP Bonus +480"}
	capePupTp = {Name = "Dispersal Mantle", augments="STR+1", "DEX+5", "Martial Arts+20"}

    -- Fast cast sets for spells
    sets.precast.FC = {head="Haruspex Hat",ear2="Loquacious Earring",hands="Thaumas Gloves"}

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Beads"})

    
    -- Precast sets to enhance JAs
    sets.precast.JA['Tactical Switch'] = {feet="Cirque Scarpe +2"}
    
    sets.precast.JA['Repair'] = {feet="Foire Babouches +1", lear="Guignol Earring"}

    sets.precast.JA.Maneuver = {neck="Buffoon's Collar",
	body="Cirque Farsetto +2",hands="Foire Dastanas +1",back=capePupTp}
	
	sets.precast.JA['Wind Maneuver'] = {
	-- AGI stats
		head="Espial Cap",
		body="Espial gambison",
		hands="Puppetry dastanas",
		legs="Espial hose",
		feet="Espial socks",
		neck="Buffoon's collar",
		waist="Crudelis Belt",
		left_ring="Garuda ring",
		right_ring="Dumakulem's ring",
		back="Dispersal Mantle"
		}


    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
        head="Whirlpool Mask",ear1="Roundel Earring",
        body="Otronif Harness +1",hands="Otronif Gloves",ring1="Spiral Ring",
        back="Iximulew Cape",legs="Nahtirah Trousers",feet="Thurandaut Boots +1"}
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}

       
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
	sets.precast.WS ={
		head="Whirlpool Mask",
		body="Pitre Tobe +1",
		hands="Espial Bracers",
		legs="Ighwa trousers",
		feet="Daihanshi habiki",
		ear1="Kemas Earring",
		ear2="Brutal Earring",
		neck="Asperity Necklace",
		ring1="Pyrosoul Ring",
		ring2="Vulcan's Ring",
		back="buquwik Cape",
		waist="Sentry Belt"
		}
		
    ----Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Stringing Pummel'] = set_combine(sets.precast.WS, {neck="Rancor Collar",ear1="Brutal Earring",ear2="Moonshade Earring",
        ring1="Spiral Ring",waist="Soil Belt"})
    sets.precast.WS['Stringing Pummel'].Mod = set_combine(sets.precast.WS['Stringing Pummel'], {legs="Nahtirah Trousers"})

    sets.precast.WS['Victory Smite'] = set_combine(sets.precast.WS, {neck="Rancor Collar",ear1="Brutal Earring",ear2="Moonshade Earring",
        waist="Thunder Belt"})

    sets.precast.WS['Shijin Spiral'] = set_combine(sets.precast.WS, {neck="Light Gorget",waist="Light Belt"})

    
    -- Midcast Sets

    sets.midcast.FastRecast = {
        head="Haruspex Hat",ear2="Loquacious Earring",
        body="Otronif Harness +1",hands="Regimen Mittens",
        legs="Manibozho Brais",feet="Otronif Boots +1"}
        

    -- Midcast sets for pet actions
    sets.midcast.Pet.Cure = {legs="Foire Churidars +1"}

    sets.midcast.Pet['Elemental Magic'] = {feet="Pitre Babouches", hands="Regimen Mittens"}

    sets.midcast.Pet.WeaponSkill = {head="Cirque Cappello +2", 
	hands="Cirque Guanti +2", legs="Cirque Pantaloni +2", back=capePetWS}

    
    -- Sets to return to when not performing an action.
    
    -- Resting sets
    sets.resting = {head="Pitre Taj",neck="Wiglen Gorget",
        ring1="Sheltered Ring",ring2="Paguroidea Ring"}
    

    -- Idle sets

    sets.idle = {range="Divinator",
        head="Pitre Taj +1",neck="Orochi nodowa",ear1="Bladeborn Earring",ear2="Steelflash Earring",
        body="Pitre Tobe +1",hands="Foire Dastanas +1",ring1="Sheltered Ring",ring2="Paguroidea Ring",
        back="Contriver's Cape",waist="Hurch'lan Sash",legs="Ighwa trousers",feet="Hermes' Sandals"}

    sets.idle.Town = set_combine(sets.idle, {main="Tinhaspa"})

    -- Set for idle while pet is out (eg: pet regen gear)
    sets.idle.Pet = sets.idle

    -- Idle sets to wear while pet is engaged
    sets.idle.Pet.Engaged = {
        head="Foire Taj",neck="Wiglen Gorget",ear1="Bladeborn Earring",ear2="Cirque Earring",
        body="Foire Tobe",hands="Regimen Mittens",ring1="Sheltered Ring",ring2="Paguroidea Ring",
        back="Dispersal Mantle",waist="Hurch'lan Sash",legs="Foire Churidars",feet="Foire Babouches"}

    sets.idle.Pet.Engaged.Ranged = set_combine(sets.idle.Pet.Engaged, {hands="Cirque Guanti +2",legs="Cirque Pantaloni +2"})

    sets.idle.Pet.Engaged.Nuke = set_combine(sets.idle.Pet.Engaged, {legs="Cirque Pantaloni +2",feet="Cirque Scarpe +2"})

    sets.idle.Pet.Engaged.Magic = set_combine(sets.idle.Pet.Engaged, {legs="Cirque Pantaloni +2",feet="Cirque Scarpe +2"})

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    
    -- Normal melee group
	sets.engaged = {
        head="Pitre Taj +1" , body="Pitre Tobe +1", Back="Pantin Cape", neck="Asperity Necklace", 
		hands="Pitre Dastanas", waist="Hurch'lan Sash", lear="Steelflash Earring", 
		rear="Bladeborn Earring",
		ring1="Cho'j band", ring2="Dumakulem's ring", legs="Qaaxo tights", feet="Foire Babouches +1"}
		--'Master', 'Auto'
	sets.engaged.DT = set_combine(sets.engaged, {head="Whirlpool Mask", neck="Twilight Torque", 
								hand="Regimen Mittens"	})
    
	sets.engaged.Master = {head="Whirlpool Mask", body="Pitre Tobe +1", Back=capePupTp, neck="Asperity Necklace", 
		hands="Regimen mittens", waist="Hurch'lan Sash", lear="Steelflash Earring", rear="Bladeborn Earring",
		ring1="Cho'j band", ring2="Dumakulem's ring", legs="Qaaxo tights", feet="Foire Babouches +1"}
		
	sets.engaged.Master.DT = set_combine(sets.engaged.Master, {neck="Twilight Torque"})
	sets.engaged.Master.Evasion = set_combine(sets.engaged.Master, {head="Pitre Taj +1", 
							neck="Ej Necklace", --hands="Qaaxo mitaines",
							feet="Daihanshi Habaki", waist="Kuku Stone", 
							rear="Phawaylla Earring", lear="Gelai Earring",
							rring="Beeline Ring", lring="Dumakulem's Ring"})

							sets.engaged.Master.Accu = set_combine(sets.engaged.Master, 
							{neck="Ej Necklace", hands="Qaaxo mitaines",
							ring="Beeline Ring", rear="Heartseeker Earring"})
							
    sets.engaged.Auto = set_combine(sets.engaged.Master.DT, {head="Pitre Taj +1",body="Mirke Wardecors",
						hands="Regimen Mittens", legs="Cirque Pantaloni +2"})
    sets.engaged.Auto.DT = set_combine(sets.engaged.Auto,{head="Anwig Salade"}  )  
    -- sets.engaged = {
        -- head="Whirlpool Mask",neck="Asperity Necklace",ear1="Bladeborn Earring",ear2="Steelflash Earring",
        -- body="Pitre Tobe +1",hands="Regimen Mittens",ring1="Rajas Ring",ring2="Epona's Ring",
        -- back=capePupTp,waist="Windbuffet Belt",legs="Qaaxo Tights",feet="Otronif Boots +1"}
    -- sets.engaged.Acc = {
        -- head="Whirlpool Mask",neck="Ej Necklace",ear1="Bladeborn Earring",ear2="Steelflash Earring",
        -- body="Pitre Tobe +1",hands="Otronif Gloves",ring1="Rajas Ring",ring2="Epona's Ring",
        -- back="Dispersal Mantle",waist="Hurch'lan Sash",legs="Ighwa trousers",feet="Otronif Boots +1"}
    -- sets.engaged.DT = {
        -- head="Whirlpool Mask",neck="Twilight Torque",ear1="Bladeborn Earring",ear2="Steelflash Earring",
        -- body="Pitre Tobe +1",hands="Regimen Mittens",ring1="Defending Ring",ring2="Epona's Ring",
        -- back="Contriver's Cape",waist="Hurch'lan Sash",legs="Ighwa Trousers",feet="Daihanshi Habaki"}
    -- sets.engaged.Acc.DT = {
        -- head="Whirlpool Mask",neck="Twilight Torque",ear1="Bladeborn Earring",ear2="Steelflash Earring",
        -- body="Pitre Tobe +1",hands="Regimen Mittens",ring1="Defending Ring",ring2="Beeline Ring",
        -- back="Iximulew Cape",waist="Hurch'lan Sash",legs="Ighwa trousers",feet="Otronif Boots +1"}
		    -- Defense sets

    sets.defense.Evasion = {
        head="Whirlpool Mask",neck="Twilight Torque",
        body="Otronif Harness +1",hands="Otronif Gloves",ring1="Defending Ring",ring2="Beeline Ring",
        back="Ik Cape",waist="Hurch'lan Sash",legs="Nahtirah Trousers",feet="Otronif Boots +1"}

    sets.defense.PDT = sets.engaged.Master.DT
	-- {
        -- head="Whirlpool Mask",neck="Twilight Torque",
        -- body="Pitre Tobe +1",hands="Foire dastanas +1",ring1="Defending Ring",ring2=gear.DarkRing.physical,
        -- back="Contriver's Cape",waist="Hurch'lan Sash",legs="Ighwa Trousers",feet="Daihanshi Habaki"}

    sets.defense.MDT = {
        head="Whirlpool Mask",neck="Twilight Torque",
        body="Otronif Harness +1",hands="Otronif Gloves",ring1="Defending Ring",ring2="Shadow Ring",
        back="Tuilha Cape",waist="Hurch'lan Sash",legs="Nahtirah Trousers",feet="Otronif Boots +1"}

    sets.Kiting = {feet="Hermes' Sandals"}

end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when pet is about to perform an action
function job_pet_midcast(spell, action, spellMap, eventArgs)
    if petWeaponskills:contains(spell.english) then
        classes.CustomClass = "Weaponskill"
		add_to_chat(122,'--------'..spell.english)
    end
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    -- if buff == 'Wind Maneuver' then
        -- handle_equipping_gear(player.status)
    -- end
end

-- Called when a player gains or loses a pet.
-- pet == pet gained or lost
-- gain == true if the pet was gained, false if it was lost.
function job_pet_change(pet, gain)
    update_pet_mode()
end

-- Called when the pet's status changes.
function job_pet_status_change(newStatus, oldStatus)
    if newStatus == 'Engaged' then
        display_pet_status()
    end
end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
    update_pet_mode()
end


-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)
    display_pet_status()
end


-------------------------------------------------------------------------------------------------------------------
-- User self-commands.
-------------------------------------------------------------------------------------------------------------------

-- Called for custom player commands.
function job_self_command(cmdParams, eventArgs)
    if cmdParams[1] == 'maneuver' then
        if pet.isvalid then
            local man = defaultManeuvers[state.PetMode.value]
            if man and tonumber(cmdParams[2]) then
                man = man[tonumber(cmdParams[2])]
            end

            if man then
                send_command('input /pet "'..man..'" <me>')
            end
        else
            add_to_chat(123,'No valid pet.')
        end
    end
end


-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Get the pet mode value based on the equipped head of the automaton.
-- Returns nil if pet is not valid.
function get_pet_mode()
    if pet.isvalid then
        return petModes[pet.head] or 'None'
    else
        return 'None'
    end
end

-- Update state.PetMode, as well as functions that use it for set determination.
function update_pet_mode()
    state.PetMode:set(get_pet_mode())
    update_custom_groups()
end

-- Update custom groups based on the current pet.
function update_custom_groups()
    classes.CustomIdleGroups:clear()
    if pet.isvalid then
        classes.CustomIdleGroups:append(state.PetMode.value)
    end
end

-- Display current pet status.
function display_pet_status()
    if pet.isvalid then
        local petInfoString = pet.name..' ['..pet.head..']: '..tostring(pet.status)..'  TP='..tostring(pet.tp)..'  HP%='..tostring(pet.hpp)
        
        if magicPetModes:contains(state.PetMode.value) then
            petInfoString = petInfoString..'  MP%='..tostring(pet.mpp)
        end
        
        add_to_chat(122,petInfoString)
    end
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    -- if player.sub_job == 'DNC' then
        -- set_macro_page(2, 9)
    -- elseif player.sub_job == 'NIN' then
        -- set_macro_page(3, 9)
    -- elseif player.sub_job == 'THF' then
        -- set_macro_page(4, 9)
    -- else
        -- set_macro_page(1, 9)
    -- end
end

