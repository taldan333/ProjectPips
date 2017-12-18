#property strict                                                 
#property version    "1.32"
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
   
enum PP_WS
  {
   ppNothing=0,     // Do Nothing
   ppClose=1,       // Close and Delete 
   ppDelete=2,      // Delete Pending Trade
   ppCloseDelRev=3, // Reverse Position
  };

enum PP_SL
  {
   ppFixed=0,     // Fixed Stop Loss
   ppHiLo=1,      // HiLo Stop Loss
   ppATR=2,       // ATR Stop Loss
  };
   


//+------------------------------------------------------------------+
//| Input Parameters                                                 |
//+------------------------------------------------------------------+

input int                     PP_MagicNumber = 91273;              // Magic Number
static input string           PP_Settings = "-----------";         // =======> STANDARD SETTINGS <========"
extern double                 PP_Lot_Size = 0.01;                  // Lot Size
input double                  PP_Lot_Max = 10;                     // Max Lot Size
input int                     PP_TakeProfit = 0;                   // Take Profit
input int                     PP_Slippage = 3;                     // Max Slippage
input bool                    PP_Close_Signal = True;              // Close on Opposite Cross
input PP_WS                   PP_WS_Type = 0;                      // Wrong Side Action
input ENUM_TIMEFRAMES         PP_WS_Time = 0;                      // Wrong Side Time Frame
extern int                    PP_Sell_Distance = 5;                // Wrong Side Sell Distance
extern int                    PP_Buy_Distance = 5;                 // Wrong Side Buy Distance
extern int                    PP_Rev_SL = 10;                      // Reverse Stop Loss
extern int                    PP_Rev_TakeProfit = 10;              // Reverse Take Profit


static input string           PP_MM_Settings = "-----------";      // =====> MONEY MANAGEMENT <=====
input double                  PP_Risk = 7;                         // Risk %
input PP_MM                   PP_MM_Type = 0;                      // MM Type   

static input string           PP_SL_Settings = "----------";       // =======> STOP LOSS SETTINGS <======"
input PP_SL                   PP_SL_Type = 0;                      // Stop Loss Type
input int                     PP_Fixed_StopLoss = 50;              // Fixed Stop Loss
input int                     SL_candles_in_range = 5;             // HiLo SL Candles in Range
input int                     PP_ATR_SL_period = 14;               // ATR SL Period
input int                     PP_ATR_SL_Shift = 1;                 // ATR SL Shift 
input double                  PP_ATR_SL_Multiplier = 4;            // ATR SL Multiplier

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

static input string           PP_BREAKEVEN_Settings ="-----------";// ========> BREAK EVEN SETTINGS <=========
input bool                    PP_Breakeven_Flag = False;           // Breakeven Toggle
input int                     PP_Breakeven_Point = 20;             // Breakeven Point
input int                     PP_Breakeven_LockIn = 10;            // Pips to Lock in

static input string           PP_TRAIL_OPTIONS = "-----------";    // ####### TRAIL OPTIONS #######

static input string           PP_TRAIL_Settings = "-----------";   // =======> PIP TRAILING STOP <=======
input bool                    PP_Trailing_Flag = False;            // Pip Trail Toggle
input int                     PP_Trailing_Start = 0;               // When to Trail
input int                     PP_Trailing_Stop = 20;               // Trailing Stop
input int                     PP_Trailing_Step = 5;                // Trailing Step

static input string           PP_PSAR_Settings = "-----------";    // ======> PSAR TRAIL  <======
input bool                    PP_PSAR_Trail = False;               // PSAR Trail Toggle
input int                     PP_PSAR_Trail_Start = 1;             // When to Trail
extern ENUM_TIMEFRAMES        PP_PSAR_Trail_Time = PERIOD_H1;      // Time Frame
input int                     PP_PSAR_Trail_Candles_Back = 1;      // Candles Back to Trail
input double                  PP_PSAR_Trail_Step = 0.02;           // PSAR Step
input double                  PP_PSAR_Trail_Maxstep = 0.2;         // PSAR Max Step

static input string           PP_CANDLE_TRAIL_Settings = "---";    // ======> CANDLE TRAIL  <======
extern bool                   PP_Candle_trail_Flag = False;        // Candle Trail Toggle
extern int                    PP_Candle_trail_Start = 1;           // When to Trail
extern ENUM_TIMEFRAMES        PP_Candle_trail_Time = PERIOD_H1;    // Time Frame
extern int                    PP_Candle_trail_Shift = 5;           // Candles Back to Trail
extern int                    PP_Candle_trail_Offset = 5;          // Cushion in Pips 
 
static input string           PP_HILO_TRAIL_Settings = "---";      // ======> HILO CANDLE TRAIL  <=========
extern bool                   PP_HiLo_Trail_Flag = False;          // HiLo Candle Trail Toggle
extern int                    PP_HiLo_Trail_Start = 1;             // When to Trail
extern ENUM_TIMEFRAMES        PP_HiLo_Trail_Time = PERIOD_H1;      // Time Frame
extern int                    PP_HiLo_Trail_candles_in_range = 5;  // Candles in Range
extern int                    PP_HiLo_Trail_starting_candle = 1;   // Starting Candle Back
extern int                    PP_HiLo_Trail_Offset = 5;            // Cushion in Pips

static input string           PP_ATR_TRAIL_Settings = "---";       // ======> ATR TRAIL  <=========
extern bool                   PP_ATR_Trail_Flag = False;           // ATR Trail Toggle
extern int                    PP_ATR_Trail_Start = 1;              // When to Trail
extern ENUM_TIMEFRAMES        PP_ATR_Trail_Time = PERIOD_H1;       // Time Frame
extern int                    PP_ATR_Trail_Period = 14;            // ATR Period
extern int                    PP_ATR_Trail_Shift = 1;              // ATR Shift
extern double                 PP_ATR_Trail_Multiplier = 1;         // ATR Multiplier

static input string           PP_FILTER_Settings = "-----------";  // ####### FILTER SETTINGS #######

