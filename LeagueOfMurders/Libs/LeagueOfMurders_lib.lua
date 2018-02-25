chapter = {{},{},{},{}}
x = 468;
cLshow = true

---temp store
intro = 
'   Каждый член Лиги Убийц обязан\n' ..
'иметь свою копию кодекса. Кодекс\n' ..  
'вносит ряд необратимых изменений\n' ..
'в восприятие текущей реальности.\n' ..
'Если вы не готовы что либо менять\n' ..
'в своей жизни - не рекомендуется\n' .. 
'использовать данный фолиант. При\n' ..
'работе кодекса убийцы используется\n' ..
'темная магия и немного энергии\n' ..
'его владельца. Будьте предельно\n' ..
'осторожны.\n' ..
'             Строго запрещается:\n' ..
'1. Разглашать информацию о кодексе\n' ..
'любому кто не принадлежит тайной\n' ..
'организации Лига Убийц.\n' ..
'2. Использовать кодекс в людных\n' ..
'местах.\n' ..
'3. Пытаться внести изменения в \n'..
'кодекс в одностороннем порядке. \n' ..
'4. Терять, отдавать, или дарить. \n'..
'             Правила использования: \n'..
'1. Проверить отсутствие поблизости\n' ..
'посторонних глаз. \n'..
'2. Прикоснуться к гербу на обложке.\n'..
'3. Изучить информацию на главной\n' ..
'странице кодекса. \n'..
'             Приятного использования.'
--


function createMinimapButton ()

  local button = CreateFrame("Button", "LoM_Button", Minimap)
  button:SetFrameStrata("MEDIUM")
  button:SetWidth(31); button:SetHeight(31)
  button:SetFrameLevel(8)
  button:RegisterForClicks("anyUp")
  button:RegisterForDrag("LeftButton")
  button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

  local overlay = button:CreateTexture(nil, "OVERLAY")
  overlay:SetWidth(53); overlay:SetHeight(53)
  overlay:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
  overlay:SetPoint("TOPLEFT")

  local icon = button:CreateTexture(nil, "BACKGROUND")
  icon:SetWidth(31); icon:SetHeight(31)
  icon:SetTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\miniMapButton.blp")
  icon:SetPoint("TOPLEFT", 0, 1)

  return button

end

function btn_constr(Parent, posX, posY, btnX, btnY, hide)

  local Frame = CreateFrame("Button", nil, Parent)
  Frame:SetPoint("LEFT", Parent, "TOPLEFT", posX, posY)
  Frame:SetSize(btnX, btnY)

  if hide then 
    Frame:Hide()
    else
    Frame:Show()
  end 

  return Frame

end

