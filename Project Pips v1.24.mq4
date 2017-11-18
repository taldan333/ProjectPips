
#property strict                                                 
#property version    "1.24"
//#property link       "Website Goes Here"
#property copyright  "Project Pips, LLC."

enum PP_MM 
  {
   ppOff=0,       // Off
   ppSL=1,        // Risk % Stop Loss
   ppTR=2,        // Risk % Trailing
   ppSET=3,       // 0.01 Per $100
   ppEQ=4,        // Risk % Balance
  };
  
enum PP_Shift
   {
   ppCurrent=0,   // Current Open Bar
   ppPrev=1,      // Previous Bar
   };

//+------------------------------------------------------------------+
//| Input Parameters                                                 |
//+------------------------------------------------------------------+

static input int              PP_MagicNumber = 91273;              // Magic Number
static input string           PP_STANDARD_Settings = "-----------";// =====> STANDARD SETTINGS <=====
extern double                 PP_Lot_Size = 0.01;                  // Lot Size
input double                  PP_Lot_Max = 10;                     // Max Lot Size
input double                  PP_TakeProfit = 0;                   // Take Profit
input double                  PP_StopLoss = 50;                    // Stop Loss
input int                     PP_Slippage = 3;                     // Max Slippage

static input string           PP_MM_Settings = "-----------";      // =====> MONEY MANAGEMENT <=====
input double                  PP_Risk = 7;                         // Risk %
input PP_MM                   PP_MM_Type = 0;                      // MM Type

static input string           PP_MAFAST_Settings = "-----------";  // =====> FAST MOVING AVERAGE <=====
input ENUM_TIMEFRAMES         PP_MA_Fast_Time = 0;                 // Time Frame
input int                     PP_MA_Fast_Period = 7;               // Fast Period
input ENUM_MA_METHOD          PP_MA_Fast_Method = MODE_LWMA;       // Averaging Method
input ENUM_APPLIED_PRICE      PP_MA_Fast_Price = PRICE_CLOSE;      // Applied Price

static input string           PP_MASLOW_Settings = "-----------";  // =====> SLOW MOVING AVERAGE <=====
input ENUM_TIMEFRAMES         PP_MA_Slow_Time = 0;                 // Time Frame
input int                     PP_MA_Slow_Period = 21;              // Slow Period
input ENUM_MA_METHOD          PP_MA_Slow_Method = MODE_LWMA;       // Averaging Method
input ENUM_APPLIED_PRICE      PP_MA_Slow_Price = PRICE_WEIGHTED;   // Applied Price

static input string           PP_TRAIL_Settings = "-----------";   // =======> TRAILING STOP <=======
input bool                    PP_Trailing_Flag = False;            // Trailing Order
input double                  PP_Trailing_Stop = 20;               // Trailing Stop
input int                     PP_Trailing_Step = 5;                // Trailing Step
input double                  PP_Trailing_Start = 0;               // When to Trail

static input string           PP_BREAKEVEN_Settings ="-----------";// ========> BREAK EVEN <=========
input bool                    PP_Breakeven_Flag = False;           // Breakeven Order
input double                  PP_Breakeven_Point = 20;             // Breakeven Point
input double                  PP_Breakeven_LockIn = 10;            // Pips to Lock in

static input string           PP_FILTER_Settings = "-----------";  // ####### FILTER SETTINGS #######

static input string           PP_ADX_Settings = "-----------";     // =========> ADX FILTER <=========
input bool                    PP_ADX_Flag = True;                  // ADX Toggle
input ENUM_TIMEFRAMES         PP_ADX_Time = 0;                     // ADX Time Frame
input int                     PP_ADX_Period = 14;                  // ADX Period
input ENUM_APPLIED_PRICE      PP_ADX_Price = 0;                    // ADX Applied Price
input int                     PP_ADXmin = 20;                      // ADX Min
input PP_Shift                PP_ADX_Shift =1;                     // ADX Shift

static input string           PP_MACD_Settings = "-----------";    // =========> MACD FILTER <========
input bool                    PP_MACD_Flag = False;                // MACD Toggle
input ENUM_TIMEFRAMES         PP_MACD_Time = 0;                    // MACD Time Frame
input int                     PP_MACD_Fast = 12;                   // MACD Fast Period
input int                     PP_MACD_Slow = 26;                   // MACD Slow Period
input int                     PP_MACD_Signal =9;                   // MACD Signal Period
input ENUM_APPLIED_PRICE      PP_MACD_Price = 0;                   // MACD Applied Price
input PP_Shift                PP_MACD_Shift = 1;                   // MACD Shift