static input string           PP_ADX_Settings = "-----------";     // =========> ADX FILTER <=========
input bool                    PP_ADX_Flag = False;                 // ADX Toggle
input ENUM_TIMEFRAMES         PP_ADX_Time = 0;                     // ADX Time Frame
input int                     PP_ADX_Period = 14;                  // ADX Period
input ENUM_APPLIED_PRICE      PP_ADX_Price = 0;                    // ADX Applied Price
input int                     PP_ADXmin = 18;                      // ADX Min Level (0 = no filter)
input PP_Shift                PP_ADX_Shift =1;                     // ADX Shift
input bool                    PP_ADX_Split_Flag = False;           // ADX Split Filter
input int                     PP_ADX_Split = 42;                   // Max level for pullback, min level for market entry

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
input int                     PP_RSI_Sell = 70;                    // RSI Sell Signal Level
input int                     PP_RSI_Buy = 30;                     // RSI Buy Signal Level
input PP_Shift                PP_RSI_Shift = 1;                    // RSI Shift

static input string           PP_ATR_Settings = "-----------";     // =========> ATR FILTER <=========
input bool                    PP_ATR_Flag = False;                 // ATR Toggle 
input ENUM_TIMEFRAMES         PP_ATR_Time = 0;                     // ATR Time Frame 
input int                     PP_ATR_Period = 14;                  // ATR Period
input PP_Shift                PP_ATR_Shift = 1;                    // ATR Shift 
input double                  PP_ATR_min = 0.001;                  // ATR Minimum Level 

static input string           PP_PullBack_Settings = "-----------";// ======> PULLBACK FILTER <======
input bool                    PP_PullBack_Long_Flag = False;       // PullBack Long Toggle
input int                     PP_PullBack_Long = 10;               // PullBack Long Distance
input bool                    PP_PullBack_Short_Flag = False;      // PullBack Short Toggle
input int                     PP_PullBack_Short = 10;              // PullBack Short Distance
input bool                    PP_Pullback_Expiration = False;      // PullBack Expiration Toggle
input int                     PP_Pullback_exp_hrs = 4;             // Pending Order Expiration (hours)

static input string           PP_PULLSTOP_Settings = "---------";  // ####### PULLSTOP SETTINGS #######

static input string           PP_ADX_PS_Settings = "-----------";  // ======> ADX PULLSTOP <======
extern bool                   PP_ADX_PS_Flag = False;              // ADX Pullstop Toggle
extern int                    PP_ADX_stop = 20;                    // ADX Pullstop Stoploss
extern ENUM_TIMEFRAMES        PP_ADX_PS_Time = PERIOD_H1;          // ADX Pullstop Time Frame
extern int                    PP_ADX_PS_level = 18;                // Minimum ADX level

static input string           PP_MACD_PS_Settings = "-----------"; // ======> MACD PULLSTOP <======
extern bool                   PP_MACD_PS_Flag = False;             // MACD Pullstop Toggle
extern int                    PP_MACD_PS_stop = 20;                // MACD Pullstop Stoploss
extern ENUM_TIMEFRAMES        PP_MACD_PS_Time = PERIOD_H1;         // MACD Pullstop Time Frame
extern int                    PP_MACD_PS_fast = 12;                // MACD Pullstop Fast
extern int                    PP_MACD_PS_slow = 26;                // MACD Pullstop Slow
extern int                    PP_MACD_PS_signal = 9;               // MACD Pullstop Signal

static input string           PP_PSAR_PS_Settings = "-----------"; // ======> PSAR PULLSTOP <======
extern bool                   PP_PSAR_PS_Flag = FALSE;             // PSAR Pullstop Toggle
extern int                    PP_PSAR_PS_stop = 20;                // PSAR Pullstop Stoploss
extern ENUM_TIMEFRAMES        PP_PSAR_PS_Time = PERIOD_H1;         // PSAR Time Frame
extern double                 PP_PSAR_PS_step = 0.01;              // PSAR Pullstop Step
extern double                 PP_PSAR_PS_maxstep = 0.1;            // PSAR Pullstop Max Step

static input string           PP_RSI_PS_Settings = "-----------";  // ======> RSI PULLSTOP <======
extern bool                   PP_RSI_PS_Flag = False;              // RSI Pullstop Toggle
extern int                    PP_RSI_PS_stop = 10;                 // RSI Pullstop Stoploss
extern ENUM_TIMEFRAMES        PP_RSI_PS_Time = PERIOD_H1;          // RSI Time Frame
extern int                    PP_RSI_PS_high = 70;                 // RSI High level 
extern int                    PP_RSI_PS_low = 28;                  // RSI Low level


static input string           PP_ATR_PS_Settings = "-----------";  // ======> ATR PULLSTOP <======
extern bool                   PP_ATR_PS_Flag = FALSE;              // ATR Pullstop Toggle
extern int                    PP_ATR_PS_stop = 10;                 // ATR Pullstop Stoploss
extern ENUM_TIMEFRAMES        PP_ATR_PS_Time = PERIOD_H1;          // ATR Time Frame
extern double                 PP_ATR_PS_level = 0.001;             // Minimum ATR level 



//+------------------------------------------------------------------+
//|        GLOBAL VARIABLES                                          |
//+------------------------------------------------------------------+
int PP_Signal_BuyCount = 0;
int PP_Signal_Required = 0;
int PP_Signal_SellCount =0;

int counter;
bool openOrder;
double PP_StopLoss;

bool buySignal1 = False; // ma cross
bool buySignal2 = False; // not used (was adx)
bool buySignal3 = False; // reversal signal
bool buySignal4 = False; // adx min & adx split (pullback entry)
bool buySignal5 = False; // adx split (market entry)
bool buySignal6 = False; 

bool sellSignal1 = False; // ma cross
bool sellSignal2 = False; // not used (was adx)
bool sellSignal3 = False; // reversal signal
bool sellSignal4 = False;
bool sellSignal5 = False;
bool sellSignal6 = False;

bool debug = false;
datetime LastActiontime;

double MyPoint;
int et;
int ycounter = 0;

bool CrossUncross = false;
bool buyhasCrossed = false;
bool sellhasCrossed = false;


