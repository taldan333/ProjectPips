///////////////////////////////////////////////////////
// George Egroeg (C) 2006 e-m: egro1egro at yahoo dot com
// aka "egro1egro"
//
// "Support/resistance lines" Version 3.0
//
///////////////////////////////////////////////////////
// The package contains two files:
// 1. S_R_lines.mq4 (script) should be placed into experts/indicators folder
// 2. S_R_lines.tpl (chart template) should be placed into templates folder
///////////////////////////////////////////////////////
// This indicator has only one parameter: lineIndex = 1,...,20
// In order to make it work you will have to place 20 indicators 
// all with different parameter values. A chart template
// with 20 indicators of this type is included for
// your convenience.
//
// There are two global variable that you might want to set before running this script:
//
// "sr_last_screens" - number of last screens to start drawing s/r lines from
// One screen is assumed to have 150 bars/candles
// If you specify global value 2 it will mean that 300 candles back s/r lines 
// can be started only. Using this parameter should improve performance significantly.
//
// "sr_spread_multiple" - number of (Bid-Ask) spreads to use as a delta when merging two s/r 
// lines together. If you specify value 2 and current spread is 0.0003 then two lines within 
// 6 pips will be merged into one. You might want to increase this parameter if you are 
// planning to use bigger time-frames (for instance, for hourly charts you might need 5-10 
// spreads to use as a delta in order to unclutter the screen). By default, it is set to 1.5 spreads.
//
// !!! After applying global variables or after recompiling this script it is necessary to
// de-select the chart template and then select it again to apply a new.
//
// Also, some parameters are defined as constants in the code
// and can be changed sensibly. These parameters cannot be made external
// because they need to be exactly the same on all instances of the indicator.
//
// MAX_NUM_LINES is a number of indicators on a chart
// If you think that 20 is overkill try to reduce this constant and
// accordingly delete some of the indicators from the chart template
// It might be enough to have 10, but if you notice that some lines are 
// not drawn where they should be - increase the number (make it even bigger than 20)
// The point is - always maintain the same number of indicators 
// on the chart al with different indices
//
// MAX_PERCENT_OUT is how far from the last price potential s/r lines 
// should be maintained (I think 3% is quite enough for intraday, but...)
//
// DELTA_PERIODS a number of candles/bars after which s/r lines "expire"
// indicator script discards old line and stops drawing them to the right.
//
// DEFAULT_NUM_SCREENS how many screens back shell we start the first s/r line
// if the global variable "sr_last_screens" is not defined or invalid
///////////////////////////////////////////////////////
#property copyright "George Egroeg (egro1egro at yahoo dot com)"

#property indicator_chart_window
#property indicator_buffers 8

#property indicator_color1 Green
#property indicator_color2 Green
#property indicator_color3 Green
#property indicator_color4 Green

#property indicator_color5 Red
#property indicator_color6 Red
#property indicator_color7 Red
#property indicator_color8 Red

// maximum number of support/resistance line pairs
#define MAX_NUM_LINES      5
#define MAX_NUM_LINES_REAL 20 // has to be exactly 4 times the previous number

// max deviation from current price
#define MAX_PERCENT_OUT    3.0

// 2 lines within (Bid-Ask)* DELTA_SPREAD_MULTIPLE are merged into one
#define DELTA_SPREAD_MULTIPLE 1.5

#define DELTA_PERIOD       600

// 10 screens back from now with 150 bars/canldes in each - the very first s/r/ line can possibly start
#define DEFAULT_NUM_SCREENS 10

//////////////////////////////////////////////////////////////////////////////
// the following constants are for internal use and should not be changed
//////////////////////////////////////////////////////////////////////////////
// number of bars left behind in a fractal
#define NUM_BARS_FRACTAL   2
// constants that denote empty values (i.e. don't draw if empty)
#define LINE_EMPTY_VALUE   0.0
#define FRACTAL_EMPTY_VALUE 0.0
#define DATE_EMPTY_VALUE 0 // 0 am 1 Jan 1970
#define NUM_BARS_SCREEN 150 // number of bars in a screen normally


// which one of s/r pair of lines to show (can be from 1 to 20)
extern int lineIndex = 1;