static input string           PP_SAR_Settings = "-----------";     // =========> SAR FILTER <=========
input bool                    PP_SAR_Flag = False;                 // SAR Toggle
input ENUM_TIMEFRAMES         PP_SAR_Time = 0;                     // SAR Time Frame
input double                  PP_SAR_Step = 0.02;                  // SAR Step Increment
input double                  PP_SAR_MaxStep = 0.2;                // SAR Max Step
input PP_Shift                PP_SAR_Shift = 1;                    // SAR Shift

static input string           PP_RSI_Settings = "-----------";     // =========> RSI FILTER <=========
input bool                    PP_RSI_Flag = False;                 // RSI Toggle
input ENUM_TIMEFRAMES         PP_RSI_Time = 0;                     // RSI Time Frame 
input int                     PP_RSI_Period = 14;                  // RSI Period
input ENUM_APPLIED_PRICE      PP_RSI_Price = 0;                    // RSI Applied Price
input double                  PP_RSI_Sell = 70;                    // RSI Sell Signal
input double                  PP_RSI_Buy = 30;                     // RSI Buy Signal
input PP_Shift                PP_RSI_Shift = 1;                    // RSI Shift


static input string           PP_PullBack_Settings = "-----------";// ======> PULLBACK FILTER <======
input bool                    PP_PullBack_Long_Flag = False;       // PullBack Long
input double                  PP_PullBack_Long = 10;               // Long Pips
input bool                    PP_PullBack_Short_Flag = False;      // PullBack Short
input double                  PP_PullBack_Short = 10;              // Short Pips

//+------------------------------------------------------------------+
//|        GLOBAL VARIABLES                                          |
//+------------------------------------------------------------------+
int PP_Signal_BuyCount = 0;
int PP_Signal_Required = 0;
int PP_Signal_SellCount =0;

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
//---- Run Signal Required Counter----  
   if (PP_Signal_Required == 0)              
   {
      if (PP_ADX_Flag)PP_Signal_Required++;
      if (PP_MACD_Flag)PP_Signal_Required++;
      if (PP_SAR_Flag)PP_Signal_Required++;
      if (PP_RSI_Flag)PP_Signal_Required++;

               
   }
//---- END Signal Required Counter----  
   
//---- Run Money Management Type ----   
   if (PP_MM_Type ==1)
      {
         PP_Lot_Size=NormalizeDouble(((AccountBalance()*(PP_Risk/100))/PP_StopLoss/10),2);         // Risk based on Stop Loss
      }
   if (PP_MM_Type ==2)
      {
         PP_Lot_Size=NormalizeDouble(((AccountBalance()*(PP_Risk/100))/PP_Trailing_Stop/10),2);    // Risk based on Trailing Stop
      }
   if (PP_MM_Type ==3)
      {
         PP_Lot_Size = NormalizeDouble((AccountBalance()/100*0.01),2);                             // Set risk 0.01 lot per $100
      }      
   if (PP_MM_Type ==4)
      {
         PP_Lot_Size = NormalizeDouble((AccountBalance()*(PP_Risk/100)*0.01*0.05),2);              // Fudge Factor Method     
      }
//---- END Money Management Type ----

   if (PP_Lot_Size > PP_Lot_Max) PP_Lot_Size = PP_Lot_Max;                                         // Lot Size Limit
   if (PP_Trailing_Flag) PP_Trailing_Flag();
   if (PP_Breakeven_Flag) PP_Breakeven_Flag();
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
        
         if (OrderType() == OP_SELL && buySignal1)
            {
            closeSellTrade();
            openOrder = false;
            }
         if (OrderType() == OP_BUYLIMIT && sellSignal1)
            {
            DeletePendingOrder();
            openOrder = false;
            }   
         if (OrderType() == OP_SELLLIMIT && buySignal1)
            {
            DeletePendingOrder();
            openOrder = false;
            }            
        

      }
   

//--------NEW CODE HERE-----------
   if (!openOrder)
   {
//   Print("Signal required=", PP_Signal_Required);
//   Print("Buy count=", PP_Signal_BuyCount);
//   Print("Sell count=", PP_Signal_SellCount);
      if (PP_Signal_Required == 0 && buySignal1==true)
        {          
           placeBuy();
        }
      if ((PP_Signal_BuyCount == PP_Signal_Required) && (buySignal1==true))       
        {
           if (PP_PullBack_Long_Flag)
               PP_PullBack_Buy();
            else 
               placeBuy();
        }
      if ((PP_Signal_SellCount == PP_Signal_Required) && (sellSignal1==true))
        {
           if (PP_PullBack_Short_Flag) 
               PP_PullBack_Sell();
            else 
               placeSell();
        }
      if (PP_Signal_Required == 0 && sellSignal1==true)
        {             
           placeSell();
        }    
   }


   return(0);
}