//+------------------------------------------------------------------+
//|        INITIALIZATION FUNCTION                                   |
//+------------------------------------------------------------------+
int init()
{
   PP_Signal_Required = Fn_Signal_Required();
   MyPoint = Fn_Get_MyPoint();
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
   

   if (PP_Trailing_Flag) PP_Trailing_Flag();
   if (PP_Breakeven_Flag) PP_Breakeven_Flag();
   if (PP_PSAR_Trail) PP_PSAR_Trail();
   if (PP_Candle_trail_Flag) PP_Candle_trail_Flag();
   if (PP_HiLo_Trail_Flag) PP_HiLo_Trail_Flag();
   if (PP_ATR_Trail_Flag) PP_ATR_Trail_Flag();
   if (PP_MACD_PS_Flag) PP_MACD_PS_Flag();
   if (PP_ADX_PS_Flag) PP_ADX_PS_Flag();
   if (PP_PSAR_PS_Flag) PP_PSAR_PS_Flag();
   if (PP_RSI_PS_Flag)  PP_RSI_PS_Flag();
   if (PP_ATR_PS_Flag) PP_ATR_PS_Flag();
   
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
          if (OrderType() == OP_BUY && sellSignal1 && PP_Close_Signal)
            {
            closeBuyTrade();
            openOrder = false;
            }
        
         else if (OrderType() == OP_SELL && buySignal1 && PP_Close_Signal)
            {
            closeSellTrade();
            openOrder = false;
            }
         else if (OrderType() == OP_BUYLIMIT && sellSignal1)
            {
            DeletePendingOrder();
            openOrder = false;
            }   
         else if (OrderType() == OP_SELLLIMIT && buySignal1)
            {
            DeletePendingOrder();
            openOrder = false;
            }
         else if (OrderType() == OP_BUY && sellSignal3 && PP_WS_Type == 1)
             {
              closeBuyTrade();
              openOrder = false;
             }
         else if (OrderType() == OP_BUY && sellSignal3 && PP_WS_Type == 3)
             {
              closeBuyTrade();
              openOrder = false;
              placeSellUncross();
                            ycounter++;
                            Print ("Cross Uncross Counter = ", ycounter);  
             } 
         else if (OrderType() == OP_SELL && buySignal3 && PP_WS_Type == 1)
             {
              closeSellTrade();
              openOrder = false;
             }
         else if (OrderType() == OP_SELL && buySignal3 && PP_WS_Type == 3)
             {
              closeSellTrade();
              openOrder = false;
              placeBuyUncross();
                            ycounter++;
                            Print ("Cross Uncross Counter = ", ycounter);  
             } 
         else if (OrderType() == OP_SELLLIMIT && buySignal3 && (PP_WS_Type == 2 || PP_WS_Type == 1))
             {
              DeletePendingOrder();
              openOrder = false;
             }
         else if (OrderType() == OP_SELLLIMIT && buySignal3 && PP_WS_Type == 3)
             {
              DeletePendingOrder();
              openOrder = false;
              placeBuyUncross();
                            ycounter++;
                            Print ("Cross Uncross Counter = ", ycounter);  
             } 
         else if (OrderType() == OP_BUYLIMIT && sellSignal3 && (PP_WS_Type == 2 || PP_WS_Type == 1))
             {
              DeletePendingOrder();
              openOrder = false;
             }   
         else if (OrderType() == OP_BUYLIMIT && sellSignal3 && PP_WS_Type == 3)
             {
              DeletePendingOrder();
              openOrder = false;
              placeSellUncross();
                            ycounter++;
                            Print ("Cross Uncross Counter = ", ycounter);                     
             }


                 
      }
   

//--------NEW CODE HERE-----------
   if (!openOrder && !PP_ADX_Split_Flag)
   {

      if (PP_Signal_Required == 0 && buySignal1==true)
        {          
           placeBuy();
        }
     else if ((PP_Signal_BuyCount == PP_Signal_Required) && (buySignal1==true) && PP_Signal_Required>0)       
        {
           if (PP_PullBack_Long_Flag && !openOrder)
            {
               PP_PullBack_Buy();
            }
            else
            {
               placeBuy();
            }
        }
     else if ((PP_Signal_SellCount == PP_Signal_Required) && (sellSignal1==true) && PP_Signal_Required>0)
        {
           if (PP_PullBack_Short_Flag) 
            {
               PP_PullBack_Sell();
            }   
            else 
            {
               placeSell();
            }   
        }
     else if (PP_Signal_Required == 0 && sellSignal1==true)
        {             
           placeSell();
        }    
   }

 //=============================================  
   
   if (!openOrder && PP_ADX_Split_Flag)
   {

      if (buySignal1 && buySignal5)
        {          
           placeBuy();
        }
      else if ((PP_Signal_BuyCount == PP_Signal_Required) && buySignal1 && buySignal4)       
        {
           if (PP_PullBack_Long_Flag && !openOrder)
            {
               PP_PullBack_Buy();
            }
            else
            {
               placeBuy();
            }
        }
     else if ((PP_Signal_SellCount == PP_Signal_Required) && sellSignal1 && sellSignal4)
        {
           if (PP_PullBack_Short_Flag) 
            {
               PP_PullBack_Sell();
            }   
            else 
            {
               placeSell();
            }   
        }
     else if (sellSignal1 && sellSignal5)
        {             
           placeSell();
        }    
   }
  

   return(0);
}

 
//+------------------------------------------------------------------+
//|                     GENERATE MA CROSS SIGNAL                     |
//+------------------------------------------------------------------+
void generateSignals()
{
   double MAFastPrevious, MAFastCurrent;
   double MASlowPrevious, MASlowCurrent;   
   buySignal1 = false; //macross
   sellSignal1 = false; //macross
   buySignal2 = false; 
   sellSignal2 = false;
   buySignal3 = false;
   sellSignal3 = false;
   buySignal4 = false; //ADX between min and max for pullback
   sellSignal4 = false; //ADX between min and max for pullback
   buySignal5 = false; //ADX above min for market entry
   sellSignal5 = false; //ADX above min for market entry

   PP_Signal_BuyCount =0;
   PP_Signal_SellCount =0;  
   CrossUncross = false;
   
   MAFastCurrent=iMA(NULL,PP_MA_Fast_Time,PP_MA_Fast_Period,0,PP_MA_Fast_Method,PP_MA_Fast_Price,0); 
   MAFastPrevious=iMA(NULL,PP_MA_Fast_Time,PP_MA_Fast_Period,0,PP_MA_Fast_Method,PP_MA_Fast_Price,1); 
   MASlowPrevious=iMA(NULL,PP_MA_Slow_Time,PP_MA_Slow_Period,0,PP_MA_Slow_Method,PP_MA_Slow_Price,1); 
   MASlowCurrent=iMA(NULL,PP_MA_Slow_Time,PP_MA_Slow_Period,0,PP_MA_Slow_Method,PP_MA_Slow_Price,0); 
   


   if ((MAFastPrevious < MASlowPrevious) && (MAFastCurrent > MASlowCurrent))        //fast MA crosses up over slow MA
      {
      buySignal1 = true;
      }

   else if ((MAFastPrevious > MASlowPrevious) && (MAFastCurrent < MASlowCurrent))   //fast MA crosses down under slow MA
      {
      sellSignal1 = true;
      }   


  
   
  if (LastActiontime!=iTime (NULL,PP_WS_Time,0))                             //fast MA less than slow MA on open of candle only
     {
      if (MAFastCurrent < MASlowCurrent) 
         {
         sellSignal3 = true;                                                        
         }
                                                                                    //fast MA greater than slow MA on open of candle only
      else if (MAFastCurrent > MASlowCurrent) 
        {
         buySignal3 = true;
         }
  LastActiontime = iTime (NULL,PP_WS_Time,0);
      }  


//----------ADX SPLIT--------------- 
   
   if (PP_ADX_Split_Flag)
   {
      if (iADX(NULL,PP_ADX_Time,14,PRICE_CLOSE,MODE_MAIN,1) >= PP_ADXmin &&
         iADX(NULL,PP_ADX_Time,14,PRICE_CLOSE,MODE_MAIN,1)  <= PP_ADX_Split)   
            {
            buySignal4 = true;
            PP_Signal_BuyCount++;    
            }
      if (iADX(NULL,PP_ADX_Time,14,PRICE_CLOSE,MODE_MAIN,1) >= PP_ADXmin &&
         iADX(NULL,PP_ADX_Time,14,PRICE_CLOSE,MODE_MAIN,1)  <= PP_ADX_Split)   
            {
            sellSignal4 = true; 
            PP_Signal_SellCount++;
            }
      if (iADX(NULL,PP_ADX_Time,14,PRICE_CLOSE,MODE_MAIN,1) > PP_ADX_Split)
            {
            buySignal5 = true;
            }
      if (iADX(NULL,PP_ADX_Time,14,PRICE_CLOSE,MODE_MAIN,1) > PP_ADX_Split)
            {
            sellSignal5 = true; 
            }
   }         

//----------ADX SPLIT--------------- 


   
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
 //----------ATR FILTER---------------    
    if (PP_ATR_Flag) 
   {
      if (iATR (NULL,PP_ATR_Time,PP_ATR_Period,PP_ATR_Shift) >= PP_ATR_min)
         {
         PP_Signal_BuyCount++;
         PP_Signal_SellCount++;
         }

   }  
   }
   
        
