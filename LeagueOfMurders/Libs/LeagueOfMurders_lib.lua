x = 468; a = 1; ch = 0;
--
------Иконка у мини карты
function createMinimapButton ()

  MinimapPos = 340;

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

  button:SetPoint("TOPLEFT","Minimap","TOPLEFT",52-(77*cos(MinimapPos)),(77*sin(MinimapPos))-52)

  button:SetScript("OnDragStart", function()

    local xpos,ypos = GetCursorPosition()
    local xmin,ymin = Minimap:GetLeft(), Minimap:GetBottom()
  
    xpos = xmin-xpos/UIParent:GetScale()+70 
    ypos = ypos/UIParent:GetScale()-ymin-70
  
    MinimapPos = math.deg(math.atan2(ypos,xpos))
    button:SetPoint("TOPLEFT","Minimap","TOPLEFT",52-(80*cos(MinimapPos)),(80*sin(MinimapPos))-52)
  
  end);

  button:Show();  
  
  return button;

end;
--
------Хелпер для скроллинга
function scrollingLimits(maxValue)

  if (a < 1) then 
    a = 1
  elseif (a > maxValue) then
    a = maxValue
  end

end;
--
------Хелпер для создания кнопок
function btn_constr(Parent, posX, posY, btnL, btnH, hide)

  local Frame = CreateFrame("Button", nil, Parent)
  Frame:SetPoint("LEFT", Parent, "TOPLEFT", posX, posY)
  Frame:SetSize(btnL, btnH)

  if hide then 
    Frame:Hide()
    else
    Frame:Show()
  end 

  return Frame

end
--
------Создание фрейма книги
function createCodexFrame()
  
  if codexFrame then 

    if LoMDB.debug then print('|cFFCC0000Debug:|r Frame exists') end

  else
  
    codexFrame = CreateFrame("Frame", "codexFrame", UIParent);
    codexFrame:EnableMouse(1); codexFrame:SetMovable(1)
    codexFrame:RegisterForDrag("LeftButton");
    codexFrame:SetWidth(x); codexFrame:SetHeight(x)
    codexFrame:SetPoint("TOPLEFT");
    codexFrame:Hide();

    tinsert(UISpecialFrames, codexFrame:GetName());

    codexFrame:SetScript("OnDragStart", function(self) 
      self:StartMoving() 
    end);

    codexFrame:SetScript("OnDragStop", function(self) 
      self:StopMovingOrSizing() 
    end);
--
------Создание Обложки
    codexCover = CreateFrame("Frame", "codexCover", codexFrame)
    codexCover:SetPoint("TOPLEFT")
    codexCover:SetWidth(x); codexCover:SetHeight(x)

    local coverTexture = codexCover:CreateTexture(nil, "BACKGROUND")
    coverTexture:SetPoint("TOPLEFT")
    coverTexture:SetWidth(x); coverTexture:SetHeight(x)
    coverTexture:SetTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\codexCover.blp")

    local coverButton = CreateFrame("Button", "coverBtn", codexCover)
    coverButton:SetPoint("CENTER", -17, 36)
    coverButton:SetWidth(256); coverButton:SetHeight(256)
    coverButton:SetNormalTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\coverBtn.blp")
    
    coverButton:SetScript("OnClick", function()
      if (perm == 0) or (perm == 2) then 
      else
        codexCover:Hide(); 
        codexFrame:EnableMouse(0); 
        codexBook:Show() 
      end
    end);
--
------Создание Книги
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
    
    local codexLeft = codexBook:CreateTexture("cLeft", "BACKGROUND")
    codexLeft:SetPoint("TOPLEFT")
    codexLeft:SetWidth(x)
    codexLeft:SetHeight(x)
    codexLeft:SetTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\bookFrame\\codex_Left.blp")

    local codexRight = codexBook:CreateTexture("cRight", "BACKGROUND")
    codexRight:SetPoint("TOPLEFT", x, 0)
    codexRight:SetWidth(x/2)
    codexRight:SetHeight(x)
    codexRight:SetTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\bookFrame\\codex_Right.blp")
