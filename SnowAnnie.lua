if myHero.charName ~= "Annie" then return end


-- Downloads Nebelwoli's L33T UPL Prediction Manager--
if not _G.UPLloaded then 
  if FileExist(LIB_PATH .. "/UPL.lua") then 
    require("UPL") 
    _G.UPL = UPL() 
  else  
    print("Downloading UPL, please don't press F9") 
    DelayAction(function() DownloadFile("https://raw.github.com/nebelwolfi/BoL/master/Common/UPL.lua".."?rand="..math.random(1,10000), LIB_PATH.."UPL.lua", function () print("Successfully downloaded UPL. Press F9 twice.") end) end, 3)  
    return 
  end 
end

function OnLoad() 
	IniMenu() 
	IniSpells() 
end 
 
function IniMenu() 
	Menu = scriptConfig("SnowAnnie", "SnowAnnie") 
	Menu:addSubMenu("Q - Settings", "q")
	Menu.q:addSubMenu("Lasthit", "lh")
		Menu.q.lh:addParam("use","Use in Lasthit", SCRIPT_PARAM_ONOFF, true)
	Menu.q:addSubMenu("Harras", "h")
		Menu.q.h:addParam("use","Use in Harras", SCRIPT_PARAM_ONOFF, true)
	Menu.q:addSubMenu("Combo", "c")
		Menu.q.c:addParam("use","Use in Combo", SCRIPT_PARAM_ONOFF, true)


	Menu:addSubMenu("W - Settings", "w")
	Menu.w:addSubMenu("Laneclear", "lc")
		Menu.w.lc:addParam("use","Use in Laneclear", SCRIPT_PARAM_ONOFF, true)
	Menu.w:addSubMenu("Harras", "h")
		Menu.w.h:addParam("use","Use in Harras", SCRIPT_PARAM_ONOFF, true)
	Menu.w:addSubMenu("Combo", "c")
		Menu.w.c:addParam("use","Use in Combo", SCRIPT_PARAM_ONOFF, true)


	Menu:addSubMenu("E - Settings", "e")
	Menu.e:addSubMenu("Combo", "c")
		Menu.e.c:addParam("use","Use in Combo", SCRIPT_PARAM_ONOFF, true)


	Menu:addSubMenu("R - Settings", "r")
	Menu.r:addSubMenu("Combo", "c")
		Menu.r.c:addParam("use","Use in Combo", SCRIPT_PARAM_ONOFF, true)


Menu:addSubMenu("Key Config", "keys")
	Menu.keys:addParam("combo", "Combo Key", SCRIPT_PARAM_ONKEYDOWN,false, string.byte(" "))
	Menu.keys:addParam("harras", "Harras Key", SCRIPT_PARAM_ONKEYDOWN,false, string.byte("C"))
	Menu.keys:addParam("laneclear", "Laneclear Key", SCRIPT_PARAM_ONKEYDOWN,false, string.byte("V"))
	Menu.keys:addParam("lasthit", "lasthit Key", SCRIPT_PARAM_ONKEYDOWN,false, string.byte("X"))
end


isSkillShotQ = false
isSkillShotW = true
isSkillShotE = false
isSkillShotR = true
function IniSpells()
	UPL:AddSpell(_W, {speed = math.huge, delay = 0.25, range = 625, width = 50, collision = false, aoe = false, type = "cone"})
	UPL:AddSpell(_R, {speed = math.huge, delay = 0.25, range = 600, width = 290, collision = false, aoe = true, type = "circular"})
	UPL:AddToMenu2(Menu)
end