-->Создание фрейма книги
function createCodexFrame(chap)
  
  if codexFrame then 

    if LoMDB.debug then print('|cFFCC0000Debug:|r Frame exists') end

  else
  
    codexFrame = CreateFrame("Frame", "codexFrame", UIParent);
    codexFrame:EnableMouse(1); codexFrame:SetMovable(1)
    codexFrame:RegisterForDrag("LeftButton");
    codexFrame:SetWidth(x); codexFrame:SetHeight(x)
    codexFrame:SetPoint("TOPLEFT");
    codexFrame:Hide();

    codexFrame:SetScript("OnDragStart", function(self) 
      self:StartMoving() 
    end);

    codexFrame:SetScript("OnDragStop", function(self) 
      self:StopMovingOrSizing() 
    end);

    -->Создание Обложки
    codexCover = CreateFrame("Frame", "codexCover", codexFrame)
    codexCover:SetPoint("TOPLEFT")
    codexCover:SetWidth(x); codexCover:SetHeight(x)

    local coverTexture = codexCover:CreateTexture(nil, "BACKGROUND")
    coverTexture:SetPoint("TOPLEFT")
    coverTexture:SetWidth(x); coverTexture:SetHeight(x)
    coverTexture:SetTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\codexCover.blp")

    local coverButton = CreateFrame("Button", "coverBtn", codexCover)
    coverButton:SetPoint("CENTER", 18, -11)
    coverButton:SetWidth(200); coverButton:SetHeight(200)
    coverButton:SetNormalTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\tempCoverBtn.blp")
    
    coverButton:SetScript("OnClick", function()
      if (perm == 0) or (perm == 2) then 
      else
        codexCover:Hide(); 
        codexFrame:EnableMouse(0); 
        codexBook:Show() 
        codexTextRight:Show(); 
        codexTextRight:SetText(intro);
      end
    end);
    --

    -->Создание Книги
    codexBook = CreateFrame("Frame", "codexBook", codexFrame)
    codexBook:Hide()
    codexBook:EnableMouse(1)
    codexBook:SetMovable(1)
    codexBook:RegisterForDrag("LeftButton")
    codexBook:SetWidth(x+x/2)
    codexBook:SetHeight(x)
    codexBook:SetPoint("TOPRIGHT", x/2, 0)

    codexBook:SetScript("OnDragStart", function(self) 
      self:StartMoving() 
    end)

    codexBook:SetScript("OnDragStop", function(self) 
      self:StopMovingOrSizing() 
    end)
    
    local codexLeft = codexBook:CreateTexture("tst", "BACKGROUND")
    codexLeft:SetPoint("TOPLEFT")
    codexLeft:SetWidth(x)
    codexLeft:SetHeight(x)
    codexLeft:SetTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\bookFrame\\codex_00Left.blp")

    local codexRight = codexBook:CreateTexture(nil, "BACKGROUND")
    codexRight:SetPoint("TOPLEFT", x, 0)
    codexRight:SetWidth(x/2)
    codexRight:SetHeight(x)
    codexRight:SetTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\bookFrame\\codex_00Right.blp")

    --info part 
    infoText = codexBook:CreateFontString("infoText", "ARTWORK", 1);
    infoText:SetFont("Fonts\\MORPHEUS.ttf", 16);
    infoText:SetJustifyH("LEFT");
    infoText:SetJustifyV("TOP");
    infoText:SetPoint("TOPLEFT", codexLeft, "TOPLEFT", 168, -45);
    infoText:SetTextColor(0.2,0.15,0.10);
    infoText:SetWordWrap(1);
    infoText:SetText("Имя: " .. playerName .. "\nРанг: " .. guildRankName .. "\nЛокация: " .. 
      zone .. "\nОчки уважения: ");-- .. respPoints .. "\nПринял: blank");

    --portrait
    codexPortraitBorder = codexBook:CreateTexture(nil, "ARTWORK")
    codexPortraitBorder:SetHeight(110); codexPortraitBorder:SetWidth(110)
    codexPortraitBorder:SetPoint("TOPLEFT", codexLeft, "TOPLEFT", 45, -40)
    codexPortraitBorder:SetTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\portraitBorder.blp")

    codexPortrait = codexBook:CreateTexture(nil, "ARTWORK")
    codexPortrait:SetHeight(87); codexPortrait:SetWidth(87)
    codexPortrait:SetPoint("TOPLEFT", codexLeft, "TOPLEFT", 58, -50)
    SetPortraitTexture(codexPortrait, "player")

    -->Кнопка "Глава 1"
    local chapBtn1 = btn_constr(codexBook, 385, -75, 120, 60, true)
    chapBtn1:SetNormalTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\chapBtns\\chapBtn1.blp")
    chapBtn1:SetHighlightTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\chapBtns\\chapBtnHL.blp")
    
    chapBtn1:SetScript("OnClick", function()
      print("Глава 1")
    end)

    chapBtn1:SetScript("OnEnter", function()
      BtnDescText:SetText("Глава 1")
    end)

    chapBtn1:SetScript("OnLeave", function()
      BtnDescText:SetText("")
    end)
    --

    -->Кнопка "Глава 2"
    local chapBtn2 = btn_constr(codexBook, 485, -75, 120, 60, true)
    chapBtn2:SetNormalTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\chapBtns\\chapBtn2.blp")
    chapBtn2:SetHighlightTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\chapBtns\\chapBtnHL.blp")
    
    chapBtn2:SetScript("OnClick", function()
      print("Глава 2")
    end)

    chapBtn2:SetScript("OnEnter", function()
      BtnDescText:SetText("Глава 2")
    end)

    chapBtn2:SetScript("OnLeave", function()
      BtnDescText:SetText("")
    end)
    --

    -->Кнопка "Глава 3"
    local chapBtn3 = btn_constr(codexBook, 385, -130, 120, 60, true)
    chapBtn3:SetNormalTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\chapBtns\\chapBtn3.blp")
    chapBtn3:SetHighlightTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\chapBtns\\chapBtnHL.blp")
    
    chapBtn3:SetScript("OnClick", function()
      print("Глава 3")
    end)

    chapBtn3:SetScript("OnEnter", function()
      BtnDescText:SetText("Глава 3")
    end)

    chapBtn3:SetScript("OnLeave", function()
      BtnDescText:SetText("")
    end)

    -->Кнопка "Глава 4"
    local chapBtn4 = btn_constr(codexBook, 485, -130, 120, 60, true)
    chapBtn4:SetNormalTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\chapBtns\\chapBtn4.blp")
    chapBtn4:SetHighlightTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\chapBtns\\chapBtnHL.blp")
    
    chapBtn4:SetScript("OnClick", function()
      print("Глава 4")
    end)

    chapBtn4:SetScript("OnEnter", function()
      BtnDescText:SetText("Глава 4")
    end)

    chapBtn4:SetScript("OnLeave", function()
      BtnDescText:SetText("")
    end)
    --

    -->Кнопка "Настройки"
    local settingsBtn = btn_constr(codexBook, 631, -350, 45, 45, false)
    settingsBtn:SetNormalTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\codexLabelSettings.blp")
    settingsBtn:SetPushedTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\codexLabelSettings.blp")
    settingsBtn:SetHighlightTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\codexLabelSettings.blp")
    
    settingsBtn:SetScript("OnClick", function()
      InterfaceOptionsFrame_OpenToCategory("League of Murders")
    end)

    settingsBtn:SetScript("OnEnter", function()
      BtnDescText:SetText("Настройки")
    end)

    settingsBtn:SetScript("OnLeave", function()
      BtnDescText:SetText("")
    end)
    --

    -->Кнопка "Выход"
    local hideBtn = btn_constr(codexBook, 631, -395, 45, 45, false)
    hideBtn:SetNormalTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\codexLabelClose.blp")
    hideBtn:SetPushedTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\codexLabelClose.blp")
    hideBtn:SetHighlightTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\codexLabelClose.blp")
    
    hideBtn:SetScript("OnClick", function()
      codexFrame:Hide()
    end)

    hideBtn:SetScript("OnEnter", function()
      BtnDescText:SetText("Положить книгу в рюкзак.")
    end)

    hideBtn:SetScript("OnLeave", function()
      BtnDescText:SetText("")
    end)
    --

    -->Кнопка "Кодекс"
    local codexLabel = btn_constr(codexBook, 631, -70, 45, 45, false)
    codexLabel:SetNormalTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\codexLabelTexts.blp")
    codexLabel:SetPushedTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\codexLabelTexts.blp")
    codexLabel:SetHighlightTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\codexLabelTexts.blp")

    codexLabel:SetScript("OnClick", function()
      if cLshow then
        BtnDescText:SetPoint("TOPLEFT", codexLeft, "TOPLEFT", 80, -405)
        codexTextLeft:Show(); codexTextLeft:SetText("Место для пролога"); codexTextRight:Hide()        
        codexLeft:SetTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\bookFrame\\codex_01Left.blp")
        codexRight:SetTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\bookFrame\\codex_01Right.blp")
        infoText:Hide(); codexPortraitBorder:Hide(); codexPortrait:Hide()
        settingsBtn:SetPoint("LEFT", codexBook, "TOPLEFT", 636, -350)
        hideBtn:SetPoint("LEFT", codexBook, "TOPLEFT", 636, -395)
        codexLabel:SetPoint("LEFT", codexBook, "TOPLEFT", 636, -70)
        if perm == 3 then chapBtn1:Show(); chapBtn2:Show(); chapBtn3:Show(); 
        else chapBtn1:Show(); chapBtn2:Show(); chapBtn3:Show(); chapBtn4:Show() end
        
      else 
        BtnDescText:SetPoint("TOPLEFT", codexLeft, "TOPLEFT", 50, -405) 
        codexTextLeft:Hide(); codexTextRight:Show();
        codexLeft:SetTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\bookFrame\\codex_00Left.blp")
        codexRight:SetTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\bookFrame\\codex_00Right.blp")
        infoText:Show(); chapBtn1:Hide(); chapBtn2:Hide(); chapBtn3:Hide(); chapBtn4:Hide() 
        settingsBtn:SetPoint("LEFT", codexBook, "TOPLEFT", 631, -350)
        hideBtn:SetPoint("LEFT", codexBook, "TOPLEFT", 631, -395)
        codexLabel:SetPoint("LEFT", codexBook, "TOPLEFT", 631, -70)
        codexPortraitBorder:Show(); codexPortrait:Show()
      end
      cLshow = not cLshow
    end)

    codexLabel:SetScript("OnEnter", function()
      BtnDescText:SetText("Кодекс Лиги убийц")
    end)

    codexLabel:SetScript("OnLeave", function()
      BtnDescText:SetText("")
    end)
    --