double lineDelta = 0.0005;

//---- buffers
double resLine1[];
double resLine2[];
double resLine3[];
double resLine4[];

double suppLine1[];
double suppLine2[];
double suppLine3[];
double suppLine4[];


// list of resistance lines
// we maintain the whole list of them but use only the requested one
double upper_f[MAX_NUM_LINES_REAL]; // f is for tracking previous fractal values (hi/lo of candles)
double upper_l[MAX_NUM_LINES_REAL]; // l is for tracking previous r/s lines levels (open/close of candles)
datetime upper_s[MAX_NUM_LINES_REAL]; // s is for tracking start time of s/r lines

// queue of support lines
double lower_f[MAX_NUM_LINES_REAL];
double lower_l[MAX_NUM_LINES_REAL];
datetime lower_s[MAX_NUM_LINES_REAL];

double valHigh = LINE_EMPTY_VALUE;
double valLow = LINE_EMPTY_VALUE;

datetime startTime = DATE_EMPTY_VALUE;
double deltaSpreadMultiple = DELTA_SPREAD_MULTIPLE;

// loop variable
int i;
int j;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+  

void initRunningLists()
{
   for(j = 0; j < MAX_NUM_LINES_REAL; j++)
   {
      upper_f[j] = LINE_EMPTY_VALUE;
      upper_l[j] = LINE_EMPTY_VALUE;
      upper_s[j] = DATE_EMPTY_VALUE;
      lower_f[j] = LINE_EMPTY_VALUE;
      lower_l[j] = LINE_EMPTY_VALUE;
      lower_s[j] = DATE_EMPTY_VALUE;
   }
}

