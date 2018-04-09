x = 468;
codexLabelShow = true;
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
  
    xpos = xmin-xpos/UIParent:GetScale()+70 -- get coordinates as differences from the center of the minimap
    ypos = ypos/UIParent:GetScale()-ymin-70
  
    MinimapPos = math.deg(math.atan2(ypos,xpos)) -- save the degrees we are relative to the minimap center
    button:SetPoint("TOPLEFT","Minimap","TOPLEFT",52-(80*cos(MinimapPos)),(80*sin(MinimapPos))-52)
  
  end);

  button:Show();  
  
  return button;

end;
--
------Хелпер для создания кнопок
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
    coverButton:SetPoint("CENTER", 18, -11)
    coverButton:SetWidth(200); coverButton:SetHeight(200)
    --coverButton:SetNormalTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\tempCoverBtn.blp")
    
    coverButton:SetScript("OnClick", function()
      if (perm == 0) or (perm == 2) then 
      else
        codexCover:Hide(); 
        codexFrame:EnableMouse(0); 
        codexBook:Show() 
        codexTextRight:Show(); 
        codexTextRight:SetText(bookText.otherText.info);
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
    codexLeft:SetTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\bookFrame\\codex_00Left.blp")

    local codexRight = codexBook:CreateTexture("cRight", "BACKGROUND")
    codexRight:SetPoint("TOPLEFT", x, 0)
    codexRight:SetWidth(x/2)
    codexRight:SetHeight(x)
    codexRight:SetTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\bookFrame\\codex_00Right.blp")
--
------Информация о персонаже
    infoText = codexBook:CreateFontString("infoText", "ARTWORK", 1);
    infoText:SetFont("Fonts\\MORPHEUS.ttf", 16);
    infoText:SetJustifyH("LEFT");
    infoText:SetJustifyV("TOP");
    infoText:SetPoint("TOPLEFT", codexLeft, "TOPLEFT", 58, -50);
    infoText:SetTextColor(0.1,0.05,0.05);
    infoText:SetWordWrap(1);
--
------Портрет
    codexPortrait = codexBook:CreateTexture(nil, "ARTWORK", codexLeft, 1)
    codexPortrait:SetHeight(87); codexPortrait:SetWidth(87)
    codexPortrait:SetPoint("TOPLEFT", codexLeft, "TOPLEFT", 58, -50)

    codexPortraitBorder = codexBook:CreateTexture(nil, "ARTWORK", codexLeft, 2)
    codexPortraitBorder:SetHeight(110); codexPortraitBorder:SetWidth(110)
    codexPortraitBorder:SetPoint("TOPLEFT", codexLeft, "TOPLEFT", 45, -40)
    codexPortraitBorder:SetTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\portraitBorder.blp")
--
------Кнопка "Глава 1"
    local chapBtn1 = btn_constr(codexBook, 385, -75, 120, 60, true);
    chapBtn1:SetNormalTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\chapBtns\\chapBtn1.blp");
    chapBtn1:SetHighlightTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\chapBtns\\chapBtnHL.blp");
    
    chapBtn1:SetScript("OnEnter", function()
      BtnDescText:SetText("Глава 1");
    end)

    chapBtn1:SetScript("OnLeave", function()
      BtnDescText:SetText("");
    end)
--
------Кнопка "Глава 2"
    local chapBtn2 = btn_constr(codexBook, 485, -75, 120, 60, true);
    chapBtn2:SetNormalTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\chapBtns\\chapBtn2.blp");
    chapBtn2:SetHighlightTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\chapBtns\\chapBtnHL.blp");
    
    chapBtn2:SetScript("OnEnter", function()
      BtnDescText:SetText("Глава 2");
    end)

    chapBtn2:SetScript("OnLeave", function()
      BtnDescText:SetText("");
    end)
--
------Кнопка "Глава 3"
    local chapBtn3 = btn_constr(codexBook, 385, -130, 120, 60, true);
    chapBtn3:SetNormalTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\chapBtns\\chapBtn3.blp");
    chapBtn3:SetHighlightTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\chapBtns\\chapBtnHL.blp");

    chapBtn3:SetScript("OnEnter", function()
      BtnDescText:SetText("Глава 3");
    end)

    chapBtn3:SetScript("OnLeave", function()
      BtnDescText:SetText("");
    end)
--
------Кнопка "Глава 4"
    local chapBtn4 = btn_constr(codexBook, 485, -130, 120, 60, true);
    chapBtn4:SetNormalTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\chapBtns\\chapBtn4.blp");
    chapBtn4:SetHighlightTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\chapBtns\\chapBtnHL.blp");
    
    chapBtn4:SetScript("OnEnter", function()
      BtnDescText:SetText("Глава 4");
    end)

    chapBtn4:SetScript("OnLeave", function()
      BtnDescText:SetText("");
    end)
--
------Кнопка "Кодекс"
local codexLabel = btn_constr(codexBook, 631, -70, 45, 45, false);
codexLabel:SetNormalTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\codexLabelTexts.blp");
codexLabel:SetPushedTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\codexLabelTexts.blp");
codexLabel:SetHighlightTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\codexLabelTexts.blp");

codexLabel:SetScript("OnEnter", function()
  BtnDescText:SetText("Кодекс Лиги убийц");
end)

codexLabel:SetScript("OnLeave", function()
  BtnDescText:SetText("");
end)
--
------Кнопка "Настройки"
    local settingsBtn = btn_constr(codexBook, 631, -350, 45, 45, false);
    settingsBtn:SetNormalTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\codexLabelSettings.blp");
    settingsBtn:SetPushedTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\codexLabelSettings.blp");
    settingsBtn:SetHighlightTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\codexLabelSettings.blp");

    settingsBtn:SetScript("OnEnter", function()
      BtnDescText:SetText("Настройки");
    end)

    settingsBtn:SetScript("OnLeave", function()
      BtnDescText:SetText("");
    end)
--
------Кнопка "Выход"
    local hideBtn = btn_constr(codexBook, 631, -395, 45, 45, false);
    hideBtn:SetNormalTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\codexLabelClose.blp");
    hideBtn:SetPushedTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\codexLabelClose.blp");
    hideBtn:SetHighlightTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\codexLabelClose.blp");

    hideBtn:SetScript("OnEnter", function()
      BtnDescText:SetText("Положить книгу в рюкзак.");
    end)

    hideBtn:SetScript("OnLeave", function()
      BtnDescText:SetText("");
    end)
--
------------
    local codexCornerRight = CreateFrame("button", "btnFrame", codexBook)
    codexCornerRight:SetPoint("TOPRIGHT", -74, -30)
    codexCornerRight:SetWidth(28)
    codexCornerRight:SetHeight(28)
    codexCornerRight:SetNormalTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\codexCornerRightSH.blp")
    codexCornerRight:SetPushedTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\codexCornerRight.blp")
    codexCornerRight:SetHighlightTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\codexCornerRightHL.blp")
    codexCornerRight:Hide()
------------
    local codexCornerLeft = CreateFrame("button", "btnFrame", codexBook)
    codexCornerLeft:SetPoint("TOPLEFT", 68, -30)
    codexCornerLeft:SetWidth(28)
    codexCornerLeft:SetHeight(28)
    codexCornerLeft:SetNormalTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\codexCornerLeftSH.blp")
    codexCornerLeft:SetPushedTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\codexCornerLeft.blp")
    codexCornerLeft:SetHighlightTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\codexCornerLeftHL.blp")
    codexCornerLeft:Hide()
------------
    BtnDescText = codexBook:CreateFontString("BtnDescText", "ARTWORK", 1)
    BtnDescText:SetFont("Fonts\\MORPHEUS.ttf", 16)
    BtnDescText:SetJustifyH("LEFT")
    BtnDescText:SetJustifyV("TOP")
    BtnDescText:SetPoint("TOPLEFT", codexLeft, "TOPLEFT", 50, -405)
    BtnDescText:SetTextColor(0.1,0.05,0.05)
    BtnDescText:SetWordWrap(true)
------------
    codexTextLeft = codexBook:CreateFontString("tstPageText", "ARTWORK", 1)
    codexTextLeft:SetFont("Fonts\\MORPHEUS.ttf", 14)
    codexTextLeft:SetJustifyH("LEFT")
    codexTextLeft:SetJustifyV("TOP")
    codexTextLeft:SetPoint("TOPLEFT", codexLeft, "TOPLEFT", 76, -45)
    codexTextLeft:SetTextColor(0.1,0.05,0.05)
    codexTextLeft:SetWordWrap(true)
------------
    codexTextRight = codexBook:CreateFontString("tstPageText", "ARTWORK", 1)
    codexTextRight:SetFont("Fonts\\MORPHEUS.ttf", 14)
    codexTextRight:SetJustifyH("LEFT")
    codexTextRight:SetJustifyV("TOP")
    codexTextRight:SetPoint("TOPLEFT", codexLeft, "TOPLEFT", 362, -45)
    codexTextRight:SetTextColor(0.1,0.05,0.05)
    codexTextRight:SetWordWrap(true)
--
----------------------------------SCRIPT_PART-----------------------------------------
--
------Переключатель состояния кнопки "Кодекс"
codexLabel:SetScript("OnClick", function()

  if codexLabelShow then

    codexLeft:SetTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\bookFrame\\codex_01Left.blp");
    codexRight:SetTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\bookFrame\\codex_01Right.blp");
    BtnDescText:SetPoint("TOPLEFT", codexLeft, "TOPLEFT", 80, -405);
    BtnDescText:Show();
    codexTextRight:Hide();
    codexTextRight:SetPoint("TOPLEFT", codexLeft, "TOPLEFT", 362, -60)
    codexTextLeft:Show(); 
    codexTextLeft:SetText(bookText.otherText.intro);
    codexTextLeft:SetPoint("TOPLEFT", codexLeft, "TOPLEFT", 76, -45) 
    infoText:Hide(); 
    codexPortraitBorder:Hide(); 
    codexPortrait:Hide();
    settingsBtn:SetPoint("LEFT", codexBook, "TOPLEFT", 636, -350);
    hideBtn:SetPoint("LEFT", codexBook, "TOPLEFT", 636, -395);
    codexLabel:SetPoint("LEFT", codexBook, "TOPLEFT", 636, -70);

    if perm == 3 then 
      chapBtn1:Show(); 
      chapBtn2:Show(); 
      chapBtn3:Show(); 
    else 
      chapBtn1:Show(); 
      chapBtn2:Show(); 
      chapBtn3:Show(); 
      chapBtn4:Show();
    end
    
  else 

    BtnDescText:SetPoint("TOPLEFT", codexLeft, "TOPLEFT", 50, -405); 
    codexTextLeft:Hide(); 
    codexTextRight:Show();
    codexTextRight:SetText(bookText.otherText.info);
    codexTextRight:SetPoint("TOPLEFT", codexLeft, "TOPLEFT", 362, -45)
    codexLeft:SetTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\bookFrame\\codex_00Left.blp");
    codexRight:SetTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\bookFrame\\codex_00Right.blp");
    infoText:Show(); 
    chapBtn1:Hide(); 
    chapBtn2:Hide(); 
    chapBtn3:Hide(); 
    chapBtn4:Hide();
    settingsBtn:SetPoint("LEFT", codexBook, "TOPLEFT", 631, -350);
    hideBtn:SetPoint("LEFT", codexBook, "TOPLEFT", 631, -395);
    codexLabel:SetPoint("LEFT", codexBook, "TOPLEFT", 631, -70);
    codexPortraitBorder:Show(); 
    codexPortrait:Show();
    codexCornerLeft:Hide();
    codexCornerRight:Hide();

  end

  codexLabelShow = not codexLabelShow;

end)
--
------Нажатие на кнопку "Глава 1"
chapBtn1:SetScript("OnClick", function() 
  ch = 1;
  page_left = 0;
  page_right = 1;
  page_n = 0;
  page_l = #bookText.chapterOne;
  chapBtn1:Hide(); 
  chapBtn2:Hide(); 
  chapBtn3:Hide(); 
  chapBtn4:Hide(); 
  BtnDescText:Hide();
  codexCornerRight:Enable() 
  codexCornerRight:Show();
  codexTextLeft:SetPoint("TOPLEFT", codexLeft, "TOPLEFT", 76, -60);
  codexTextLeft:SetText(bookText.chapterOne[0]); 
  codexTextRight:SetText(bookText.chapterOne[1]);
  codexLeft:SetTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\bookFrame\\codex_02Left.blp");
  codexRight:SetTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\bookFrame\\codex_02Right.blp");
  codexTextRight:Show(); 
end)
--
------Нажатие на кнопку "Глава 2"
chapBtn2:SetScript("OnClick", function()
  ch = 2;
  page_left = 0;
  page_right = 1;
  page_n = 0;
  page_l = #bookText.chapterTwo;
  chapBtn1:Hide(); 
  chapBtn2:Hide(); 
  chapBtn3:Hide(); 
  chapBtn4:Hide(); 
  BtnDescText:Hide();
  codexCornerRight:Show();
  codexTextLeft:SetPoint("TOPLEFT", codexLeft, "TOPLEFT", 76, -60);
  codexTextLeft:SetText(bookText.chapterTwo[0]); 
  codexTextRight:SetText(bookText.chapterTwo[1]);
  codexLeft:SetTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\bookFrame\\codex_03Left.blp");
  codexRight:SetTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\bookFrame\\codex_03Right.blp");
  codexTextRight:Show(); 
end)
--
------Нажатие на кнопку "Глава 3"
chapBtn3:SetScript("OnClick", function()
  ch = 3;
  page_left = 0;
  page_right = 1;
  page_n = 0;
  page_l = #bookText.chapterThree;
  chapBtn1:Hide();
  chapBtn2:Hide();
  chapBtn3:Hide();
  chapBtn4:Hide();
  BtnDescText:Hide();
  codexCornerRight:Show();
  codexTextLeft:SetPoint("TOPLEFT", codexLeft, "TOPLEFT", 76, -60);
  codexTextLeft:SetText(bookText.chapterThree[0]); 
  codexTextRight:SetText(bookText.chapterThree[1]);
  codexLeft:SetTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\bookFrame\\codex_04Left.blp");
  codexRight:SetTexture("Interface\\AddOns\\LeagueOfMurders\\Media\\bookFrame\\codex_04Right.blp");
  codexTextRight:Show(); 
end)
--
------Нажатие на кнопку "Глава 4"
chapBtn4:SetScript("OnClick", function()
  --[[
  ch = 4;
  page_left = 0;
  page_right = 1;
  page_n = 0;
  page_l = #bookText.chapterFour;
  chapBtn1:Hide(); 
  chapBtn2:Hide(); 
  chapBtn3:Hide(); 
  chapBtn4:Hide(); 
  BtnDescText:Hide();
  codexCornerRight:Show();
  codexTextLeft:SetPoint("TOPLEFT", codexLeft, "TOPLEFT", 76, -60); 
  codexTextLeft:SetText(bookText.chapterFour[0]); 
  codexTextRight:SetText(bookText.chapterFour[1]);
  codexTextRight:Show(); 
  ]]
end)
--
------Нажатие на кнопку "Настройки"
settingsBtn:SetScript("OnClick", function()
  InterfaceOptionsFrame_OpenToCategory("League of Murders");
end)
--
------Нажатие на кнопку "Закрыть"   
hideBtn:SetScript("OnClick", function()
  codexFrame:Hide();
end)
--
------Нажатие на кнопку "Уголок_Право"  
codexCornerRight:SetScript("OnClick", function()

  page_n = page_n + 2;

  if page_n > 1 then
    codexCornerLeft:Show();
  else
    codexCornerLeft:Hide();
  end

  if page_n > page_l - 2 then 
    codexCornerRight:Hide(); 
  end

  if ch == 1 then 
    codexTextLeft:SetText(bookText.chapterOne[page_left+2]);
    codexTextRight:SetText(bookText.chapterOne[page_right+2]);
  elseif ch == 2 then 
    codexTextLeft:SetText(bookText.chapterTwo[page_left+2]);
    codexTextRight:SetText(bookText.chapterTwo[page_right+2]);
  elseif ch == 3 then 
    codexTextLeft:SetText(bookText.chapterThree[page_left+2]);
    codexTextRight:SetText(bookText.chapterThree[page_right+2]);
  elseif ch == 4 then 
    codexTextLeft:SetText(bookText.chapterFour[page_left+2]);
    codexTextRight:SetText(bookText.chapterFour[page_right+2]);
  end

  page_left=page_left+2; 
  page_right=page_right+2;  

  PlaySound("igMainMenuOption");

end)
--
------Нажатие на кнопку "Уголок_Лево"  
codexCornerLeft:SetScript("OnClick", function()

  page_n = page_n - 2;

  if page_n == 0 then codexCornerLeft:Hide(); end

  if page_n < page_l then
    codexCornerRight:Show();
  else
    codexCornerRight:Hide();
  end

  if ch == 1 then 
    codexTextLeft:SetText(bookText.chapterOne[page_left-2]);
    codexTextRight:SetText(bookText.chapterOne[page_right-2]);
  elseif ch == 2 then 
    codexTextLeft:SetText(bookText.chapterTwo[page_left-2]);
    codexTextRight:SetText(bookText.chapterTwo[page_right-2]);
  elseif ch == 3 then 
    codexTextLeft:SetText(bookText.chapterThree[page_left-2]);
    codexTextRight:SetText(bookText.chapterThree[page_right-2]);
  elseif ch == 4 then 
    codexTextLeft:SetText(bookText.chapterFour[page_left-2]);
    codexTextRight:SetText(bookText.chapterFour[page_right-2]);
  end

  page_left=page_left-2;
  page_right=page_right-2; 

  PlaySound("igMainMenuOption") 
  
  end)

  end

  return codexFrame

end

