//--------------------------------------------------------------------
// modifystoploss.mq4
// ������������ ��� ������������� � �������� ������� � �������� MQL4.
//--------------------------------------------------------------------
extern int Tral_Stop=10;                        // ����. �������������
//--------------------------------------------------------------- 1 --
int start()                                     // ����. ������� start
  {
   string Symb=Symbol();                        // ������. ����������
//--------------------------------------------------------------- 2 --
   for(int i=1; i<=OrdersTotal(); i++)          // ���� �������� �����
     {
      if (OrderSelect(i-1,SELECT_BY_POS)==true) // ���� ���� ���������
        {                                       // ������ �������:
         int Tip=OrderType();                   // ��� ������
         if(OrderSymbol()!=Symb||Tip>1)continue;// �� ��� �����
         double SL=OrderStopLoss();             // SL ���������� ���.
         //------------------------------------------------------ 3 --
         while(true)                            // ���� �����������
           {
            double TS=Tral_Stop;                // �������� ��������
            int Min_Dist=MarketInfo(Symb,MODE_STOPLEVEL);//�����. ����
            if (TS<Min_Dist)                    // ���� ������ ������.
               TS=Min_Dist;                     // ����� �������� TS
            //--------------------------------------------------- 4 --
            bool Modify=false;                  // �� �������� � ������
            switch(Tip)                         // �� ���� ������
              {
               case 0 :                         // ����� Buy
                  if (NormalizeDouble(SL,Digits)< // ���� ���� ������.
                     NormalizeDouble(Bid-TS*Point,Digits))
                    {
                     SL=Bid-TS*Point;           // �� ������������ ���
                     string Text="Buy ";        // ����� ��� Buy 
                     Modify=true;               // �������� � ������.
                    }
                  break;                        // ����� �� switch
               case 1 :                         // ����� Sell
                  if (NormalizeDouble(SL,Digits)> // ���� ���� ������.
                     NormalizeDouble(Ask+TS*Point,Digits)
                     || NormalizeDouble(SL,Digits)==0)//��� ����� ����
                    {
                     SL=Ask+TS*Point;           // �� ������������ ���
                     Text="Sell ";              // ����� ��� Sell 
                     Modify=true;               // �������� � ������.
                    }
              }                                 // ����� switch
            if (Modify==false)                  // ���� ��� �� ������
               break;                           // ����� �� while
            //--------------------------------------------------- 5 --
            double TP    =OrderTakeProfit();    // TP ���������� ���.
            double Price =OrderOpenPrice();     // ���� �������. ���.
            int    Ticket=OrderTicket();        // ����� �������. ���.

            Alert ("����������� ",Text,Ticket,". ��� �����..");
            bool Ans=OrderModify(Ticket,Price,SL,TP,0);//������ ���!
            //--------------------------------------------------- 6 --
            if (Ans==true)                      // ���������� :)
              {
               Alert ("����� ",Text,Ticket," �������������:)");
               break;                           // �� ����� ������.
              }
            //--------------------------------------------------- 7 --
            int Error=GetLastError();           // �� ���������� :(
            switch(Error)                       // ����������� ������
              {
               case 130:Alert("������������ �����. ������� ��� ���.");
                  RefreshRates();               // ������� ������
                  continue;                     // �� ����. ��������
               case 136:Alert("��� ���. ��� ����� ���..");
                  while(RefreshRates()==false)  // �� ������ ����
                     Sleep(1);                  // �������� � �����
                  continue;                     // �� ����. ��������
               case 146:Alert("���������� ������ ������.������� ���");
                  Sleep(500);                   // ������� �������
                  RefreshRates();               // ������� ������
                  continue;                     // �� ����. ��������
                  // ����������� ������
               case 2 : Alert("����� ������.");
                  break;                        // ����� �� switch
               case 5 : Alert("������ ������ ����������� ���������.");
                  break;                        // ����� �� switch
               case 64: Alert("���� ������������.");
                  break;                        // ����� �� switch
               case 133:Alert("�������� ���������");
                  break;                        // ����� �� switch
               default: Alert("�������� ������ ",Error);//��. ������
              }
            break;                              // �� ����� ������.
           }                                    // ����� ����� ������.
         //------------------------------------------------------ 8 --
        }                                       // ����� ������� ���.
     }                                          // ����� �������� ���.
//--------------------------------------------------------------- 9 --
   return;                                      // ����� �� start()
  }
//-------------------------------------------------------------- 10 --