--[[]]
    page_n = 1
    page_l = #chapter[chap]

    --if LoMDB.debug then print('|cFFCC0000Debug:|r Chapter lenght: ' .. tostring(page_l)) end

    

    ------------
    local codexCornerRight = CreateFrame("button", "btnFrame", codexBook)
    codexCornerRight:SetPoint("TOPRIGHT", -78, -30)
    codexCornerRight:SetWidth(28)
    codexCornerRight:SetHeight(28)
    codexCornerRight:SetNormalTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\codexCornerRightSH.blp")
    codexCornerRight:SetPushedTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\codexCornerRight.blp")
    codexCornerRight:SetHighlightTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\codexCornerRightHL.blp")
    codexCornerRight:Hide()
------------
    local codexCornerLeft = CreateFrame("button", "btnFrame", codexBook)
    codexCornerLeft:SetPoint("TOPLEFT", 37, -30)
    codexCornerLeft:SetWidth(28)
    codexCornerLeft:SetHeight(28)
    codexCornerLeft:SetNormalTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\codexCornerLeftSH.blp")
    codexCornerLeft:SetPushedTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\codexCornerLeft.blp")
    codexCornerLeft:SetHighlightTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\codexCornerLeftHL.blp")
    codexCornerLeft:Hide()

    BtnDescText = codexBook:CreateFontString("BtnDescText", "ARTWORK", 1)
    BtnDescText:SetFont("Fonts\\MORPHEUS.ttf", 16)
    BtnDescText:SetJustifyH("LEFT")
    BtnDescText:SetJustifyV("TOP")
    BtnDescText:SetPoint("TOPLEFT", codexLeft, "TOPLEFT", 50, -405)
    BtnDescText:SetTextColor(0.2,0.15,0.10)
    BtnDescText:SetWordWrap(true)
