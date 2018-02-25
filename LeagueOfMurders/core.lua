--Создание фрейма и таблицы эвентов, скрываем фрейм
local LeagueofMurders, events = CreateFrame("Frame", nil, UIParent), {}
LeagueofMurders:Hide()

--Объявляем переменные
local db, options

--Таблица с настройками по умолчанию
local defaults = {
	debug = false
}

--Таблица с настройками для GUI
options = {
	name = "League of Murders Options",
	type = "group",
	args = {
		general = {
			name = "General Options",
			type = "group",
			args = {
				debugmode = {
					name = "Debug mode",
					desc = "Show debug messages in chat.",
					type = "toggle",
                    get = function() return db.debug end,
					set = function() db.debug = not db.debug end,
					order = 1,
				}
			},
		},
	},
}

--Регистрируем таблицу с настройками для GUI и добавляем в меню настроек Интерфейса
LibStub("AceConfig-3.0"):RegisterOptionsTable("LeagueofMurders", options)
LeagueofMurders.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("LeagueofMurders", "League of Murders", nil, "general")

--Создаем и регестрируем слэш команду для быстрого доступа к настройкам
SlashCmdList["LEAGUEOFMURDERS"] = function() InterfaceOptionsFrame_OpenToCategory("League of Murders") end
SLASH_LEAGUEOFMURDERS1 = "/lom"

--Создаем кнопку возле мини карты и главный фрейм
local mMapButton = createMinimapButton()

--Создаем событие для кнопки около мини карты
mMapButton:SetScript("OnClick", function()

    --Если персонаж в гильдии, то
    if IsInGuild() then

        --Присваиваем значение переменным
        for i=1,GetNumGuildMembers() do 
            name, rank, rankIndex, level, classDisplayName, zone, note, officernote, isOnline, status, class, achievementPoints, achievementRank, isMobile, canSoR, repStanding = GetGuildRosterInfo(i) 
            if name == UnitName("player") then 
                break 
            end 
        end
      
        guildName, guildRankName, guildRankIndex = GetGuildInfo("player");
        playerName = UnitName("player");
        --respPoints, arenaRate = officernote:match("([^,]+),([^,]+)")

        --Создаем фрейм книги
        local codexFrame = createCodexFrame(1)

        --Если окно кодекса создано, то оно будет скрыто
        if codexFrame:IsVisible() then codexFrame:Hide() else codexFrame:Show() end 

        --Если дебаг мод включен, то выводим сообщение
        if LoMDB.debug then print('|cFFCC0000Debug:|r OnClick fires.\nGuild name: ' .. guildName .. '\nRank name: ' .. guildRankName .. ' (' .. guildRankIndex .. ')') end

        --Если гильдия называеться Лига убийц, то
        if guildName == "Лига Убийц" then 

            --разграничиваем доступ по рангам
            if guildRankIndex <= 7 then 
                perm = 1 --Марадер и выше
            elseif guildRankIndex == 9 then 
                perm = 2 --Изгой
            elseif guildRankIndex == 8 then
                perm = 3 --Убийца
            end
        
        --Иначе, ограничиваем доступ
        else
            perm = 0
        end
    
    --Если не в гильдии, то выводим сообщение
    else
        print("Вы не состоите в гильдии.")
    end	

end)

--Объявляем эвент PLAYER_ENTERING_WORLD
function events:PLAYER_ENTERING_WORLD(...)

    --Загружаем настройки из базы данных
    LoMDB = LoMDB or {}
    for k,v in pairs(defaults) do
        if type(LoMDB[k]) == "nil" then
        LoMDB[k] = v
        end
    end
    db = LoMDB

    --Сообщение о срабатывании эвента
    if LoMDB.debug then print('|cFFCC0000Debug:|r PLAYER_ENTERING_WORLD fires.') end

end

function events:GUILD_MOTD(...)

    --Если дебаг мод включен, выводим сообщение
    if LoMDB.debug then print('|cFFCC0000Debug:|r GUILD_MOTD fires.') end

end

--Регестрируем эвенты
LeagueofMurders:SetScript("OnEvent", function(self, event, ...)
    events[event](self, ...); 
end);

for k, v in pairs(events) do
    LeagueofMurders:RegisterEvent(k);
end