//--------SIGNAL FILTER END-----------   
   

//   if (debug) Print("Buy ",buySignal1," ",buySignal2," Sell ",sellSignal1," ",sellSignal2);
}










 
 
 
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//|                     FUNCTIONS LIBRARY                                   
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 
 
 /*

Content:
1) Filter Flag Counter
2) Money Management
3) Get MyPoint
4) Pullback Expire Time
5) Cross Uncross Checker


---ORDER MANAGEMENT-------+
x) Open Buy               |
x) Open Pullback Buy      |
x) Open Sell              |
x) Open Pullback Sell     |
x) Close Buy              |
x) Close Sell             |
x) Delete Pending         |
--------------------------+

---TRAILING FEATURES------+
x) Normal Trailing        |
x) ATR Trailing           |
x) Hi-Lo Candle Trailing  |
x) Candle Trailing        |
x) PSAR Trailing          |
--------------------------+

---PULL STOP FEATURES-----+
x) ATR PullStop           |
x) RSI PullStop           |
x) PSAR PullStop          |
x) ADX PullStop           |
x) MACD PullStop          |
--------------------------+

x) Breakeven
x) 




 */
 
 
 
 
 
 
//+------------------------------------------------------------------+
//|                Filter Flag Counter                               |
//+------------------------------------------------------------------+ 
 int Fn_Signal_Required()
    {
    int SignalCount = 0;
      if (PP_ADX_Flag)SignalCount++;
      if (PP_MACD_Flag)SignalCount++;
      if (PP_SAR_Flag)SignalCount++;
      if (PP_RSI_Flag)SignalCount++;
      if (PP_ADX_Split_Flag)SignalCount++;
      if (PP_ATR_Flag)SignalCount++;  
    return (SignalCount);             
   }
   
   
//+------------------------------------------------------------------+
//|                    Money Management                              |
//+------------------------------------------------------------------+ 
 void Fn_Money_Management ()
 {
    if (PP_MM_Type ==1 && PP_StopLoss > 0)
      {
         PP_Lot_Size=NormalizeDouble(((AccountBalance()*(PP_Risk/100))/PP_StopLoss/10),2);         // Risk based on Stop Loss
      }
   if (PP_MM_Type ==2 && PP_Trailing_Stop > 0)
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
   if (PP_Lot_Size > PP_Lot_Max) PP_Lot_Size = PP_Lot_Max;
   return;
 }
   
//+------------------------------------------------------------------+
//|                        Get MyPoint                               |
//+------------------------------------------------------------------+ 
double Fn_Get_MyPoint()
 {  
   double PP_Point=Point;
    if(Digits==3 || Digits==5) PP_Point=Point*10;
    return (PP_Point);
   }   


//+------------------------------------------------------------------+
//|                    PullBack Expire Time                          |
//+------------------------------------------------------------------+ 
int Fn_PullbackExpiration()
{
   int expireTime;
   if (PP_Pullback_Expiration)
      {
         expireTime = TimeCurrent() + (PP_Pullback_exp_hrs*3600);
         }
   else expireTime = 0;
   return (expireTime);         
   }
   
   

      
  
  
   
//-----------------------------------------------------------------------------------------------------
//-----------------------------------------BEGIN ORDER MANAGEMENT--------------------------------------
//-----------------------------------------------------------------------------------------------------
   
