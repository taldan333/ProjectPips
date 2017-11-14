//--- strict compilation mode
#property strict
//--- show input parameters
#property show_inputs
//--- property website
#property link      "Work In Progress"

//+------------------------------------------------------------------+
//| Input Parameters                                                 |
//+------------------------------------------------------------------+

input ENUM_MA_METHOD InpMAMethod=MODE_SMMA;  // Smoothing method
static input int magicNumber = 91273;      // Magic Number
extern double lots = 0.01;          // Lot Size
extern double Risk = 7;             // Money Management Risk %
extern int MAFastPeriod = 7;        // Fast Period
extern int MASlowPeriod = 21;       // Slow Period
extern int slippage = 3;            // Slippage
extern double stopLoss = 50;        // Stop Loss
extern double takeProfit = 0;       // Take Profit
extern bool trail = False;          // Trailing Toggle
extern double TrailingStop = 20;    // Trailing Amount
extern int ADXmin = 20;             // ADX Filter
extern int Money_Management = 0;    // Money Management Type

int counter;
bool openOrder;
bool buySignal1, buySignal2;
bool sellSignal1, sellSignal2;
bool debug = false;

//+------------------------------------------------------------------+
//|        INITIALIZATION FUNCTION                                   |
//+------------------------------------------------------------------+
int init()
{
   return(0);
}
//+------------------------------------------------------------------+
//|        DEINITIALIZATION FUNCTION                                 |
//+------------------------------------------------------------------+
int deinit()
{
   return(0);
}
//+------------------------------------------------------------------+
//|        START FUNCTION                                            |
//+------------------------------------------------------------------+
int start()
{
   lots=NormalizeDouble(((AccountBalance()*(Risk/100))/stopLoss/10),2);
   if (lots > 10) lots = 10;
   if (trail) trail();
   openOrder = false;
   generateSignals();
   //check for open orders
   for(counter=0;counter<OrdersTotal();counter++)   
  {
      OrderSelect(counter, SELECT_BY_POS, MODE_TRADES);     
      if (OrderMagicNumber() == magicNumber)
      {
         openOrder = true;
        }
         //check for closing signals
         if (OrderType() == OP_BUY && sellSignal1)
         {
            closeBuyTrade();
            openOrder = false;
         }
        
         else if (OrderType() == OP_SELL && buySignal1)
         {
            closeSellTrade();
            openOrder = false;
         }
        

      }
   
  //There are no open orders. check for signals.
   if (!openOrder)
   {
      if (buySignal1 && buySignal2)       
        {
          placeBuy();
          trail();
          }
      else if (sellSignal1 && sellSignal2)
         {
         placeSell();
         trail();
         }
   }
   return(0);
}
//+------------------------------------------------------------------+
//| OPEN BUY ORDER                                                   |
//+------------------------------------------------------------------+
void placeBuy()
{
   double MyPoint=Point;
    if(Digits==3 || Digits==5) MyPoint=Point*10;
  
    double TheStopLoss=0;
    double TheTakeProfit=0;
   RefreshRates();            
    int result=0;
    result=OrderSend(Symbol(),OP_BUY,lots,Ask,slippage,0,0,"EA Generator www.ForexEAdvisor.com",magicNumber,0,Blue);
        if(result>0)
        {
         TheStopLoss=0;
         TheTakeProfit=0;
         if(takeProfit>0) TheTakeProfit=Ask+takeProfit*MyPoint;
         if(stopLoss>0) TheStopLoss=Ask-stopLoss*MyPoint;
         OrderSelect(result,SELECT_BY_TICKET);
         OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(TheStopLoss,Digits),NormalizeDouble(TheTakeProfit,Digits),0,Green);
        }
        
}
//+------------------------------------------------------------------+
//| OPEN SELL ORDER                                                  |
//+------------------------------------------------------------------+
void placeSell()
{
   double MyPoint=Point;
    if(Digits==3 || Digits==5) MyPoint=Point*10;
  
    double TheStopLoss=0;
    double TheTakeProfit=0;
   RefreshRates();
   int result=0;
   result=OrderSend(Symbol(),OP_SELL,lots,Bid,slippage,0,0,"EA Generator www.ForexEAdvisor.com",magicNumber,0,Red);
        if(result>0)
        {
         TheStopLoss=0;
         TheTakeProfit=0;
         if(takeProfit>0) TheTakeProfit=Bid-takeProfit*MyPoint;
         if(stopLoss>0) TheStopLoss=Bid+stopLoss*MyPoint;
         OrderSelect(result,SELECT_BY_TICKET);
         OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(TheStopLoss,Digits),NormalizeDouble(TheTakeProfit,Digits),0,Green);
        }
       
}
//+------------------------------------------------------------------+
//| CLOSE BUY ORDER                                                  |
//+------------------------------------------------------------------+
void closeBuyTrade()
{
      RefreshRates();
      OrderClose(OrderTicket(),OrderLots(),Bid,slippage,Green);     
}
//+------------------------------------------------------------------+
//| CLOSE SELL ORDER                                                 |
//+------------------------------------------------------------------+
void closeSellTrade()
{
      RefreshRates();
      OrderClose(OrderTicket(),OrderLots(),Ask,slippage,Red);  
}
//+------------------------------------------------------------------+
//| generate a buy or sell signal upon MA cross over
//+------------------------------------------------------------------+
void generateSignals()
{
   double MAFastPrevious, MAFastCurrent;
   double MASlowPrevious, MASlowCurrent;   
   buySignal1 = false;
   sellSignal1 = false;
   buySignal2 = false;
   sellSignal2 = false;
   
   MAFastCurrent=iMA(NULL,0,MAFastPeriod,0,MODE_LWMA,PRICE_CLOSE,0); 
   MAFastPrevious=iMA(NULL,0,MAFastPeriod,0,MODE_LWMA,PRICE_CLOSE,1); 
   MASlowPrevious=iMA(NULL,0,MASlowPeriod,0,MODE_LWMA,PRICE_WEIGHTED,1); 
   MASlowCurrent=iMA(NULL,0,MASlowPeriod,0,MODE_LWMA,PRICE_WEIGHTED,0); 
   
   //fast MA crosses up over slow MA
   if ((MAFastPrevious < MASlowPrevious) && (MAFastCurrent > MASlowCurrent))
   {
      buySignal1 = true;
   }
   //fast MA crosses down under slow MA
   else if ((MAFastPrevious > MASlowPrevious) && (MAFastCurrent < MASlowCurrent))
  {
      sellSignal1 = true;
   }   
   //ADX filter 
   if (iADX(NULL,0,14,PRICE_CLOSE,MODE_MAIN,1) > ADXmin)
   {
   buySignal2 = true;
   }
   if (iADX(NULL,0,14,PRICE_CLOSE,MODE_MAIN,1) > ADXmin)
    {
     sellSignal2 = true;   
    }
   
   if (debug) Print("Buy ",buySignal1," ",buySignal2," Sell ",sellSignal1," ",sellSignal2);
}
//+------------------------------------------------------------------+
//| generate a trailing stop
//+------------------------------------------------------------------+
void trail()
 {
    double MyPoint=Point;
    if(Digits==3 || Digits==5) MyPoint=Point*10;
for(int i =0;i<OrdersTotal();i++)
     {
      OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      if(OrderType()<=OP_SELL &&   
         OrderSymbol()==Symbol() &&
         OrderMagicNumber()==magicNumber 
         )  
        {
         if(OrderType()==OP_BUY)  
           {
            if(TrailingStop>0)  
              {                 
               if(Bid-OrderOpenPrice()>MyPoint*TrailingStop)
                 {
                  if(OrderStopLoss()<Bid-MyPoint*TrailingStop)
                    {
                     OrderModify(OrderTicket(),OrderOpenPrice(),Bid-TrailingStop*MyPoint,OrderTakeProfit(),0,Green);
                     
                    }
                 }
              }
           }
         else 
           {
            if(TrailingStop>0)  
              {                 
               if((OrderOpenPrice()-Ask)>(MyPoint*TrailingStop))
                 {
                  if((OrderStopLoss()>(Ask+MyPoint*TrailingStop)) || (OrderStopLoss()==0))
                    {
                     OrderModify(OrderTicket(),OrderOpenPrice(),Ask+MyPoint*TrailingStop,OrderTakeProfit(),0,Red);
                     
                    }
                 }
              }
           }
        }
     }
} 

