--Создание фрейма и таблицы эвентов, скрываем фрейм
local LeagueofMurders, events = CreateFrame("Frame", nil, UIParent), {};

--Объявляем переменные
local db, options;
updInt = 2.0;
LastUpdate = 0;
playerName = UnitName("player");

--Таблица с настройками по умолчанию
local defaults = {
	debug = false;
};

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
};

--Регистрируем таблицу с настройками для GUI и добавляем в меню настроек Интерфейса
LibStub("AceConfig-3.0"):RegisterOptionsTable("LeagueofMurders", options);
LeagueofMurders.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("LeagueofMurders", "League of Murders", nil, "general");

--Создаем и регестрируем слэш команду для быстрого доступа к настройкам
SlashCmdList["LEAGUEOFMURDERS"] = function() InterfaceOptionsFrame_OpenToCategory("League of Murders") end;
SLASH_LEAGUEOFMURDERS1 = "/lom";

--Создаем кнопку возле мини карты
local mMapButton = createMinimapButton();

--Создаем фрейм книги
codexFrame = createCodexFrame();

--Получение и обновление информации
mMapButton:SetScript("OnUpdate", function(self, elapsed) 

    LastUpdate = LastUpdate + elapsed; 	

    if (LastUpdate > updInt) then

        --Присваиваем значение переменным
        guildName, guildRankName, guildRankIndex = GetGuildInfo("player");

        if guildName == "Лига Убийц" then 

        --Обновляем данные
        GuildRoster();

        for i=1,GetNumGuildMembers() do 

            name, rank, rankIndex, level, className, zone, note, officernote, isOnline, _, _, _, _, _, _, _ = GetGuildRosterInfo(i);

            if name == playerName then 
                break;
            end;

        end;
            
        --Обработка исключений
        if (guildName == nil) then guildName = "Лига Убийц" end;
        if (guildRankName == nil) then guildRankName = "" end;
        if (guildRankIndex == nil) then guildRankIndex = "0" end;
        if (officernote == nil) then officernote = '0,0' end;
        if (zone == nil) then zone = "" end;

        respPoints, supPoints = officernote:match("([^,]+),([^,]+)");

        infoText:SetText(
        "                            Информация:" ..
        "\n\n                            Имя: " .. playerName ..
        "\n                            Ранг: " .. guildRankName .. 
        "\n                            Очки уважения: " .. respPoints ..
        "\n                            Очки снабжения: " .. supPoints ..
        "\n\nЛокация: " .. zone);

        SetPortraitTexture(codexPortrait, "player");

        end;

        LastUpdate = 0;
    end
    
end);

--Создаем событие для кнопки около мини карты
mMapButton:SetScript("OnClick", function()

    --Если персонаж в гильдии, то
    if IsInGuild() then

        --Если окно кодекса отображается, то оно будет скрыто
        if codexFrame:IsVisible() then codexFrame:Hide() else codexFrame:Show() end; 

        --Если дебаг мод включен, то выводим сообщение
        if LoMDB.debug then print('|cFFCC0000Debug:|r OnClick fires.\nGuild name: ' .. guildName .. '\nRank name: ' .. guildRankName .. ' (' .. guildRankIndex .. ')') end;

        --Если гильдия называеться Лига убийц, то
        if guildName == "Лига Убийц" then 

            --разграничиваем доступ по рангам
            if guildRankIndex <= 7 then 
                perm = 1 --Марадер и выше
            elseif guildRankIndex == 9 then 
                perm = 2 --Изгой
            elseif guildRankIndex == 8 then
                perm = 3 --Убийца
            end;
        
        --Иначе, ограничиваем доступ
        else
            perm = 0
        end;
    
    --Если не в гильдии, то выводим сообщение
    else
        print("Вы не состоите в гильдии.")
    end;

end)