//+------------------------------------------------------------------+
//|                     OPEN BUY ORDER                               |
//+------------------------------------------------------------------+
void placeBuy()
{
    
double SL_Lowest = Low[iLowest(NULL,PERIOD_H1,MODE_LOW,SL_candles_in_range,0)];
double ATR_SL = iATR(NULL,PERIOD_H1,PP_ATR_SL_period,PP_ATR_SL_Shift)*PP_ATR_SL_Multiplier;

if (PP_SL_Type == 0) PP_StopLoss = PP_Fixed_StopLoss;
if (PP_SL_Type == 1) PP_StopLoss = (Ask - (SL_Lowest - 5*MyPoint))/MyPoint;
if (PP_SL_Type == 2) PP_StopLoss = ATR_SL/MyPoint;

Fn_Money_Management();
          
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
//|                  OPEN PULLBACK BUY ORDER                         |
//+------------------------------------------------------------------+
void PP_PullBack_Buy()
{
    
double SL_Lowest = Low[iLowest(NULL,PERIOD_H1,MODE_LOW,SL_candles_in_range,0)];
double ATR_SL = iATR(NULL,PERIOD_H1,PP_ATR_SL_period,PP_ATR_SL_Shift)*PP_ATR_SL_Multiplier;

if (PP_SL_Type == 0) PP_StopLoss = PP_Fixed_StopLoss;
if (PP_SL_Type == 1) PP_StopLoss = (Ask - (SL_Lowest - 5*MyPoint))/MyPoint;
if (PP_SL_Type == 2) PP_StopLoss = ATR_SL/MyPoint;

Fn_Money_Management();
et = Fn_PullbackExpiration();
      
    double TheStopLoss=0;
    double TheTakeProfit=0;
    RefreshRates();
   int result=0;
   result=OrderSend(Symbol(),OP_BUYLIMIT,PP_Lot_Size,Ask-PP_PullBack_Long*MyPoint,PP_Slippage,0,0,"Project Pips",PP_MagicNumber,et,Blue);
    if (result > 0)
    {
         TheStopLoss=0;
         TheTakeProfit=0;
         if(PP_TakeProfit>0) TheTakeProfit=(Ask-PP_PullBack_Long*MyPoint)+PP_TakeProfit*MyPoint;
         if(PP_StopLoss>0) TheStopLoss=(Ask-PP_PullBack_Long*MyPoint)-PP_StopLoss*MyPoint;
         OrderSelect(result,SELECT_BY_TICKET);
         OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(TheStopLoss,Digits),NormalizeDouble(TheTakeProfit,Digits),et,Green);
        }
 }

//+------------------------------------------------------------------+
//|                     OPEN SELL ORDER                              |
//+------------------------------------------------------------------+
void placeSell()
{
    
double SL_Highest = High[iHighest(NULL,PERIOD_H1,MODE_HIGH,SL_candles_in_range,0)];
double ATR_SL = iATR(NULL,PERIOD_H1,PP_ATR_SL_period,PP_ATR_SL_Shift)*PP_ATR_SL_Multiplier;

if (PP_SL_Type == 0) PP_StopLoss = PP_Fixed_StopLoss;
if (PP_SL_Type == 1) PP_StopLoss = ((SL_Highest + 5*MyPoint) - Bid)/MyPoint;
if (PP_SL_Type == 2) PP_StopLoss = ATR_SL/MyPoint;

Fn_Money_Management();
        
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
//|                     OPEN PULLBACK SELL ORDER                     |
//+------------------------------------------------------------------+ 
void PP_PullBack_Sell()  
{
    
double SL_Highest = High[iHighest(NULL,PERIOD_H1,MODE_HIGH,SL_candles_in_range,0)];
double ATR_SL = iATR(NULL,PERIOD_H1,PP_ATR_SL_period,PP_ATR_SL_Shift)*PP_ATR_SL_Multiplier;

if (PP_SL_Type == 0) PP_StopLoss = PP_Fixed_StopLoss; 
if (PP_SL_Type == 1) PP_StopLoss = ((SL_Highest + 5*MyPoint) - Bid)/MyPoint;
if (PP_SL_Type == 2) PP_StopLoss = ATR_SL/MyPoint;

Fn_Money_Management();
et = Fn_PullbackExpiration();

    double TheStopLoss=0;
    double TheTakeProfit=0;
    RefreshRates();
   int result=0;
   result=OrderSend(Symbol(),OP_SELLLIMIT,PP_Lot_Size,Bid+PP_PullBack_Short*MyPoint,PP_Slippage,0,0,"Project Pips",PP_MagicNumber,et,Red);
    if (result > 0)
    {
         TheStopLoss=0;
         TheTakeProfit=0;
         if(PP_TakeProfit>0) TheTakeProfit=(Bid+PP_PullBack_Short*MyPoint)-PP_TakeProfit*MyPoint;
         if(PP_StopLoss>0) TheStopLoss=(Bid+PP_PullBack_Short*MyPoint)+PP_StopLoss*MyPoint;
         OrderSelect(result,SELECT_BY_TICKET);
         OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(TheStopLoss,Digits),NormalizeDouble(TheTakeProfit,Digits),et,Green);
        
     }
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
//|                     DELETE PENDING ORDERS                        |
//+------------------------------------------------------------------+ 
void DeletePendingOrder()
{
 RefreshRates();
 OrderDelete(OrderTicket()); 
}

//-----------------------------------------------------------------------------------------------------
//-----------------------------------------END ORDER MANAGEMENT----------------------------------------
//-----------------------------------------------------------------------------------------------------



//-----------------------------------------------------------------------------------------------------
//-----------------------------------------BEGIN TRAILING FEATURES-------------------------------------
//-----------------------------------------------------------------------------------------------------

//+------------------------------------------------------------------+
//|                     Normal Trailing Stop                         |
//+------------------------------------------------------------------+
void PP_Trailing_Flag()
 {

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
               if(Bid-OrderOpenPrice()>MyPoint*PP_Trailing_Start)
                 {
                  if(OrderStopLoss() + MyPoint*PP_Trailing_Step < Bid - MyPoint*PP_Trailing_Stop)
                    {
                     OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble((Bid-PP_Trailing_Stop*MyPoint),Digits),OrderTakeProfit(),0,Green);
                     
                    }
                 }
              }
           }
         else 
           {
            if(PP_Trailing_Stop>0)                             // check for trailing stop
              {                 
               if((OrderOpenPrice()-Ask)> MyPoint*PP_Trailing_Start)
                 {
                  if((OrderStopLoss() - MyPoint*PP_Trailing_Step > (Ask + MyPoint*PP_Trailing_Stop)) || (NormalizeDouble(OrderStopLoss(), Digits)==0))
                    {
                     OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble((Ask+MyPoint*PP_Trailing_Stop),Digits),OrderTakeProfit(),0,Red);
                     
                    }
                 }
              }
           }
        }
     }
} 