--
------Информация о персонаже
    infoText = codexBook:CreateFontString("infoText", "ARTWORK", 1);
    infoText:SetFont("Fonts\\MORPHEUS.ttf", 16);
    infoText:SetJustifyH("LEFT");
    infoText:SetJustifyV("TOP");
    infoText:SetPoint("TOPLEFT", codexLeft, "TOPLEFT", 76, -158);
    infoText:SetTextColor(0,0,0);
    infoText:SetWordWrap(1);
--
------Портрет
    codexPortrait = codexBook:CreateTexture(nil, "ARTWORK", codexLeft, 1)
    codexPortrait:SetHeight(80); codexPortrait:SetWidth(80)
    codexPortrait:SetPoint("TOPLEFT", codexLeft, "TOPLEFT", 130, -60)
--
    codexPortraitBorder = codexBook:CreateTexture(nil, "ARTWORK", codexLeft, 2)
    codexPortraitBorder:SetHeight(125); codexPortraitBorder:SetWidth(125)
    codexPortraitBorder:SetPoint("TOPLEFT", codexPortrait, "TOPLEFT", -23, 16)
    codexPortraitBorder:SetTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\portraitBorder.blp")
--
------scrollFrame 
    local pScrollFrame = CreateFrame("Frame", "pScrollFrame", codexBook) 
    pScrollFrame:SetSize(267, 375) 
    pScrollFrame:SetPoint("TOPRIGHT", -75, -48)
--
    scrollFrame = CreateFrame("scrollFrame", nil, pScrollFrame) 
    scrollFrame:SetAllPoints() 
    scrollFrame:EnableMouseWheel(1)
------Слайдер 
    scrollbar = CreateFrame("Slider", nil, scrollFrame, "UIPanelScrollBarTemplate") 
    scrollbar:SetPoint("TOPLEFT", pScrollFrame, "TOPRIGHT", 4, -16) 
    scrollbar:SetPoint("BOTTOMLEFT", pScrollFrame, "BOTTOMRIGHT", 4, 16) 
    scrollbar:SetMinMaxValues(1, 100) 
    scrollbar:SetWidth(13) 

    local scrollbg = scrollbar:CreateTexture(nil, "BACKGROUND") 
    scrollbg:SetAllPoints(scrollbar) 
    scrollbg:SetTexture(0, 0, 0, 0.2) 
    pScrollFrame.scrollbar = scrollbar 
------Содержимое scrollFrame
    local content = CreateFrame("Frame", nil, scrollFrame) 
    content:SetSize(128, 128) 

    scrollText = content:CreateFontString("infoText", "ARTWORK", 1);
    scrollText:SetFont("Fonts\\MORPHEUS.ttf", 14);
    scrollText:SetJustifyH("LEFT");
    scrollText:SetJustifyV("TOP");
    scrollText:SetPoint("TOPLEFT");
    scrollText:SetTextColor(0,0,0);
    scrollText:SetWordWrap(1);
    scrollText:SetText(bookText.otherText.info);

    scrollFrame.content = content 
    scrollFrame:SetScrollChild(content)
--
------Кнопка "Кодекс"
    local codexBtn = btn_constr(codexBook, 85, -285, 120, 60, false);
    codexBtn:SetNormalTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\buttons\\codexBtn.blp");
    codexBtn:SetHighlightTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\buttons\\btnHL.blp");

    codexBtn:SetScript("OnEnter", function()
      BtnDescText:SetText("Кодекс Лиги убийц");
    end)

    codexBtn:SetScript("OnLeave", function()
      BtnDescText:SetText("");
    end)
--
------Кнопка "Правила"
    local rulesBtn = btn_constr(codexBook, 200, -285, 120, 60, false);
    rulesBtn:SetNormalTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\buttons\\rulesBtn.blp");
    rulesBtn:SetHighlightTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\buttons\\btnHL.blp");

    rulesBtn:SetScript("OnEnter", function()
      BtnDescText:SetText("Правила гильдии (В разработке)");
    end)

    rulesBtn:SetScript("OnLeave", function()
      BtnDescText:SetText("");
    end)