function OnTick()
	if not Menu then return end
	if Menu.keys.combo then
		if Menu.q and Menu.q.c then
			CastQ()
		end
		if Menu.w and Menu.w.c then
			CastW()
		end
		if Menu.e and Menu.e.c then
			CastE()
		end
		if Menu.r and Menu.r.c then
			CastR()
		end
	end

	if Menu.keys.harras then
		if Menu.q and Menu.q.h then
			CastQ()
		end
		if Menu.w and Menu.w.h then
			CastW()
		end
		if Menu.e and Menu.e.h then
			CastE()
		end
		if Menu.r and Menu.r.h then
			CastR()
		end
	end

	if Menu.keys.lasthit then
		if Menu.q and Menu.q.lh then
			CastQ()
		end
		if Menu.w and Menu.w.lh then
			CastW()
		end
		if Menu.e and Menu.e.lh then
			CastE()
		end
		if Menu.r and Menu.r.lh then
			CastR()
		end
	end

	if Menu.keys.laneclear then
		if Menu.q and Menu.q.lc then
			CastQ()
		end
		if Menu.w and Menu.w.lc then
			CastW()
		end
		if Menu.e and Menu.e.lc then
			CastE()
		end
		if Menu.e and Menu.r.lc then
			CastR()
		end
	end

local target = nil
	target = GetEnemyHeroTarget(625)
	if target and target.health < myHero:GetSpellData(_Q).level*35+45+0.8*myHero.ap then
		CastQ(target)
	end
	target = nil
	
	target = GetEnemyHeroTarget(625)
	if target and target.health < myHero:GetSpellData(_W).level*25+45+0.85*myHero.ap then
		CastQ(target)
	end
	target = nil
	
	target = GetEnemyHeroTarget(600)
	if target and target.health < myHero:GetSpellData(_W).level*25+125+0.65*myHero.ap then
		CastQ(target)
	end
	target = nil
	
end
function GetEnemyHeroTarget(range)
	local target = nil
	for _, object in pairs(GetEnemyHeroes()) do
		if object and object.valid and not object.dead and myHero.type == object.type and ((myHero.team == 100 and object.team == 200) or (myHero.team == 200 and object.team == 100)) and GetDistance(object) < range then
			if not target then
				target = object
			elseif target.health < object.health then
				target = object
			end
		end
	end
	return target
end

enemyMinions = minionManager(MINION_ENEMY, 1500, player, MINION_SORT_HEALTH_ASC)
JungleMinions = minionManager(MINION_JUNGLE, 1500, player, MINION_SORT_HEALTH_DES)

function GetEnemyMinionTarget(range)
	enemyMinions.range = range
	enemyMinions:update()
	return enemyMinions.objects[1]
end


function GetAllyHeroTarget(range)
	local target = nil
	for _, object in pairs(GetAllyHeroes()) do
		if object and object.valid and not object.dead and object.team == myHero.team and not object.isMe and object.type == myHero.type and GetDistance(object) < range then
			if not target then
				target = object
			elseif target.health < object.health then
				target = object
			end
		end
	end
	return target
end


function GetJungleTarget(range)
	JungleMinions.range = range
	JungleMinions:update()
	return JungleMinions.objects[1]
end

local targets = {}
lastrequests = {0,0,0,0}
function GetTarget(range,self,enemy,ally,jungle,minion)

	local target = nil
	if self then
		if ally then
			if lastrequests[2] > os.clock() and targets[2] and targets[2].valid and not targets[2].dead and GetDistance(targets[2]) < range then
				target = targets[2]
			else
				target = GetAllyHeroTarget()
				targets[2] = target
				lastrequests[2] = os.clock()+0.1
			end
		end
		return target or myHero
	end
	
	if ally then
		if lastrequests[2] > os.clock() and targets[2] and targets[2].valid and not targets[2].dead and GetDistance(targets[2]) < range then
			target = targets[2]
		else
			targets[2] = target
			
			lastrequests[2] = os.clock()+0.1
			target = GetAllyHeroTarget(range)
		end
		if target then return target end			
	end
	
	if enemy then
		if lastrequests[1] > os.clock() and targets[1] and targets[1].valid and not targets[1].dead and GetDistance(targets[1]) < range then
			target = targets[1]
		else
			targets[1] = target
			lastrequests[1] = os.clock()+0.1
			target = GetEnemyHeroTarget(range)
		end
		if target then return target end
	end 
	
	if jungle then
		if lastrequests[3] > os.clock() and targets[3] and targets[3].valid and not targets[3].dead and GetDistance(targets[3]) < range then
			target = targets[3]
		else
			targets[3] = target
			lastrequests[3] = os.clock()+0.1
			target = GetJungleTarget(range)
		end
		if target then return target end
	end
	
	if minion then
		if lastrequests[4] > os.clock() and targets[4] and targets[4].valid and not targets[4].dead and GetDistance(targets[4]) < range then
			target = targets[4]
		else
			targets[4] = target
			lastrequests[4] = os.clock()+0.1
			target = GetEnemyMinionTarget(range)
		end
		if target then return target end
	end
