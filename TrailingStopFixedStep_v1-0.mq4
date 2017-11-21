//+------------------------------------------------------------------+
//|                                   TrailingStopFixedStep_v1-0.mq4 |
//|                                                    Luca Spinello |
//|                                https://mql4tradingautomation.com |
//+------------------------------------------------------------------+
#property copyright     "Luca Spinello - mql4tradingautomation.com"
#property link          "https://mql4tradingautomation.com"
#property version       "1.00"
#property strict
#property description   "This EA moves the stop loss using a fixed step expressed in pips"
#property description   " "
#property description   "DISCLAIMER: This code comes with no guarantee, you can use it at your own risk"
#property description   "We recommend to test it first on a Demo Account"

/*

Example - BUY order EURUSD open price 1.2670, Stop Loss 1.2620, Take Profit 1.2710, StopLossStep 20, StopLossMove 10 and MoveTakeProfitToo True
When price reaches 1.2620+20=1.2640 the stop loss will be moved of 10 pips to 1.2620+10=1.2630, Take profit same will be moved to 1.2710+10=1.2720
When price reaches 1.2630+20=1.2650 the stop loss will be moved of 10 pips to 1.2630+10=1.2640, Take profit same will be moved to 1.2720+10=1.2730
and so on until the stop loss is hit, in case MoveTakeProfitToo is false the Take Profit will not be changed

Example - SELL order EURUSD open price 1.2670, Stop Loss 1.2720, Take Profit 1.2620, StopLossStep 20, StopLossMove 10 and MoveTakeProfitToo True
When price reaches 1.2720-20=1.2700 the stop loss will be moved of 10 pips to 1.2720-10=1.2710, Take profit same will be moved to 1.2620-10=1.2610
When price reaches 1.2710-20=1.2690 the stop loss will be moved of 10 pips to 1.2710-10=1.2700, Take profit same will be moved to 1.2610-10=1.2600
and so on until the stop loss is hit, in case MoveTakeProfitToo is false the Take Profit will not be changed

*/

//Configure the external variables
extern double StopLossStep=20;            //Price distance from original set Stop Loss in pips
extern double StopLossMove=10;            //Number of pips to move the Stop Loss forward
extern bool MoveTakeProfitToo=true;    //Move also the Take Profit price of the number of pips above
extern bool OnlyMagicNumber=false;     //Modify only orders matching the magic number
extern int MagicNumber=0;              //Matching magic number
extern bool OnlyWithComment=false;     //Modify only orders with the following comment
extern string MatchingComment="";      //Matching comment
extern double Slippage=2;              //Slippage
extern int Delay=0;                    //Delay to wait between modifying orders (in milliseconds)

//Flag to check if code can be run
bool CanExecute=true;

//Digits normalized
double nDigits;




//Function to normalize the digits
double CalculateNormalizedDigits()
{
   if(Digits<=3){
      return(0.01);
   }
   else if(Digits>=4){
      return(0.0001);
   }
   else return(0);
}



void Initialize(){

   //Normalization of the digits
   nDigits=CalculateNormalizedDigits();
   if(Digits==3 || Digits==5){
      Slippage=Slippage*10;
   }
   StopLossMove=StopLossMove*nDigits;
   StopLossStep=StopLossStep*nDigits;
}

//Function to Scan and Update the orders
void UpdatePositions(){

   //Scan the open orders backwards
   for(int i=OrdersTotal()-1; i>=0; i--){
   
      //Select the order, if not selected print the error and continue with the next index
      if( OrderSelect( i, SELECT_BY_POS, MODE_TRADES ) == false ) {
         Print("ERROR - Unable to select the order - ",GetLastError());
         continue;
      } 
      
      //Check if the order can be modified matching the criteria, if criteria not matched skip to the next
      if(OrderSymbol()!=Symbol()) continue;
      if(OnlyMagicNumber && OrderMagicNumber()!=MagicNumber) continue;
      if(OnlyWithComment && StringCompare(OrderComment(),MatchingComment)!=0) continue;
      
      //Prepare the prices
      double TakeProfitPrice=OrderTakeProfit();
      double StopLossPrice=OrderStopLoss();
      double OpenPrice=OrderOpenPrice();
      double NewStopLossPrice=StopLossPrice;
      double NewTakeProfitPrice=TakeProfitPrice;
      
      //Get updated prices and calculate the new Stop Loss and Take Profit levels, these depends on the type of order
      RefreshRates();
      if(OrderType()==OP_BUY){
         if(Bid>StopLossPrice+StopLossStep){
            NewStopLossPrice=NormalizeDouble(StopLossPrice+StopLossMove,Digits);
            if(MoveTakeProfitToo) NewTakeProfitPrice=NormalizeDouble(TakeProfitPrice+StopLossMove,Digits);
            else NewTakeProfitPrice=TakeProfitPrice;
            if(!MoveTakeProfitToo && NewStopLossPrice>TakeProfitPrice) continue;
         }
      } 
      if(OrderType()==OP_SELL){
         if(Ask<StopLossPrice-StopLossStep){
            NewStopLossPrice=NormalizeDouble(StopLossPrice-StopLossMove,Digits);
            if(MoveTakeProfitToo) NewTakeProfitPrice=NormalizeDouble(TakeProfitPrice-StopLossMove,Digits);
            else NewTakeProfitPrice=TakeProfitPrice;
            if(!MoveTakeProfitToo && NewStopLossPrice<TakeProfitPrice) continue;
         }
      }
      
      //If the new Stop Loss and Take Profit Levels are different from the previous then I try to update the order
      if(NewStopLossPrice!=StopLossPrice && NewTakeProfitPrice!=TakeProfitPrice && NewStopLossPrice>0 && NewTakeProfitPrice>0){
         Print("Modifying order ",OrderTicket()," Open Price ",OpenPrice," New Stop Loss ",NewStopLossPrice," New Take Profit ",NewTakeProfitPrice);
         if(OrderModify(OrderTicket(),OpenPrice,NewStopLossPrice,NewTakeProfitPrice,0,Yellow)){
            Print("Order modified");
         }
         else{
            Print("Order failed to update with error - ",GetLastError());
         }      
      
      }
      
      //Wait a delay
      Sleep(Delay);
   
   }
}



//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   if(StopLossMove>=StopLossStep) CanExecute=false;
   if(StopLossMove<=Slippage) CanExecute=false;
   if(CanExecute==false) Print("Check parameters, the move must be greater than the step and smaller than the slippage");
   Initialize();
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   
   //If the pre-checks are passed I can proceed with the trailing stop
   if(CanExecute){
      UpdatePositions();
   }
   
  }
//+------------------------------------------------------------------+