--При входе в игру
function events:PLAYER_LOGIN()

    --Загружаем настройки из базы данных
    LoMDB = LoMDB or {}

    for k,v in pairs(defaults) do
        if type(LoMDB[k]) == "nil" then
        LoMDB[k] = v
        end;
    end;

    db = LoMDB

    --Инициализируем базу
    if charINFO == nil then charINFO = {} end;

    --Загружаем записи из базы
    if #charINFO > 0 then 
        for i = 1, #charINFO do
            local msg = string.format("%s|%s|%s|%s|%s|%s", charINFO[i].updTime, charINFO[i].chName, charINFO[i].chRank, charINFO[i].chLocation, charINFO[i].rPoints, charINFO[i].sPoints);
            SendAddonMessage("LOM", msg, "GUILD");
        end;
    end;

end;

--Объявляем эвент PLAYER_ENTERING_WORLD
function events:PLAYER_ENTERING_WORLD(...)

    --Сообщение о срабатывании эвента
    if LoMDB.debug then print('|cFFCC0000Debug:|r PLAYER_ENTERING_WORLD fires.') end

end

function events:GUILD_MOTD(...)

    --Если дебаг мод включен, выводим сообщение
    if LoMDB.debug then print('|cFFCC0000Debug:|r GUILD_MOTD fires.') end

end

if guildName == "Лига Убийц" then 

function events:PLAYER_LEAVING_WORLD(...)

    -- Идем по таблице
    for i = 1, #charINFO do
        -- Если запись с именем персонажа найдена
        if playerName == charINFO[i].chName then
            -- Присваиваем значения полям таблицы
            charINFO[i].updTime = date("%m/%d/%y %H:%M:%S");
            charINFO[i].chName = playerName;
            charINFO[i].chRank = rank .. '(' .. rankIndex .. ')';
            charINFO[i].chLocation = zone;
            charINFO[i].rPoints = respPoints;
            charINFO[i].sPoints = supPoints;            
            --Выходим из функции
            return;
        end;
    end;

    --Если прошли весь цикл и нет совпадений создаем таблицу
    charINFO_local = {  updTime = date("%m/%d/%y %H:%M:%S"), 
                        chName = playerName, 
                        chRank = rank .. '(' .. rankIndex .. ')', 
                        chLocation = zone, 
                        rPoints = respPoints, 
                        sPoints = supPoints
                    };

    --Вставляем в конец главной таблицы
    tinsert(charINFO, charINFO_local);

end

--Сохраняем в базу полученную инфу
local comm = CreateFrame("Frame");
comm:RegisterEvent("CHAT_MSG_ADDON");
comm:SetScript("OnEvent", function(self, event, prefix, msg, channel, sender)

    if prefix == "LOM" then
        
        if LoMDB.debug then print(string.format("|cFFCC0000Debug:|r [%s] [%s] : %s", prefix, sender, msg)) end;

        local updTime, chName, chRank, chLocation, rPoints, sPoints = string.split("|", msg);

        for i = 1, #charINFO do
            -- Если запись с именем персонажа найдена
            if chName == charINFO[i].chName then
                -- Присваиваем значения полям таблицы
                charINFO[i].updTime = date("%m/%d/%y %H:%M:%S")
                charINFO[i].chName = chName
                charINFO[i].chRank = chRank
                charINFO[i].chLocation = chLocation
                charINFO[i].rPoints = rPoints
                charINFO[i].sPoints = sPoints
                --Выходим из функции
                return;
            end;
        end;
    
        --Если прошли весь цикл и нет совпадений создаем таблицу
        charINFO_local = {  updTime = date("%m/%d/%y %H:%M:%S"),
                            chName = chName, 
                            chRank = chRank, 
                            chLocation = chLocation, 
                            rPoints = rPoints, 
                            sPoints = sPoints
                        };

        --Вставляем в конец главной таблицы
        tinsert(charINFO, charINFO_local);
    end;
end)

end

--Регестрируем эвенты
LeagueofMurders:SetScript("OnEvent", function(self, event, ...)
    events[event](self, ...); 
end);

for k, v in pairs(events) do
    LeagueofMurders:RegisterEvent(k);
end