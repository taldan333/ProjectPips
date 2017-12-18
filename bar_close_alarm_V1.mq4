//+------------------------------------------------------------------+
//|                                           bar-close-alarm_V1.mq4 |
//|                                                          by mibl |
//+------------------------------------------------------------------+
//
// Indicator gives a sound signal or message when the next bar closes 
// within the denoted Time
// Indicator only reacts on the refreshment time of the chart. There
// is no realtime function used to estimate the totally correct time.

#property copyright "Copyright © 2006, mibl"
#property indicator_chart_window

//---- input parameters
extern int MinutesBeforeCandleClose = 2;
extern bool AlarmWithBox = false;
extern string SoundWAV = "alert2.wav";

//---- buffers
int MsgOnFlag = 1;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
  }
   return(0);
  
  
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
	int min, sec;
	
   min = Time[0] + Period()*60 - CurTime();
   sec = min%60;
   min =(min - min%60) / 60;
   Comment("Balanced Time to next bar close: " + min + " min " + sec + " sec");
	
	//Message or Sound min minutes before the candle closes
	if(min < MinutesBeforeCandleClose && MsgOnFlag == 1)
	{
	  if(AlarmWithBox)
	  {
	     Alert("Less than " + min + " minute(s) " + sec + " second(s) to bar close!");  
	  }
	  else
	  {
	     PlaySound(SoundWAV);
	  }	  
	  MsgOnFlag = 0;
	}
	if(min > MinutesBeforeCandleClose) 
	{
	  MsgOnFlag = 1;
	}
	
   return(0);
  }
//+------------------------------------------------------------------+


