//--------------------------------------------------------------------
// modifyorderprice.mq4 
// Предназначен для использования в качестве примера в учебнике MQL4.
//--------------------------------------------------------------- 1 --
int start()                                     // Спец.функция start
  {
   int Tral=10;                                 // Дист. приближения
   string Symb=Symbol();                        // Финанс. инструмент
   double Dist=1000000.0;                       // Предустановка
   double Win_Price=WindowPriceOnDropped();     // Здесь брошен скрипт
//--------------------------------------------------------------- 2 --
   for(int i=1; i<=OrdersTotal(); i++)          // Цикл перебора ордер
     {
      if (OrderSelect(i-1,SELECT_BY_POS)==true) // Если есть следующий
        {                                       // Анализ ордеров:
         //------------------------------------------------------ 3 --
         if (OrderSymbol()!= Symb) continue;    // Не наш фин.инструм.
         if (OrderType()<2) continue;           // Рыночный ордер  
         //------------------------------------------------------ 4 --
         if(NormalizeDouble(MathAbs(OrderOpenPrice()-Win_Price),Digits)
            < NormalizeDouble(Dist,Digits))     // Выбираем ближайший
           {
            Dist=MathAbs(OrderOpenPrice()-Win_Price);// Новое значение
            int    Tip   =OrderType();          // Тип выбранного орд.
            int    Ticket=OrderTicket();        // Номер выбранн. орд.
            double Price =OrderOpenPrice();     // Цена выбранн. орд.
            double SL    =OrderStopLoss();      // SL выбранного орд.
            double TP    =OrderTakeProfit();    // TP выбранного орд.
           }                                    // Конец if
        }                                       // Конец анализа ордера
     }                                          // Конец перебора орд.
//--------------------------------------------------------------- 5 --
   if (Tip==0)                                  // Если отложенных нет
     {
      Alert("По ",Symb," отложенных ордеров нет");
      return;                                   // Выход из программы
     }
//--------------------------------------------------------------- 6 --
   while(true)                                  // Цикл закрытия орд.
     {
      RefreshRates();                           // Обновим данные
      //--------------------------------------------------------- 7 --
      double TS=Tral;                           // Исходное значение
      int Min_Dist=MarketInfo(Symb,MODE_STOPLEVEL);//Миним. дистанция
      if (TS<Min_Dist)                          // Если меньше допуст.
         TS=Min_Dist;                           // Новое значение TS
      //--------------------------------------------------------- 8 --
      string Text="";                           // Не назначен к модифи
      double New_SL=0;
      double New_TP=0;
      switch(Tip)                               // По типу ордера
        {
         case 2:                                // BuyLimit
            if (NormalizeDouble(Price,Digits) < // Если дальше, чем на
                NormalizeDouble(Ask-TS*Point,Digits))//..заданное знач
              {
               double New_Price=Ask-TS*Point;   // Новая его цена
               if (NormalizeDouble(SL,Digits)>0)
                  New_SL=New_Price-(Price-SL);  // Новый StopLoss
               if (NormalizeDouble(TP,Digits)>0)
                  New_TP=New_Price+(TP-Price);  // Новый TakeProfit
               Text= "BuyLimit ";               // Будем его модифи.
              }
            break;                              // Выход из switch
         case 3:                                // SellLimit 
            if (NormalizeDouble(Price,Digits) > // Если дальше, чем на
                NormalizeDouble(Bid+TS*Point,Digits))//..заданное знач
              {
               New_Price=Bid+TS*Point;          // Новая его цена
               if (NormalizeDouble(SL,Digits)>0)
                  New_SL=New_Price+(SL-Price);  // Новый StopLoss
               if (NormalizeDouble(TP,Digits)>0)
                  New_TP=New_Price-(Price-TP);  // Новый TakeProfit
               Text= "SellLimit ";              // Будем его модифи.
              }
            break;                              // Выход из switch
         case 4:                                // BuyStopt
            if (NormalizeDouble(Price,Digits) > // Если дальше, чем на
                NormalizeDouble(Ask+TS*Point,Digits))//..заданное знач
              {
               New_Price=Ask+TS*Point;          // Новая его цена
               if (NormalizeDouble(SL,Digits)>0)
                  New_SL=New_Price-(Price-SL);  // Новый StopLoss
               if (NormalizeDouble(TP,Digits)>0)
                  New_TP=New_Price+(TP-Price);  // Новый TakeProfit
               Text= "BuyStopt ";               // Будем его модифи.
              }
            break;                              // Выход из switch
         case 5:                                // SellStop
            if (NormalizeDouble(Price,Digits) < // Если дальше, чем на
                NormalizeDouble(Bid-TS*Point,Digits))//..заданное знач
              {
               New_Price=Bid-TS*Point;          // Новая его цена
               if (NormalizeDouble(SL,Digits)>0)
                  New_SL=New_Price+(SL-Price);  // Новый StopLoss
               if (NormalizeDouble(TP,Digits)>0)
                  New_TP=New_Price-(Price-TP);  // Новый TakeProfit
               Text= "SellStop ";               // Будем его модифи.
              }
        }
      if (NormalizeDouble(New_SL,Digits)<0)     // Проверка SL
         New_SL=0;
      if (NormalizeDouble(New_TP,Digits)<0)     // Проверка TP
         New_TP=0;
      //--------------------------------------------------------- 9 --
      if (Text=="")                             // Если его не модифи
        {
         Alert("Нет условий для модификации.");
         break;                                 // Выход из while
        }
      //-------------------------------------------------------- 10 --
      Alert ("Модификация ",Text,Ticket,". Ждём ответ..");
      bool Ans=OrderModify(Ticket,New_Price,New_SL,New_TP,0);//Модифи!
      //-------------------------------------------------------- 11 --
      if (Ans==true)                            // Получилось :)
        {
         Alert ("Модифицирован ордер ",Text," ",Ticket," :)");
         break;                                 // Выход из цикла закр
        }
      //-------------------------------------------------------- 12 --
      int Error=GetLastError();                 // Не получилось :(
      switch(Error)                             // Преодолимые ошибки
        {
         case  4: Alert("Торговый сервер занят. Пробуем ещё раз..");
            Sleep(3000);                        // Простое решение
            continue;                           // На след. итерацию
         case 137:Alert("Брокер занят. Пробуем ещё раз..");
            Sleep(3000);                        // Простое решение
            continue;                           // На след. итерацию
         case 146:Alert("Подсистема торговли занята. Пробуем ещё..");
            Sleep(500);                         // Простое решение
            continue;                           // На след. итерацию
        }
      switch(Error)                             // Критические ошибки
        {
         case 2 : Alert("Общая ошибка.");
            break;                              // Выход из switch
         case 64: Alert("Счет заблокирован.");
            break;                              // Выход из switch
         case 133:Alert("Торговля запрещена");
            break;                              // Выход из switch
         case 139:Alert("Ордер заблокирован и уже обрабатывается");
            break;                              // Выход из switch
         case 145:Alert("Модификация запрещена. ",
                              "Ордер слишком близок к рынку");
            break;                              // Выход из switch
         default: Alert("Возникла ошибка ",Error);//Другие варианты   
        }
      break;                                    // Выход из цикла закр
     }                                          // Конец цикла закр.   
//-------------------------------------------------------------- 13 --
   Alert ("Скрипт закончил работу -----------------------");
   return;                                      // Выход из start()
  }
//-------------------------------------------------------------- 14 --