------------
    codexTextLeft = codexBook:CreateFontString("tstPageText", "ARTWORK", 1)
    codexTextLeft:SetFont("Fonts\\MORPHEUS.ttf", 14)
    codexTextLeft:SetJustifyH("LEFT")
    codexTextLeft:SetJustifyV("TOP")
    codexTextLeft:SetPoint("TOPLEFT", codexLeft, "TOPLEFT", 78, -45)
    codexTextLeft:SetTextColor(0.2,0.15,0.10)
    codexTextLeft:SetWordWrap(true)
------------
    codexTextRight = codexBook:CreateFontString("tstPageText", "ARTWORK", 1)
    codexTextRight:SetFont("Fonts\\MORPHEUS.ttf", 14)
    codexTextRight:SetJustifyH("LEFT")
    codexTextRight:SetJustifyV("TOP")
    codexTextRight:SetPoint("TOPLEFT", codexLeft, "TOPLEFT", 362, -45)
    codexTextRight:SetTextColor(0.2,0.15,0.10)
    codexTextRight:SetWordWrap(true)
-------------------------SCRIPT_PART------------------------------------------
    codexCornerRight:SetScript("OnClick", function()
      page_n = page_n+1 
      if page_n>page_l-1 then codexCornerRight:Disable() else codexCornerRight:Enable() end
      if page_n<2 then codexCornerLeft:Disable() else codexCornerLeft:Enable() end
      codexTextLeft:SetText(chapter[chap][page_n])
      codexTextRight:SetText(chapter[chap][page_n+1])
      PlaySound("igMainMenuOption") 
      if debug then print('|cFFCC0000Debug:|r ' .. tostring(page_n)) end
    end)

    codexCornerLeft:SetScript("OnClick", function() --
      page_n = page_n-1 
      if page_n<2 then codexCornerLeft:Disable() else codexCornerLeft:Enable() end
      if page_n>page_l-1 then codexCornerRight:Disable() else codexCornerRight:Enable() end
      codexTextLeft:SetText(chapter[chap][page_n])
      if page_n == 1 then codexTextRight:SetText(chapter[chap][page_n+1])
      else codexTextRight:SetText(chapter[chap][page_n-1]) end
      PlaySound("igMainMenuOption") 
      if debug then print('|cFFCC0000Debug:|r ' .. tostring(page_n)) end
    end)

    if page_n>page_l-1 then codexCornerRight:Disable() else codexCornerRight:Enable() end

    if page_n<2 then codexCornerLeft:Disable() else codexCornerLeft:Enable() end

    --page_number:SetText(pageNtext)--every time
    --bookframe:SetPoint("TOPLEFT",225,-100)--every time
    --header_text:SetText(button_text) -- every time
    codexTextLeft:SetText(chapter[chap][1])
    codexTextRight:SetText(chapter[chap][2])
  end

  return codexFrame

end