int init()
  {
  // adjust input values
  if ( lineIndex < 1 )
   lineIndex = 1;
  if ( lineIndex > MAX_NUM_LINES )
   lineIndex = MAX_NUM_LINES;
   
  j = (lineIndex-1)*4;
//----  
   SetIndexStyle(0, DRAW_LINE, STYLE_SOLID, 1, Green);
   SetIndexEmptyValue(0, LINE_EMPTY_VALUE);
   SetIndexDrawBegin(0, 1);
   SetIndexBuffer(0, resLine1);
   SetIndexLabel(0,"Resistance " + (j + 1));
   
   SetIndexStyle(1, DRAW_LINE, STYLE_SOLID, 1, Green);
   SetIndexEmptyValue(1, LINE_EMPTY_VALUE);
   SetIndexDrawBegin(1, 1);
   SetIndexBuffer(1, resLine2);
   SetIndexLabel(1,"Resistance " + (j + 2));
   
   SetIndexStyle(2, DRAW_LINE, STYLE_SOLID, 1, Green);
   SetIndexEmptyValue(2, LINE_EMPTY_VALUE);
   SetIndexDrawBegin(2, 1);
   SetIndexBuffer(2, resLine3);
   SetIndexLabel(2,"Resistance " + (j + 3));
   
   SetIndexStyle(3, DRAW_LINE, STYLE_SOLID, 1, Green);
   SetIndexEmptyValue(3, LINE_EMPTY_VALUE);
   SetIndexDrawBegin(3, 1);
   SetIndexBuffer(3, resLine4);
   SetIndexLabel(3,"Resistance " + (j + 4));
//----    
   SetIndexStyle(4,DRAW_LINE, STYLE_SOLID,1, Red);
   SetIndexEmptyValue(4, LINE_EMPTY_VALUE);
   SetIndexDrawBegin(4,1);
   SetIndexBuffer(4, suppLine1);
   SetIndexLabel(4,"Support " + (j + 1));
   
   SetIndexStyle(5,DRAW_LINE, STYLE_SOLID,1, Red);
   SetIndexEmptyValue(5, LINE_EMPTY_VALUE);
   SetIndexDrawBegin(5,1);
   SetIndexBuffer(5, suppLine2);
   SetIndexLabel(5,"Support " + (j + 2));
   
   SetIndexStyle(6,DRAW_LINE, STYLE_SOLID,1, Red);
   SetIndexEmptyValue(6, LINE_EMPTY_VALUE);
   SetIndexDrawBegin(6,1);
   SetIndexBuffer(6, suppLine3);
   SetIndexLabel(6,"Support " + (j + 3));
   
   SetIndexStyle(7,DRAW_LINE, STYLE_SOLID,1, Red);
   SetIndexEmptyValue(7, LINE_EMPTY_VALUE);
   SetIndexDrawBegin(7,1);
   SetIndexBuffer(7, suppLine4);
   SetIndexLabel(7,"Support " + (j + 4));
   
   IndicatorShortName("S/R lines " + lineIndex);
      
   if ( GlobalVariableCheck("sr_last_screens") )
   {
      double sn = GlobalVariableGet("sr_last_screens");
      if ( sn > 0 )
      {
         startTime = TimeCurrent() - (Period() * 60 * sn * NUM_BARS_SCREEN);
      }
      else
      {
         startTime = TimeCurrent() - (Period() * 60 * DEFAULT_NUM_SCREENS * NUM_BARS_SCREEN);
      }
   }
   else
      startTime = TimeCurrent() - (Period() * 60 * DEFAULT_NUM_SCREENS * NUM_BARS_SCREEN);
   
   if ( GlobalVariableCheck("sr_spread_multiple") )
   {
      double sm = GlobalVariableGet("sr_spread_multiple");
      if ( sm > 0 )
          deltaSpreadMultiple = sm;
      else
          deltaSpreadMultiple = DELTA_SPREAD_MULTIPLE;
   }
   
   initRunningLists();
   
//---- 
   return(0);
  }
  
 double myFractal(int mode, int shift)
 {
   if ( (shift < 2) || (shift > (Bars - 2)) )
      return (0.0);
      
   if ( NUM_BARS_FRACTAL > 2 )
      return (iFractals(NULL, 0, mode, shift));
   
   // need to compare High of (shift-1, shift, shift+1)
   if ( mode == MODE_UPPER )
   {
      if ( (High[shift] >= High[shift-1]) && (High[shift] >= High[shift+1]) )
        return(High[shift]);
        
      /*
      // check right side
      int k = shift - 1;
      while( (k >= 0) && (High[k] == High[shift]) )
      {
         k--;
      }
      if ( k >= 0 && (High[k] > High[shift]) )
         return (0.0);
       
      // now check left side  
      k = shift + 1;
      while( (k < Bars) && (High[k] == High[shift]) )
      {
         k++;
      }
      if ( (k < Bars) && (High[k] > High[shift]) )
         return (0.0);
         
      return (High[shift]);
      */
   }
   else
   {
      if ( (Low[shift] <= Low[shift-1]) && (Low[shift] <= Low[shift+1]) )
         return(Low[shift]);
       
      /*
      // check right side
      k = shift - 1;
      while( (k >= 0) && (Low[k] == Low[shift]) )
      {
         k--;
      }
      if ( k >= 0 && (Low[k] < Low[shift]) )
         return (0.0);
       
      // now check left side  
      k = shift + 1;
      while( (k < Bars) && (Low[k] == Low[shift]) )
      {
         k++;
      }
      if ( (k < Bars) && (Low[k] > Low[shift]) )
         return (0.0);
         
      return (Low[shift]);
      */
   }
   
   return (0.0);
 }

double updateViewResistance(int li, double vhPrevious, double NewLow)
{
     if ( upper_s[li] == DATE_EMPTY_VALUE )
     {
         // no line no picture
         return (LINE_EMPTY_VALUE);
     }
     else
     {
        // new line can be cancelled if a candle has printed over it
        if ( NewLow > (upper_l[li] + lineDelta) )
        {
            upper_f[li] = LINE_EMPTY_VALUE;
            upper_l[li] = LINE_EMPTY_VALUE;
            upper_s[li] = DATE_EMPTY_VALUE;
            return (LINE_EMPTY_VALUE);
        }
        else
        {
            // we have a line but if we have an old line we will have to cancel it first
            if ( vhPrevious != LINE_EMPTY_VALUE )
            {
                // we have a line already
                if ( vhPrevious != upper_l[li] ) // got a new line instead now
                    return (LINE_EMPTY_VALUE); // cancel the old one
                else
                    return (vhPrevious); // continue the same old one
            }
            else
            {
                return (upper_l[li]); // start a new one here
            }
         
         }
     }
}
  