//+------------------------------------------------------------------+
//|                     OPEN BUY ORDER                               |
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
   if (PP_Trailing_Flag) PP_Trailing_Flag();
   if (PP_Breakeven_Flag) PP_Breakeven_Flag();        
}

//+------------------------------------------------------------------+
//|                     OPEN SELL ORDER                              |
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
   if (PP_Trailing_Flag) PP_Trailing_Flag();
   if (PP_Breakeven_Flag) PP_Breakeven_Flag();       
}

//+------------------------------------------------------------------+
//|                     CLOSE BUY ORDER                              |
//+------------------------------------------------------------------+
void closeBuyTrade()
{
      RefreshRates();
      OrderClose(OrderTicket(),OrderLots(),Bid,PP_Slippage,Green);  
}

//+------------------------------------------------------------------+
//|                     CLOSE SELL ORDER                             |
//+------------------------------------------------------------------+
void closeSellTrade()
{
      RefreshRates();
      OrderClose(OrderTicket(),OrderLots(),Ask,PP_Slippage,Red);    
}

//+------------------------------------------------------------------+
//|                     GENERATE MA CROSS SIGNAL                     |
//+------------------------------------------------------------------+
void generateSignals()
{
   double MAFastPrevious, MAFastCurrent;
   double MASlowPrevious, MASlowCurrent;   
   buySignal1 = false;
   sellSignal1 = false;
   buySignal2 = false;
   sellSignal2 = false;
   PP_Signal_BuyCount =0;
   PP_Signal_SellCount =0;  
   
   MAFastCurrent=iMA(NULL,PP_MA_Fast_Time,PP_MA_Fast_Period,0,PP_MA_Fast_Method,PP_MA_Fast_Price,0); 
   MAFastPrevious=iMA(NULL,PP_MA_Fast_Time,PP_MA_Fast_Period,0,PP_MA_Fast_Method,PP_MA_Fast_Price,1); 
   MASlowPrevious=iMA(NULL,PP_MA_Slow_Time,PP_MA_Slow_Period,0,PP_MA_Slow_Method,PP_MA_Slow_Price,1); 
   MASlowCurrent=iMA(NULL,PP_MA_Slow_Time,PP_MA_Slow_Period,0,PP_MA_Slow_Method,PP_MA_Slow_Price,0); 
   
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
   
   
//--------SIGNAL FILTER START-----------
   
   
   if (PP_Signal_Required>0)
   {
//----------ADX FILTER---------------   
   if (PP_ADX_Flag) 
   {
      if (iADX(NULL,PP_ADX_Time,PP_ADX_Period,PP_ADX_Price,MODE_MAIN,PP_ADX_Shift) >= PP_ADXmin)
         {
         PP_Signal_BuyCount++;
         PP_Signal_SellCount++;
         }

   } 
  
//----------ADX FILTER--------------- 

//----------RSI FILTER---------------    
   if (PP_RSI_Flag)
   {
      if((iRSI(NULL,PP_RSI_Time,PP_RSI_Period,PP_RSI_Price,PP_RSI_Shift)<=PP_RSI_Buy))
         {
         PP_Signal_BuyCount++;
         }
      if((iRSI(NULL,PP_RSI_Time,PP_RSI_Period,PP_RSI_Price,PP_RSI_Shift)>=PP_RSI_Sell))
         {
         PP_Signal_SellCount++;
         }   
   }
//----------RSI FILTER--------------- 

//----------MACD FILTER--------------- 
   if (PP_MACD_Flag)
   {
      if (iMACD(NULL,PP_MACD_Time,PP_MACD_Fast,PP_MACD_Slow,PP_MACD_Signal,PP_MACD_Price,MODE_MAIN,PP_MACD_Shift) > 0)
         {
         PP_Signal_BuyCount++;
         }
      if (iMACD(NULL,PP_MACD_Time,PP_MACD_Fast,PP_MACD_Slow,PP_MACD_Signal,PP_MACD_Price,MODE_MAIN,PP_MACD_Shift) < 0)
         {
         PP_Signal_SellCount++;
         }
   }         
//----------MACD FILTER---------------

//----------SAR FILTER---------------  
   if (PP_SAR_Flag)
   {  
      if(iSAR(NULL,PP_SAR_Time,PP_SAR_Step,PP_SAR_MaxStep,PP_SAR_Shift)<Ask)
         {
         PP_Signal_BuyCount++;
         }
      if(iSAR(NULL,PP_SAR_Time,PP_SAR_Step,PP_SAR_MaxStep,PP_SAR_Shift)>Ask)
         {
         PP_Signal_SellCount++;
         }
                   
    }
 //----------SAR FILTER---------------    
    
   }
   
        
//--------SIGNAL FILTER END-----------   
   

   if (debug) Print("Buy ",buySignal1," ",buySignal2," Sell ",sellSignal1," ",sellSignal2);
}