//+------------------------------------------------------------------+
//|                       ATR Trailing Stop                          |
//+------------------------------------------------------------------+
void PP_ATR_Trail_Flag()
 {

double ATR_trailing_stop = iATR(NULL,PP_ATR_Trail_Time,PP_ATR_Trail_Period,PP_ATR_Trail_Shift)*PP_ATR_Trail_Multiplier;

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
               if(Bid-OrderOpenPrice()>= PP_ATR_Trail_Start*MyPoint)
                 {
                  if(OrderStopLoss()<Bid-ATR_trailing_stop)
                    {
                     OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble((Bid-ATR_trailing_stop),Digits),OrderTakeProfit(),0,Green);
                     
                    }
                 }
              }
         else 
             {                 
               if(OrderOpenPrice()-Ask >= MyPoint*PP_ATR_Trail_Start)
                 {
                  if((OrderStopLoss()> Ask+ATR_trailing_stop) || (OrderStopLoss()==0))
                    {
                     OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble((Ask+ATR_trailing_stop),Digits),OrderTakeProfit(),0,Red);
                     
                    }
                 }
              }
           }
        }
 }            
 
//+------------------------------------------------------------------+
//|                     Hi-Lo Candle Trailing Stop                   |
//+------------------------------------------------------------------+
 void PP_HiLo_Trail_Flag()
 {
   double PeriodHighest = High[iHighest(NULL,PP_HiLo_Trail_Time,MODE_HIGH,PP_HiLo_Trail_candles_in_range,PP_HiLo_Trail_starting_candle)];
   double PeriodLowest  = Low[iLowest(NULL,PP_HiLo_Trail_Time,MODE_LOW,PP_HiLo_Trail_candles_in_range,PP_HiLo_Trail_starting_candle)];

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
               if(Bid-OrderOpenPrice()>= PP_HiLo_Trail_Start*MyPoint)
                 {
                  if(OrderStopLoss()< PeriodLowest - PP_HiLo_Trail_Offset*MyPoint)
                   {
                     if(Bid > PeriodLowest - PP_HiLo_Trail_Offset*MyPoint)
                    {
                     OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble((PeriodLowest - PP_HiLo_Trail_Offset*MyPoint),Digits),OrderTakeProfit(),0,Green);
                     
                    }
                 }
              }
             } 
         else 
            {                 
              if(OrderOpenPrice()-Ask >= PP_HiLo_Trail_Start*MyPoint)
                 {
                  if(OrderStopLoss()> PeriodHighest + PP_HiLo_Trail_Offset*MyPoint)
                   {
                    if(Ask < PeriodHighest + PP_HiLo_Trail_Offset*MyPoint)
                    {
                     OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble((PeriodHighest + PP_HiLo_Trail_Offset*MyPoint),Digits),OrderTakeProfit(),0,Red);
                     
                    }
                  }
                } 
              }
           }
        }
 }    

//+------------------------------------------------------------------+
//|                        Candle Trailing Stop                      |
//+------------------------------------------------------------------+
void PP_Candle_trail_Flag()
 {

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
               if(Bid-OrderOpenPrice()>= PP_Candle_trail_Start*MyPoint)
                 {
                  if(OrderStopLoss()< iLow (NULL,PP_Candle_trail_Time,PP_Candle_trail_Shift) - PP_Candle_trail_Offset*MyPoint)
                   {
                     if(Bid > iLow (NULL,PP_Candle_trail_Time,PP_Candle_trail_Shift) - PP_Candle_trail_Offset*MyPoint)
                    {
                     OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble((iLow (NULL,PP_Candle_trail_Time,PP_Candle_trail_Shift) - PP_Candle_trail_Offset*MyPoint),Digits),OrderTakeProfit(),0,Green);
                     
                    }
                 }
              }
             } 
         else 
            {                 
              if(OrderOpenPrice()-Ask >= PP_Candle_trail_Start*MyPoint)
                 {
                  if(OrderStopLoss()> iHigh (NULL,PP_Candle_trail_Time,PP_Candle_trail_Shift) + PP_Candle_trail_Offset*MyPoint)
                   {
                    if(Ask < iHigh (NULL,PP_Candle_trail_Time,PP_Candle_trail_Shift) + PP_Candle_trail_Offset*MyPoint)
                    {
                     OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble((iHigh (NULL,PP_Candle_trail_Time,PP_Candle_trail_Shift) + PP_Candle_trail_Offset*MyPoint),Digits),OrderTakeProfit(),0,Red);
                     
                    }
                  }
                } 
              }
           }
        }
 }  
 
 
//+------------------------------------------------------------------+
//|                     PSAR Trailing Stop                           |
//+------------------------------------------------------------------+
void PP_PSAR_Trail()
{

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
           if(Bid-OrderOpenPrice() >= PP_PSAR_Trail_Start*MyPoint)
           {
           if(iSAR(NULL,PP_PSAR_Trail_Time,PP_PSAR_Trail_Step,PP_PSAR_Trail_Maxstep,PP_PSAR_Trail_Candles_Back) < Ask)
           {
            if(iSAR(NULL,PP_PSAR_Trail_Time,PP_PSAR_Trail_Step,PP_PSAR_Trail_Maxstep,PP_PSAR_Trail_Candles_Back) > OrderStopLoss())
            {
             OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble((iSAR(NULL,0,PP_PSAR_Trail_Step,PP_PSAR_Trail_Maxstep,PP_PSAR_Trail_Candles_Back)),Digits),OrderTakeProfit(),0,Green); 
            }
          }
          }
           }
         else
         {    
          if(OrderOpenPrice()-Ask >= MyPoint*PP_PSAR_Trail_Start)
          {
           if(iSAR(NULL,PP_PSAR_Trail_Time,PP_PSAR_Trail_Step,PP_PSAR_Trail_Maxstep,PP_PSAR_Trail_Candles_Back) > Ask)
           {
             if(iSAR(NULL,PP_PSAR_Trail_Time,PP_PSAR_Trail_Step,PP_PSAR_Trail_Maxstep,PP_PSAR_Trail_Candles_Back) < OrderStopLoss())   
             {
               OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble((iSAR(NULL,0,PP_PSAR_Trail_Step,PP_PSAR_Trail_Maxstep,PP_PSAR_Trail_Candles_Back)),Digits),OrderTakeProfit(),0,Red);
                 }
             }
             }
          }
        }  
       }   
  }    