double updateViewSupport(int li, double vlPrevious, double NewHigh)
{
     if ( lower_s[li] == DATE_EMPTY_VALUE )
     {
         // no line no picture
         return (LINE_EMPTY_VALUE);
     }
     else
     {
        // new line can be cancelled if a candle has printed over it
        if ( NewHigh < (lower_l[li] - lineDelta) )
        {
            lower_f[li] = LINE_EMPTY_VALUE;
            lower_l[li] = LINE_EMPTY_VALUE;
            lower_s[li] = DATE_EMPTY_VALUE;
            return (LINE_EMPTY_VALUE);
        }
        else
        {
            // we have a line but if we have an old line we will have to cancel it first
            if ( vlPrevious != LINE_EMPTY_VALUE )
            {
                // we have a line already
                if ( vlPrevious != lower_l[li] ) // got a new line instead now
                    return (LINE_EMPTY_VALUE); // cancel the old one
                else
                    return (vlPrevious); // continue the same old one
            }
            else
            {
                return(lower_l[li]); // start a new one here
            }
         
         }
     }
}
 
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
{
   initRunningLists();
   
   lineDelta = MathAbs(Ask - Bid) * deltaSpreadMultiple;
   
   int td1 = MathAbs(Time[Bars-1] - Time[Bars-2]); // number of seconds in one period
   int td = td1 * DELTA_PERIOD;
   
   i = Bars-1;
   
   // skip old dates
   while( (i >= 0) && (Time[i] < startTime) )
   {
      i--;
   }
   
   while( i >= 0 )
   { 
       double rangeMax = Close[i] * ( 1.0 + (MAX_PERCENT_OUT/100.0) );
       double rangeMin = Close[i] * ( 1.0 - (MAX_PERCENT_OUT/100.0) );
       datetime t = Time[i];

        // when fractal function returns non-zero value we get a new potential resistance line
       valHigh = myFractal(MODE_UPPER, i);
       
       double body_max = MathMax(Close[i], Open[i]);
        
       if ( valHigh > FRACTAL_EMPTY_VALUE )
       {
         // fractal is getting reported only on the very last bar of it
         // so we need to select the highest body top out of 5 bars
         
         for(j = MathMin((i + NUM_BARS_FRACTAL - 1), Bars); j >= MathMax((i - NUM_BARS_FRACTAL + 1),0); j--)
         {
             if ( body_max < MathMax(Close[j], Open[j]) )
               body_max = MathMax(Close[j], Open[j]);
         }
         j = MathMax((i - NUM_BARS_FRACTAL),0);
         while( (j >= 0) && (MathMax(Close[j], Open[j]) < valHigh) && (MathMax(Close[j], Open[j]) > body_max) )
         {
             body_max = MathMax(Close[j], Open[j]);
             j--;
         }
       }
       
       valLow = myFractal(MODE_LOWER, i);
       
       double body_min = MathMin(Close[i], Open[i]);
       if ( valLow > FRACTAL_EMPTY_VALUE )
       {
         // fractal is getting reported only on the very last bar of it
         // so we need to select the highest body top out of 5 bars
         for(j = MathMin((i + NUM_BARS_FRACTAL - 1), Bars); j >= MathMax((i - NUM_BARS_FRACTAL + 1),0); j--)
         {
           if ( body_min > MathMin(Close[j], Open[j]) )
             body_min = MathMin(Close[j], Open[j]);
         } 
         j = MathMax((i - NUM_BARS_FRACTAL),0);
         while( (j >= 0) && (MathMin(Close[j], Open[j]) > valLow) && (MathMin(Close[j], Open[j]) < body_min) )
         {
             body_min = MathMin(Close[j], Open[j]);
             j--;
         }
       }
       
     // First, cancel old resistance lines because of overlapping
     for(j = 0; j < MAX_NUM_LINES_REAL; j++ )
     {
       if ( ((upper_l[j] /*+ lineDelta*/) < body_max) 
           || (upper_l[j] > rangeMax) 
           || ((upper_s[j] + td) < t)
           )
       {
         upper_f[j] = LINE_EMPTY_VALUE; // cancel the item
         upper_l[j] = LINE_EMPTY_VALUE;
         upper_s[j] = DATE_EMPTY_VALUE;
       }
     }
     
     if ( valHigh > FRACTAL_EMPTY_VALUE ) 
     {

       // Next, cancel old resistance lines because of new fractals
       for(j = 0; j < MAX_NUM_LINES_REAL; j++ )
       {
         if (upper_f[j] < valHigh)
         {
           upper_f[j] = LINE_EMPTY_VALUE; // cancel the item
           upper_l[j] = LINE_EMPTY_VALUE;
           upper_s[j] = DATE_EMPTY_VALUE;
         }
       }
       
       bool bExistsAlready = false;
       for(j = 0; j < MAX_NUM_LINES_REAL; j++)
       {
          if ( upper_f[j] != LINE_EMPTY_VALUE )
          {
            if ( ((upper_l[j] - lineDelta) < body_max) 
                && ((upper_l[j] + lineDelta) > body_max) )
            {
              bExistsAlready = true;
              break;
            }
          }
       }
       
       // if we have a new fractal up - insert a new s/r line
       if ( !bExistsAlready )
       {
         for(j = 0; j < MAX_NUM_LINES_REAL; j++)
         {
           if ( upper_f[j] == LINE_EMPTY_VALUE )
           {
             upper_f[j] = valHigh;
             upper_l[j] = body_max;
             upper_s[j] = t;
             break;
           }
         }
       }
     }     

     // First, cancel old s/r lines because of candle-overlapping
     for(j = 0; j < MAX_NUM_LINES_REAL; j++ )
     {
       if ( ((lower_l[j] /*- lineDelta*/) > body_min) 
           || (lower_l[j] < rangeMin) 
           || ((lower_s[j] + td) < t)
           )
       {
         lower_f[j] = LINE_EMPTY_VALUE; // cancel the item
         lower_l[j] = LINE_EMPTY_VALUE;
         lower_s[j] = DATE_EMPTY_VALUE;
       }
     }
     
     if ( valLow > FRACTAL_EMPTY_VALUE ) 
     {

       // First, cancel old resistance lines
       for(j = 0; j < MAX_NUM_LINES_REAL; j++)
       {
         if (lower_f[j] > valLow)
         {
           lower_f[j] = LINE_EMPTY_VALUE; // cancel the item
           lower_l[j] = LINE_EMPTY_VALUE;
           lower_s[j] = DATE_EMPTY_VALUE;
         }
       }
       
       bExistsAlready = false;
       for(j = 0; j < MAX_NUM_LINES_REAL; j++)
       {
          if ( lower_f[j] != LINE_EMPTY_VALUE )
          {
            if ( ((lower_l[j] - lineDelta) < body_min) 
               && ((lower_l[j] + lineDelta) > body_min) )
            {
              bExistsAlready = true;
              break;
            }
          }
       }
       
       // if we have a new fractal down - insert a new s/r line
       if ( !bExistsAlready )
       {
         for(j = 0; j < MAX_NUM_LINES_REAL; j++)
         {
           if ( lower_f[j] == LINE_EMPTY_VALUE )
           {
             lower_f[j] = valLow;
             lower_l[j] = body_min;
             lower_s[j] = t;
             break;
           }
         }
       }
     }  

     j = (lineIndex-1)*4;
     resLine1[i]  = updateViewResistance(j, resLine1[i+1], Low[i]);
     resLine2[i]  = updateViewResistance(j+1, resLine2[i+1], Low[i]);
     resLine3[i]  = updateViewResistance(j+2, resLine3[i+1], Low[i]);
     resLine4[i]  = updateViewResistance(j+3, resLine4[i+1], Low[i]);
     
     suppLine1[i] = updateViewSupport(j, suppLine1[i+1], High[i]);
     suppLine2[i] = updateViewSupport(j+1, suppLine2[i+1], High[i]);
     suppLine3[i] = updateViewSupport(j+2, suppLine3[i+1], High[i]);
     suppLine4[i] = updateViewSupport(j+3, suppLine4[i+1], High[i]);

     i--;
   }   
   return(0);
}
//+------------------------------------------------------------------+