//+------------------------------------------------------------------+
//|                     GENERATE TRAILING STOP                       |
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
               if(Bid-OrderOpenPrice()>MyPoint*PP_Trailing_Stop && MyPoint*PP_Trailing_Start)
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
               if((OrderOpenPrice()-Ask)>(MyPoint*PP_Trailing_Stop) && MyPoint*PP_Trailing_Start || ( NormalizeDouble( OrderStopLoss(), Digits) == 0 ))
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

//+------------------------------------------------------------------+
//|                     GENERATE BREAKEVEN                           |
//+------------------------------------------------------------------+
void PP_Breakeven_Flag()
 {

 double MyPoint=Point;
    if(Digits==3 || Digits==5) MyPoint=Point*10;
for(int i =0;i<OrdersTotal();i++)
     {
      OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      if(OrderType()<=OP_SELL &&   
         OrderSymbol()==Symbol() &&
         OrderMagicNumber()==PP_MagicNumber 
         )  
        {
         if(OrderType()==OP_BUY)  
           {
           if (Bid-OrderOpenPrice() > PP_Breakeven_Point*MyPoint)
             {
               if(OrderStopLoss() < PP_Breakeven_LockIn*MyPoint+OrderOpenPrice()) 
                 { 
                 OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()+PP_Breakeven_LockIn*MyPoint,OrderTakeProfit(),0,Green);   
                  }
              }   
              }   
        else
         {
         if (OrderOpenPrice()-Ask > PP_Breakeven_Point*MyPoint)
            {
             if(OrderStopLoss() > (OrderOpenPrice()-PP_Breakeven_LockIn*MyPoint)) 
          {
            OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()-PP_Breakeven_LockIn*MyPoint,OrderTakeProfit(),0,Red);
          }
       
         }  
         }
      }  
   }
}



//+------------------------------------------------------------------+
//| open pullback buy
//+------------------------------------------------------------------+
void PP_PullBack_Buy()
{
double MyPoint=Point;
    if(Digits==3 || Digits==5) MyPoint=Point*10;
    double TheStopLoss=0;
    double TheTakeProfit=0;
    RefreshRates();
   int result=0;
   result=OrderSend(Symbol(),OP_BUYLIMIT,PP_Lot_Size,Ask-PP_PullBack_Long*MyPoint,PP_Slippage,0,0,"Project Pips",PP_MagicNumber,0,Blue);
    if (result > 0)
    {
         TheStopLoss=0;
         TheTakeProfit=0;
         if(PP_TakeProfit>0) TheTakeProfit=(Ask-PP_PullBack_Long*MyPoint)+PP_TakeProfit*MyPoint;
         if(PP_StopLoss>0) TheStopLoss=(Ask-PP_PullBack_Long*MyPoint)-PP_StopLoss*MyPoint;
         OrderSelect(result,SELECT_BY_TICKET);
         OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(TheStopLoss,Digits),NormalizeDouble(TheTakeProfit,Digits),0,Green);
        }
 }
 
//+------------------------------------------------------------------+
//| open pullback sell
//+------------------------------------------------------------------+ 
void PP_PullBack_Sell()  
{
double MyPoint=Point;
    if(Digits==3 || Digits==5) MyPoint=Point*10;
    double TheStopLoss=0;
    double TheTakeProfit=0;
    RefreshRates();
   int result=0;
   result=OrderSend(Symbol(),OP_SELLLIMIT,PP_Lot_Size,Bid+PP_PullBack_Short*MyPoint,PP_Slippage,0,0,"Project Pips",PP_MagicNumber,0,Red);
    if (result > 0)
    {
         TheStopLoss=0;
         TheTakeProfit=0;
         if(PP_TakeProfit>0) TheTakeProfit=(Bid+PP_PullBack_Short*MyPoint)-PP_TakeProfit*MyPoint;
         if(PP_StopLoss>0) TheStopLoss=(Bid+PP_PullBack_Short*MyPoint)+PP_StopLoss*MyPoint;
         OrderSelect(result,SELECT_BY_TICKET);
         OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(TheStopLoss,Digits),NormalizeDouble(TheTakeProfit,Digits),0,Green);
        
     }
 }  
//+------------------------------------------------------------------+
//| delete pending order
//+------------------------------------------------------------------+ 
void DeletePendingOrder()
{
 RefreshRates();
 OrderDelete(OrderTicket()); 
}


  