//-----------------------------------------------------------------------------------------------------
//-----------------------------------------END TRAILING------------------------------------------------
//-----------------------------------------------------------------------------------------------------




//-----------------------------------------------------------------------------------------------------
//-------------------------------------BEGIN PULLSTOP FEATURES-----------------------------------------
//-----------------------------------------------------------------------------------------------------

//+------------------------------------------------------------------+
//|                       ATR Pull Stop                              |
//+------------------------------------------------------------------+
void PP_ATR_PS_Flag()
{

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
         if(iATR(NULL,PP_ATR_PS_Time,14,2) < PP_ATR_PS_level && iATR (NULL,PP_ATR_PS_Time,14,1) > PP_ATR_PS_level)
          {
           if(OrderStopLoss() < Bid-PP_ATR_PS_stop*MyPoint)
            {
             OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble((Bid-PP_ATR_PS_stop*MyPoint),Digits),OrderTakeProfit(),0,Green);   
            }
          }
           }
         else
         {
          if(iATR(NULL,PP_ATR_PS_Time,14,2) < PP_ATR_PS_level && iATR (NULL,PP_ATR_PS_Time,14,1) > PP_ATR_PS_level)
            {
               if(OrderStopLoss() > Ask+PP_ATR_PS_stop*MyPoint) 
               {
                OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble((Ask+PP_ATR_PS_stop*MyPoint),Digits),OrderTakeProfit(),0,Red);
                }
             }
          }
        }  
       }   
  } 



//+------------------------------------------------------------------+
//|                        RSI Pull Stop                             |
//+------------------------------------------------------------------+
void PP_RSI_PS_Flag()
{

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
         if(iRSI(NULL,PP_RSI_PS_Time,14,PRICE_CLOSE,2) > PP_RSI_PS_high && iRSI(NULL,PP_RSI_PS_Time,14,PRICE_CLOSE,1) < PP_RSI_PS_high) 
          {
           if(OrderStopLoss() < Bid-PP_RSI_PS_stop*MyPoint)
            {
             OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble((Bid-PP_RSI_PS_stop*MyPoint),Digits),OrderTakeProfit(),0,Green);   
            }
          }
           }
         else
         {
          if(iRSI(NULL,PP_RSI_PS_Time,14,PRICE_CLOSE,2) < PP_RSI_PS_low && iRSI(NULL,PP_RSI_PS_Time,14,PRICE_CLOSE,1) > PP_RSI_PS_low)
            {
               if(OrderStopLoss() > Ask+PP_RSI_PS_stop*MyPoint) 
               {
                OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble((Ask+PP_RSI_PS_stop*MyPoint),Digits),OrderTakeProfit(),0,Red);
                }
             }
          }
        }  
       }   
  }        



//+------------------------------------------------------------------+
//|                      PSAR Pull Stop                              |
//+------------------------------------------------------------------+
void PP_PSAR_PS_Flag()
{

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
         if(iSAR(NULL,PP_PSAR_PS_Time,PP_PSAR_PS_step,PP_PSAR_PS_maxstep,2)<Ask && iSAR(NULL,PP_PSAR_PS_Time,PP_PSAR_PS_step,PP_PSAR_PS_maxstep,1)>Ask) 
          {
           if(OrderStopLoss() < Bid-PP_PSAR_PS_stop*MyPoint)
            {
             OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble((Bid-PP_PSAR_PS_stop*MyPoint),Digits),OrderTakeProfit(),0,Green);   
            }
          }
           }
         else
         {
         if(iSAR(NULL,PP_PSAR_PS_Time,PP_PSAR_PS_step,PP_PSAR_PS_maxstep,2)>Ask && iSAR(NULL,PP_PSAR_PS_Time,PP_PSAR_PS_step,PP_PSAR_PS_maxstep,1)<Ask)
            {
               if(OrderStopLoss() > Ask+PP_PSAR_PS_stop*MyPoint) 
               {
                OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble((Ask+PP_PSAR_PS_stop*MyPoint),Digits),OrderTakeProfit(),0,Red);
                }
             }
          }
        }  
       }   
  }   
  
  
//+------------------------------------------------------------------+
//|                       ADX Stall Pull Stop                        |
//+------------------------------------------------------------------+
void PP_ADX_PS_Flag()
{

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
           if(iADX(NULL,PP_ADX_PS_Time,14,PRICE_CLOSE,MODE_MAIN,2) > PP_ADX_PS_level && iADX(NULL,PP_ADX_PS_Time,14,PRICE_CLOSE,MODE_MAIN,1) < PP_ADX_PS_level)
             {
               if (OrderStopLoss() < Bid-PP_ADX_stop*MyPoint) 
               {
                OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble((Bid-PP_ADX_stop*MyPoint),Digits),OrderTakeProfit(),0,Green);  
                }
             }
           }
         else
         {
         if(iADX(NULL,PP_ADX_PS_Time,14,PRICE_CLOSE,MODE_MAIN,2) > PP_ADX_PS_level && iADX(NULL,PP_ADX_PS_Time,14,PRICE_CLOSE,MODE_MAIN,1) < PP_ADX_PS_level)
            {
               if(OrderStopLoss() > Ask+PP_ADX_stop*MyPoint) 
               {
                OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble((Ask+PP_ADX_stop*MyPoint),Digits),OrderTakeProfit(),0,Red);
                }
             }
          }
        }
      }
}


