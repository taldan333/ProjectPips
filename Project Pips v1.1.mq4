//--- strict compilation mode
#property strict
//--- property website
#property version    "1.1"
#property link       "Website Goes Here"
#property copyright  "Project Pips, LLC."

//+------------------------------------------------------------------+
//| Input Parameters                                                 |
//+------------------------------------------------------------------+
static input int              PP_MagicNumber = 91273;              // Magic Number
static input string           PP_Standard_Settings = "-----------";// -------- STANDARD SETTINGS --------
extern double                 PP_Lot_Size = 0.01;                  // Lot Size
input double                  PP_TakeProfit = 0;                   // Take Profit
input double                  PP_StopLoss = 50;                    // Stop Loss
input int                     PP_Slippage = 3;                     // Max Slippage

static input string           PP_MM_Settings = "-----------";      // -------- MONEY MANAGEMENT SETTINGS --------
input double                  PP_Risk = 7;                         // Risk %
input int                     Money_Management = 0;                // Money Management Type

static input string           PP_MAFAST_Settings = "-----------";  // -------- FAST MOVING SETTINGS --------
input int                     PP_MA_Fast_Period = 7;               // Fast Period
input ENUM_MA_METHOD          PP_MA_Fast_Method = MODE_LWMA;       // Averaging Method
input ENUM_APPLIED_PRICE      PP_MA_Fast_Price = PRICE_CLOSE;      // Applied Price

static input string           PP_MASLOW_Settings = "-----------";  // -------- SLOW MOVING SETTINGS --------
input int                     PP_MA_Slow_Period = 21;              // Slow Period
input ENUM_MA_METHOD          PP_MA_Slow_Method = MODE_LWMA;       // Averaging Method
input ENUM_APPLIED_PRICE      PP_MA_Slow_Price = PRICE_WEIGHTED;      // Applied Price

static input string           PP_TRAIL_Settings = "-----------";   // -------- TRAILING STOP SETTINGS --------
input bool                    PP_Trailing_Flag = False;            // Trailing Order
input double                  PP_Trailing_Stop = 20;               // Trailing Stop
input int                     PP_Trailing_Step = 5;                // Trailing Step

static input string           PP_FILTER_Settings = "-----------";  // -------- ORDER FILTER SETTINGS --------
input int                     ADXmin = 20;                         // ADX Filter




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
   PP_Lot_Size=NormalizeDouble(((AccountBalance()*(PP_Risk/100))/PP_StopLoss/10),2);
   if (PP_Lot_Size > 10) PP_Lot_Size = 10;
   if (PP_Trailing_Flag) PP_Trailing_Flag();
   openOrder = false;
   generateSignals();
   //check for open orders
   for(counter=0;counter<OrdersTotal();counter++)   
  {
      OrderSelect(counter, SELECT_BY_POS, MODE_TRADES);     
      if (OrderMagicNumber() == PP_MagicNumber)
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
          PP_Trailing_Flag();
          }
      else if (sellSignal1 && sellSignal2)
         {
         placeSell();
         PP_Trailing_Flag();
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
    result=OrderSend(Symbol(),OP_BUY,PP_Lot_Size,Ask,PP_Slippage,0,0,"Project Pips",PP_MagicNumber,0,Blue);
        if(result>0)
        {
         TheStopLoss=0;
         TheTakeProfit=0;
         if(PP_TakeProfit>0) TheTakeProfit=Ask+PP_TakeProfit*MyPoint;
         if(PP_StopLoss>0) TheStopLoss=Ask-PP_StopLoss*MyPoint;
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
   result=OrderSend(Symbol(),OP_SELL,PP_Lot_Size,Bid,PP_Slippage,0,0,"Project Pips",PP_MagicNumber,0,Red);
        if(result>0)
        {
         TheStopLoss=0;
         TheTakeProfit=0;
         if(PP_TakeProfit>0) TheTakeProfit=Bid-PP_TakeProfit*MyPoint;
         if(PP_StopLoss>0) TheStopLoss=Bid+PP_StopLoss*MyPoint;
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
      OrderClose(OrderTicket(),OrderLots(),Bid,PP_Slippage,Green);     
}
//+------------------------------------------------------------------+
//| CLOSE SELL ORDER                                                 |
//+------------------------------------------------------------------+
void closeSellTrade()
{
      RefreshRates();
      OrderClose(OrderTicket(),OrderLots(),Ask,PP_Slippage,Red);  
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
   
   MAFastCurrent=iMA(NULL,0,PP_MA_Fast_Period,0,PP_MA_Fast_Method,PP_MA_Fast_Price,0); 
   MAFastPrevious=iMA(NULL,0,PP_MA_Fast_Period,0,PP_MA_Fast_Method,PP_MA_Fast_Price,1); 
   MASlowPrevious=iMA(NULL,0,PP_MA_Slow_Period,0,PP_MA_Slow_Method,PP_MA_Slow_Price,1); 
   MASlowCurrent=iMA(NULL,0,PP_MA_Slow_Period,0,PP_MA_Slow_Method,PP_MA_Slow_Price,0); 
   
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
void PP_Trailing_Flag()
 {
    double MyPoint=Point;
    if(Digits==3 || Digits==5) MyPoint=Point*10;
for(int i =0;i<OrdersTotal();i++)
     {
      OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      if(OrderType()<=OP_SELL &&                            // check for opened position 
         OrderSymbol()==Symbol() &&                         // check for symbol
         OrderMagicNumber()==PP_MagicNumber                    // Check for magic #
         )  
        {
         if(OrderType()==OP_BUY)                            // long position is opened
           {
            if(PP_Trailing_Stop>0)  
              {                 
               if(Bid-OrderOpenPrice()>MyPoint*PP_Trailing_Stop)
                 {
                  if(OrderStopLoss() + MyPoint*PP_Trailing_Step < Bid - MyPoint*PP_Trailing_Stop)
                    {
                     OrderModify(OrderTicket(),OrderOpenPrice(),Bid-PP_Trailing_Stop*MyPoint,OrderTakeProfit(),0,Green);
                     
                    }
                 }
              }
           }
         else 
           {
            if(PP_Trailing_Stop>0)                             // check for trailing stop
              {                 
               if((OrderOpenPrice()-Ask)>(MyPoint*PP_Trailing_Stop) || ( NormalizeDouble( OrderStopLoss(), Digits) == 0 ))
                 {
                  if((OrderStopLoss() - MyPoint*PP_Trailing_Step > (Ask + MyPoint*PP_Trailing_Stop)) || (NormalizeDouble(OrderStopLoss(), Digits)==0))
                    {
                     OrderModify(OrderTicket(),OrderOpenPrice(),Ask+MyPoint*PP_Trailing_Stop,OrderTakeProfit(),0,Red);
                     
                    }
                 }
              }
           }
        }
     }
} 