--
------Кнопка "Снабжение"
    local spBtn = btn_constr(codexBook, 85, -350, 120, 60, false);
    spBtn:SetNormalTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\buttons\\spBtn.blp");
    spBtn:SetHighlightTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\buttons\\btnHL.blp");

    spBtn:SetScript("OnEnter", function()
      BtnDescText:SetText("Очки снабжения (В разработке)");
    end)

    spBtn:SetScript("OnLeave", function()
      BtnDescText:SetText("");
    end)
--
------Кнопка "Уважение"
    local rpBtn = btn_constr(codexBook, 200, -350, 120, 60, false);
    rpBtn:SetNormalTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\buttons\\rpBtn.blp");
    rpBtn:SetHighlightTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\buttons\\btnHL.blp");

    rpBtn:SetScript("OnEnter", function()
      BtnDescText:SetText("Очки уважения (В разработке)");
    end)

    rpBtn:SetScript("OnLeave", function()
      BtnDescText:SetText("");
    end)
--
------Кнопка "Назад"
    local backBtn = btn_constr(codexBook, 95, -270, 105, 52, true);
    backBtn:SetNormalTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\buttons\\backBtn.blp");
    backBtn:SetHighlightTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\buttons\\btnHL.blp");

    backBtn:SetScript("OnEnter", function()
      BtnDescText:SetText("Назад");
    end)

    backBtn:SetScript("OnLeave", function()
      BtnDescText:SetText("");
    end)
--
------Кнопка "Глава 1"
    local chapBtn1 = btn_constr(codexBook, 200, -270, 105, 52, true);
    chapBtn1:SetNormalTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\buttons\\chapBtn1.blp");
    chapBtn1:SetHighlightTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\buttons\\btnHL.blp");
    
    chapBtn1:SetScript("OnEnter", function()
      BtnDescText:SetText("Глава 1");
    end)

    chapBtn1:SetScript("OnLeave", function()
      BtnDescText:SetText("");
    end)
--
------Кнопка "Глава 2"
    local chapBtn2 = btn_constr(codexBook, 95, -320, 105, 52, true);
    chapBtn2:SetNormalTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\buttons\\chapBtn2.blp");
    chapBtn2:SetHighlightTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\buttons\\btnHL.blp");
    
    chapBtn2:SetScript("OnEnter", function()
      BtnDescText:SetText("Глава 2");
    end)

    chapBtn2:SetScript("OnLeave", function()
      BtnDescText:SetText("");
    end)
--
------Кнопка "Глава 3"
    local chapBtn3 = btn_constr(codexBook, 200, -320, 105, 52, true);
    chapBtn3:SetNormalTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\buttons\\chapBtn3.blp");
    chapBtn3:SetHighlightTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\buttons\\btnHL.blp");

    chapBtn3:SetScript("OnEnter", function()
      BtnDescText:SetText("Глава 3");
    end)

    chapBtn3:SetScript("OnLeave", function()
      BtnDescText:SetText("");
    end)
--
------Кнопка "Глава 4"
    local chapBtn4 = btn_constr(codexBook, 95, -370, 105, 52, true);
    chapBtn4:SetNormalTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\buttons\\chapBtn4.blp");
    chapBtn4:SetHighlightTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\buttons\\btnHL.blp");
    
    chapBtn4:SetScript("OnEnter", function()
      BtnDescText:SetText("Глава 4 (В разработке)");
    end)

    chapBtn4:SetScript("OnLeave", function()
      BtnDescText:SetText("");
    end)
--
------Кнопка "Выход"
    local hideBtn = btn_constr(codexBook, 270, -130, 40, 220, false);

    hideBtn:SetScript("OnEnter", function()
      BtnDescText:SetText("Положить книгу в рюкзак.");
    end)

    hideBtn:SetScript("OnLeave", function()
      BtnDescText:SetText("");
    end)
--
------Строка описания элементов
    BtnDescText = codexBook:CreateFontString("BtnDescText", "ARTWORK", 1)
    BtnDescText:SetFont("Fonts\\MORPHEUS.ttf", 16)
    BtnDescText:SetJustifyH("LEFT")
    BtnDescText:SetJustifyV("TOP")
    BtnDescText:SetPoint("TOPLEFT", codexLeft, "TOPLEFT", 80, -405)
    BtnDescText:SetTextColor(0,0,0)
    BtnDescText:SetWordWrap(true)
