//--------------------------------------------------------------------
// modifyorderprice.mq4 
// ������������ ��� ������������� � �������� ������� � �������� MQL4.
//--------------------------------------------------------------- 1 --
int start()                                     // ����.������� start
  {
   int Tral=10;                                 // ����. �����������
   string Symb=Symbol();                        // ������. ����������
   double Dist=1000000.0;                       // �������������
   double Win_Price=WindowPriceOnDropped();     // ����� ������ ������
//--------------------------------------------------------------- 2 --
   for(int i=1; i<=OrdersTotal(); i++)          // ���� �������� �����
     {
      if (OrderSelect(i-1,SELECT_BY_POS)==true) // ���� ���� ���������
        {                                       // ������ �������:
         //------------------------------------------------------ 3 --
         if (OrderSymbol()!= Symb) continue;    // �� ��� ���.�������.
         if (OrderType()<2) continue;           // �������� �����  
         //------------------------------------------------------ 4 --
         if(NormalizeDouble(MathAbs(OrderOpenPrice()-Win_Price),Digits)
            < NormalizeDouble(Dist,Digits))     // �������� ���������
           {
            Dist=MathAbs(OrderOpenPrice()-Win_Price);// ����� ��������
            int    Tip   =OrderType();          // ��� ���������� ���.
            int    Ticket=OrderTicket();        // ����� �������. ���.
            double Price =OrderOpenPrice();     // ���� �������. ���.
            double SL    =OrderStopLoss();      // SL ���������� ���.
            double TP    =OrderTakeProfit();    // TP ���������� ���.
           }                                    // ����� if
        }                                       // ����� ������� ������
     }                                          // ����� �������� ���.
//--------------------------------------------------------------- 5 --
   if (Tip==0)                                  // ���� ���������� ���
     {
      Alert("�� ",Symb," ���������� ������� ���");
      return;                                   // ����� �� ���������
     }
//--------------------------------------------------------------- 6 --
   while(true)                                  // ���� �������� ���.
     {
      RefreshRates();                           // ������� ������
      //--------------------------------------------------------- 7 --
      double TS=Tral;                           // �������� ��������
      int Min_Dist=MarketInfo(Symb,MODE_STOPLEVEL);//�����. ���������
      if (TS<Min_Dist)                          // ���� ������ ������.
         TS=Min_Dist;                           // ����� �������� TS
      //--------------------------------------------------------- 8 --
      string Text="";                           // �� �������� � ������
      double New_SL=0;
      double New_TP=0;
      switch(Tip)                               // �� ���� ������
        {
         case 2:                                // BuyLimit
            if (NormalizeDouble(Price,Digits) < // ���� ������, ��� ��
                NormalizeDouble(Ask-TS*Point,Digits))//..�������� ����
              {
               double New_Price=Ask-TS*Point;   // ����� ��� ����
               if (NormalizeDouble(SL,Digits)>0)
                  New_SL=New_Price-(Price-SL);  // ����� StopLoss
               if (NormalizeDouble(TP,Digits)>0)
                  New_TP=New_Price+(TP-Price);  // ����� TakeProfit
               Text= "BuyLimit ";               // ����� ��� ������.
              }
            break;                              // ����� �� switch
         case 3:                                // SellLimit 
            if (NormalizeDouble(Price,Digits) > // ���� ������, ��� ��
                NormalizeDouble(Bid+TS*Point,Digits))//..�������� ����
              {
               New_Price=Bid+TS*Point;          // ����� ��� ����
               if (NormalizeDouble(SL,Digits)>0)
                  New_SL=New_Price+(SL-Price);  // ����� StopLoss
               if (NormalizeDouble(TP,Digits)>0)
                  New_TP=New_Price-(Price-TP);  // ����� TakeProfit
               Text= "SellLimit ";              // ����� ��� ������.
              }
            break;                              // ����� �� switch
         case 4:                                // BuyStopt
            if (NormalizeDouble(Price,Digits) > // ���� ������, ��� ��
                NormalizeDouble(Ask+TS*Point,Digits))//..�������� ����
              {
               New_Price=Ask+TS*Point;          // ����� ��� ����
               if (NormalizeDouble(SL,Digits)>0)
                  New_SL=New_Price-(Price-SL);  // ����� StopLoss
               if (NormalizeDouble(TP,Digits)>0)
                  New_TP=New_Price+(TP-Price);  // ����� TakeProfit
               Text= "BuyStopt ";               // ����� ��� ������.
              }
            break;                              // ����� �� switch
         case 5:                                // SellStop
            if (NormalizeDouble(Price,Digits) < // ���� ������, ��� ��
                NormalizeDouble(Bid-TS*Point,Digits))//..�������� ����
              {
               New_Price=Bid-TS*Point;          // ����� ��� ����
               if (NormalizeDouble(SL,Digits)>0)
                  New_SL=New_Price+(SL-Price);  // ����� StopLoss
               if (NormalizeDouble(TP,Digits)>0)
                  New_TP=New_Price-(Price-TP);  // ����� TakeProfit
               Text= "SellStop ";               // ����� ��� ������.
              }
        }
      if (NormalizeDouble(New_SL,Digits)<0)     // �������� SL
         New_SL=0;
      if (NormalizeDouble(New_TP,Digits)<0)     // �������� TP
         New_TP=0;
      //--------------------------------------------------------- 9 --
      if (Text=="")                             // ���� ��� �� ������
        {
         Alert("��� ������� ��� �����������.");
         break;                                 // ����� �� while
        }
      //-------------------------------------------------------- 10 --
      Alert ("����������� ",Text,Ticket,". ��� �����..");
      bool Ans=OrderModify(Ticket,New_Price,New_SL,New_TP,0);//������!
      //-------------------------------------------------------- 11 --
      if (Ans==true)                            // ���������� :)
        {
         Alert ("������������� ����� ",Text," ",Ticket," :)");
         break;                                 // ����� �� ����� ����
        }
      //-------------------------------------------------------- 12 --
      int Error=GetLastError();                 // �� ���������� :(
      switch(Error)                             // ����������� ������
        {
         case  4: Alert("�������� ������ �����. ������� ��� ���..");
            Sleep(3000);                        // ������� �������
            continue;                           // �� ����. ��������
         case 137:Alert("������ �����. ������� ��� ���..");
            Sleep(3000);                        // ������� �������
            continue;                           // �� ����. ��������
         case 146:Alert("���������� �������� ������. ������� ���..");
            Sleep(500);                         // ������� �������
            continue;                           // �� ����. ��������
        }
      switch(Error)                             // ����������� ������
        {
         case 2 : Alert("����� ������.");
            break;                              // ����� �� switch
         case 64: Alert("���� ������������.");
            break;                              // ����� �� switch
         case 133:Alert("�������� ���������");
            break;                              // ����� �� switch
         case 139:Alert("����� ������������ � ��� ��������������");
            break;                              // ����� �� switch
         case 145:Alert("����������� ���������. ",
                              "����� ������� ������ � �����");
            break;                              // ����� �� switch
         default: Alert("�������� ������ ",Error);//������ ��������   
        }
      break;                                    // ����� �� ����� ����
     }                                          // ����� ����� ����.   
//-------------------------------------------------------------- 13 --
   Alert ("������ �������� ������ -----------------------");
   return;                                      // ����� �� start()
  }
//-------------------------------------------------------------- 14 --