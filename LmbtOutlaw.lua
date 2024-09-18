-- https://wowwiki-archive.fandom.com/wiki/API_UnitAura
-- https://wowwiki-archive.fandom.com/wiki/API_GetSpellCooldown

local function OnEvent(self, event, ...)
	-- Relevant auras
	local stealthAura = C_UnitAuras.GetPlayerAuraBySpellID(115191);
	local subterfugeAura = C_UnitAuras.GetPlayerAuraBySpellID(115192);
	local adrenalineRushAura = C_UnitAuras.GetPlayerAuraBySpellID(13750);
	local loadedDiceAura = C_UnitAuras.GetPlayerAuraBySpellID(256171);
	-- RTB buffs
	local rtbBuffs = {
		C_UnitAuras.GetPlayerAuraBySpellID(193356),
		C_UnitAuras.GetPlayerAuraBySpellID(199600),
		C_UnitAuras.GetPlayerAuraBySpellID(193358),
		C_UnitAuras.GetPlayerAuraBySpellID(193357),
		C_UnitAuras.GetPlayerAuraBySpellID(199603),
		C_UnitAuras.GetPlayerAuraBySpellID(193359)
	}

	--Between the Eyes
	local comboPoints = GetComboPoints("player", "target");
	if stealthAura and comboPoints >= 5 then
		ActionButton_ShowOverlayGlow(ElvUI_Bar1Button4);
	elseif subterfugeAura and (subterfugeAura.expirationTime - GetTime() > 0.5) and comboPoints >= 5 then
		ActionButton_ShowOverlayGlow(ElvUI_Bar1Button4);
	else
		ActionButton_HideOverlayGlow(ElvUI_Bar1Button4);
	end


	--Vanish
	local bteSpellCd = C_Spell.GetSpellCooldown(315341);
	local vanishSpellCharges = C_Spell.GetSpellCharges(1856);
	if adrenalineRushAura and bteSpellCd.duration == 0 and vanishSpellCharges.currentCharges > 0 and not (stealthAura or subterfugeAura) then
		ActionButton_ShowOverlayGlow(ElvUI_Bar3Button1);
	else
		ActionButton_HideOverlayGlow(ElvUI_Bar3Button1);
	end

	--Roll the Bones
	local rtbSpellCd = C_Spell.GetSpellCooldown(315508);
	if not subterfugeAura and rtbSpellCd.duration == 0 then
		local i = 0;
		for k, v in pairs(rtbBuffs) do
			if v then
				i = i + 1;
			end
		end
		if i == 0 or (i == 1 and loadedDiceAura) then
			ActionButton_ShowOverlayGlow(ElvUI_Bar6Button1);
		end
	else
		ActionButton_HideOverlayGlow(ElvUI_Bar6Button1);
	end
 end
  
 local f = CreateFrame("Frame");
 f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
 f:SetScript("OnEvent", OnEvent);

 -- Highlight button
 --Button.LockHighlight()
 
 -- VANISH
 --/run ActionButton_ShowOverlayGlow(ElvUI_Bar3Button1)

 -- RTB
 --/run ActionButton_ShowOverlayGlow(ElvUI_Bar6Button1)

 -- BETWEEN THE EYES
 --/run ActionButton_ShowOverlayGlow(ElvUI_Bar1Button4)