//+------------------------------------------------------------------+
//| MACD Pull StopLoss
//+------------------------------------------------------------------+
void PP_MACD_PS_Flag()
{
   double MACDmainPrevious, MACDmainCurrent; 
   double MACDsignalPrevious, MACDsignalCurrent; 
   MACDmainPrevious=iMACD(NULL,PP_MACD_PS_Time,PP_MACD_PS_fast,PP_MACD_PS_slow,PP_MACD_PS_signal,PRICE_CLOSE,MODE_MAIN,2); //main is fast
   MACDmainCurrent=iMACD(NULL,PP_MACD_PS_Time,PP_MACD_PS_fast,PP_MACD_PS_slow,PP_MACD_PS_signal,PRICE_CLOSE,MODE_MAIN,1);
   MACDsignalPrevious=iMACD(NULL,PP_MACD_PS_Time,PP_MACD_PS_fast,PP_MACD_PS_slow,PP_MACD_PS_signal,PRICE_CLOSE,MODE_SIGNAL,2); //signal is slow
   MACDsignalCurrent=iMACD(NULL,PP_MACD_PS_Time,PP_MACD_PS_fast,PP_MACD_PS_slow,PP_MACD_PS_signal,PRICE_CLOSE,MODE_SIGNAL,1);
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
           if(MACDmainPrevious > MACDsignalPrevious && MACDmainCurrent < MACDsignalCurrent) //sell signal
             {
               if (OrderStopLoss() < Bid-PP_MACD_PS_stop*MyPoint) 
               {
                OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble((Bid-PP_MACD_PS_stop*MyPoint),Digits),OrderTakeProfit(),0,Green);  
                }
             }
           }
         else
         {
         if(MACDmainPrevious < MACDsignalPrevious && MACDmainCurrent > MACDsignalCurrent) //buy signal
            {
               if(OrderStopLoss() > Ask+PP_MACD_PS_stop*MyPoint) 
               {
                OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble((Ask+PP_MACD_PS_stop*MyPoint),Digits),OrderTakeProfit(),0,Red);
                }
             }
          }
        }
      }
}
//-----------------------------------------------------------------------------------------------------
//-----------------------------------------END PULLSTOP FEATURES---------------------------------------
//-----------------------------------------------------------------------------------------------------


//+------------------------------------------------------------------+
//|                     GENERATE BREAKEVEN                           |
//+------------------------------------------------------------------+
void PP_Breakeven_Flag()
 {

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
                 OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble((OrderOpenPrice()+PP_Breakeven_LockIn*MyPoint),Digits),OrderTakeProfit(),0,Green);   
                  }
              }   
              }   
        else
         {
         if (OrderOpenPrice()-Ask > PP_Breakeven_Point*MyPoint)
            {
             if(OrderStopLoss() > (OrderOpenPrice()-PP_Breakeven_LockIn*MyPoint)) 
          {
            OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble((OrderOpenPrice()-PP_Breakeven_LockIn*MyPoint),Digits),OrderTakeProfit(),0,Red);
          }
       
         }  
         }
      }  
   }
}















   
//+------------------------------------------------------------------+
//|                    uncross OPEN BUY ORDER                               |
//+------------------------------------------------------------------+
void placeBuyUncross()
{
    
double SL_Lowest = Low[iLowest(NULL,PERIOD_H1,MODE_LOW,SL_candles_in_range,0)];
double ATR_SL = iATR(NULL,PERIOD_H1,PP_ATR_SL_period,PP_ATR_SL_Shift)*PP_ATR_SL_Multiplier;

if (PP_SL_Type == 0) PP_StopLoss = PP_Fixed_StopLoss;
if (PP_SL_Type == 1) PP_StopLoss = (Ask - (SL_Lowest - 5*MyPoint))/MyPoint;
if (PP_SL_Type == 2) PP_StopLoss = ATR_SL/MyPoint;

Fn_Money_Management();
          
    double TheStopLoss=0;
    double TheTakeProfit=0;
    RefreshRates();            
    int result=0;
    result=OrderSend(Symbol(),OP_BUYSTOP,PP_Lot_Size,High[1]+PP_Buy_Distance*MyPoint,PP_Slippage,0,0,"Project Pips",PP_MagicNumber,et,Blue);
        if(result>0)
        {
         TheStopLoss=0;
         TheTakeProfit=0;
         TheTakeProfit=(High[1]+PP_Buy_Distance*MyPoint)+PP_Rev_TakeProfit*MyPoint;
         TheStopLoss=(High[1]+PP_Buy_Distance*MyPoint)-PP_Rev_SL*MyPoint;
         OrderSelect(result,SELECT_BY_TICKET);
         OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(TheStopLoss,Digits),NormalizeDouble(TheTakeProfit,Digits),et,Green);
        }
        
        CrossUncross = false;
}


//+------------------------------------------------------------------+
//|                    uncross OPEN SELL ORDER                              |
//+------------------------------------------------------------------+
void placeSellUncross()
{
    
double SL_Highest = High[iHighest(NULL,PERIOD_H1,MODE_HIGH,SL_candles_in_range,0)];
double ATR_SL = iATR(NULL,PERIOD_H1,PP_ATR_SL_period,PP_ATR_SL_Shift)*PP_ATR_SL_Multiplier;

if (PP_SL_Type == 0) PP_StopLoss = PP_Fixed_StopLoss;
if (PP_SL_Type == 1) PP_StopLoss = ((SL_Highest + 5*MyPoint) - Bid)/MyPoint;
if (PP_SL_Type == 2) PP_StopLoss = ATR_SL/MyPoint;

Fn_Money_Management();
        
    double TheStopLoss=0;
    double TheTakeProfit=0;
   RefreshRates();
   int result=0;
   result=OrderSend(Symbol(),OP_SELLSTOP,PP_Lot_Size,Low[1]-PP_Sell_Distance*MyPoint,PP_Slippage,0,0,"Project Pips",PP_MagicNumber,et,Red);
        if(result>0)
        {
         TheStopLoss=0;
         TheTakeProfit=0;
        TheTakeProfit=(Low[1]-PP_Sell_Distance*MyPoint)-PP_Rev_TakeProfit*MyPoint;
        TheStopLoss=(Low[1]-PP_Sell_Distance*MyPoint)+PP_Rev_SL*MyPoint;
         OrderSelect(result,SELECT_BY_TICKET);
         OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(TheStopLoss,Digits),NormalizeDouble(TheTakeProfit,Digits),et,Green);
        }
        
        CrossUncross = false;
}