------
--
----------------------------------SCRIPT_PART-----------------------------------------
--
------Нажатие кнопки "Кодекс"
codexBtn:SetScript("OnClick", function()

  a = 1;
  scrollbar:SetValue(a);
  spBtn:Hide();
  rpBtn:Hide();
  rulesBtn:Hide();
  codexBtn:Hide();

  scrollText:SetText(bookText.otherText.intro);

  if perm == 3 then

    backBtn:Show();
    chapBtn1:Show(); 
    chapBtn2:Show(); 
    chapBtn3:Show(); 

  else 

    backBtn:Show();
    chapBtn1:Show(); 
    chapBtn2:Show(); 
    chapBtn3:Show(); 
    chapBtn4:Show();

  end

  PlaySound("igMainMenuOption")

end)
--
------Нажатие на кнопку "Назад"
backBtn:SetScript("OnClick", function() 

  a = 1; ch = 0;
  scrollbar:SetValue(0) 
  backBtn:Hide();
  chapBtn1:Hide(); 
  chapBtn2:Hide(); 
  chapBtn3:Hide(); 
  chapBtn4:Hide();

  spBtn:Show();
  rpBtn:Show();
  rulesBtn:Show();
  codexBtn:Show();

  scrollText:SetText(bookText.otherText.info);

  PlaySound("igMainMenuOption")

end)
--
------Нажатие на кнопку "Глава 1"
chapBtn1:SetScript("OnClick", function() 

  ch = 1; a = 1;
  scrollbar:SetValue(0) 
  scrollText:SetText(bookText.chapterOne[1]);
  scrollbar:SetMinMaxValues(1, #bookText.chapterOne) 

  PlaySound("igMainMenuOption")
  
end)
--
------Нажатие на кнопку "Глава 2"
chapBtn2:SetScript("OnClick", function()

  ch = 2; a = 1;
  scrollbar:SetValue(0) 
  scrollText:SetText(bookText.chapterTwo[1]);
  scrollbar:SetMinMaxValues(1, #bookText.chapterTwo) 

  PlaySound("igMainMenuOption")
  
end)
--
------Нажатие на кнопку "Глава 3"
chapBtn3:SetScript("OnClick", function()

  ch = 3; a = 1;
  scrollbar:SetValue(0) 
  scrollText:SetText(bookText.chapterThree[1]);
  scrollbar:SetMinMaxValues(1, #bookText.chapterThree) 

  PlaySound("igMainMenuOption")
  
end)
--
------Нажатие на кнопку "Глава 4"
chapBtn4:SetScript("OnClick", function()

  -- ch = 4; a = 1;
  -- scrollbar:SetValue(0) 
  -- scrollText:SetText(bookText.chapterFour[1]);
  -- scrollbar:SetMinMaxValues(1, #bookText.chapterFour) 

  -- PlaySound("igMainMenuOption")
  
end)
--
------Нажатие на кнопку "Закрыть"   
hideBtn:SetScript("OnClick", function()
  codexFrame:Hide();
end)
--
------Скроллинг  
  scrollFrame:SetScript("OnMouseWheel", function(self, delta)

  --Режим чтения текста
  if ch > 0 then 

    if delta < 0 then 
      a = a + 1;
    else 
      a = a - 1;
    end

    if ch == 1 then 
      scrollingLimits(#bookText.chapterOne);
      scrollText:SetText(bookText.chapterOne[a]);
    elseif ch == 2 then 
      scrollingLimits(#bookText.chapterTwo);
      scrollText:SetText(bookText.chapterTwo[a]);
    elseif ch == 3 then 
      scrollingLimits(#bookText.chapterThree);
      scrollText:SetText(bookText.chapterThree[a]);
    elseif ch == 4 then 
      scrollingLimits(#bookText.chapterFour);
      scrollText:SetText(bookText.chapterFour[a]);
    end

    scrollbar:SetValue(0);

  else --Режим просмотра информации

    if delta < 0 then 
      a = a + 8;
    else 
      a = a - 8;
    end
  
    scrollbar:SetMinMaxValues(1, 100);
    scrollingLimits(100);
  
    scrollbar:SetValue(a);

  end
  end)

  end

  return codexFrame

end