end
function CastQ(t)
	local target = t ~= nil and t or GetTarget(625,false,true,false,false,true)
	if not target then return end
	if GetDistance(target) < 0 then return end
	if myHero:CanUseSpell(_Q) ~= 0 then return end
	if isSkillShotQ then
		local pos, hs = UPL:Predict(_Q, myHero, target)
		if pos and hs and hs >= 2 then
			CastSpell(_Q, pos.x, pos.z)
		end
	else
		CastSpell(_Q, target)
	end
end

function CastW(t)
	local target = t ~= nil and t or GetTarget(625,false,true,false,false,true)
	if not target then return end
	if GetDistance(target) < 0 then return end
	if myHero:CanUseSpell(_W) ~= 0 then return end
	if isSkillShotW then
		local pos, hs = UPL:Predict(_W, myHero, target)
		if pos and hs and hs >= 2 then
			CastSpell(_W, pos.x, pos.z)
		end
	else
		CastSpell(_W, target)
	end
end

function CastE(t)
	local target = t ~= nil and t or GetTarget(0,true,false,false,false,false)
	if not target then return end
	if GetDistance(target) < 0 then return end
	if myHero:CanUseSpell(_E) ~= 0 then return end
	if isSkillShotE then
		local pos, hs = UPL:Predict(_E, myHero, target)
		if pos and hs and hs >= 2 then
			CastSpell(_E, pos.x, pos.z)
		end
	else
		CastSpell(_E, target)
	end
end

function CastR(t)
	local target = t ~= nil and t or GetTarget(600,false,true,false,false,false)
	if not target then return end
	if GetDistance(target) < 0 then return end
	if myHero:CanUseSpell(_R) ~= 0 then return end
	if isSkillShotR then
		local pos, hs = UPL:Predict(_R, myHero, target)
		if pos and hs and hs >= 2 then
			CastSpell(_R, pos.x, pos.z)
		end
	else
		CastSpell(_R, target)
	end
end




--[[
   ______          ________ _____         _____                           _               _              _____ __                 _      
  / __ \ \        / /  ____|  __ \       / ____|                         | |             | |            / ____/_ |               | |     
 | |  | \ \  /\  / /| |__  | |__) |_____| |  __  ___ _ __   ___ _ __ __ _| |_ ___  _ __  | |__  _   _  | (___  | |_ __ ___  _ __ | | ___ 
 | |  | |\ \/  \/ / |  __| |  _  /______| | |_ |/ _ \ '_ \ / _ \ '__/ _` | __/ _ \| '__| | '_ \| | | |  \___ \ | | '_ ` _ \| '_ \| |/ _ \
 | |__| | \  /\  /  | |____| | \ \      | |__| |  __/ | | |  __/ | | (_| | || (_) | |    | |_) | |_| |  ____) || | | | | | | |_) | |  __/
  \___\_\  \/  \/   |______|_|  \_\      \_____|\___|_| |_|\___|_|  \__,_|\__\___/|_|    |_.__/ \__, | |_____/ |_|_| |_| |_| .__/|_|\___|
                                                                                                 __/ |                     | |           
                                                                                                |___/                      |_|           
]]--
