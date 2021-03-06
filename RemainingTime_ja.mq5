//+------------------------------------------------------------------+
//|                                              ReminingTime_ja.mq4 |
//|                                                      googolyenfx |
//|                               http://googolyenfx.blog18.fc2.com/ |
//+------------------------------------------------------------------+
#property copyright "googolyenfx"
#property link      "http://googolyenfx.blog18.fc2.com/"

#property indicator_chart_window

string ReminingTime_sname = "bars_remining_time";
input string memo="0=LU,1=LL,2=RL,3=RU";
input int Corner = 3;
input double LocationX = 10;
input double LocationY = 15;
input int FontSize = 9;
input int WarnSeconds = 30;
input string FontName = "Segoe UI Semibold";  //"Segoe UI" "Console" "ＭＳ ゴシック"　"ＭＳ 明朝" "HG行書体" "GungsuhChe"
input color FontColor = Black;
input color FontColorWaning = Coral;
input double spread_mult = 0; // Spread nanbai?
input bool display_digits = false; // Display Digits?

double g;
double sp;
//int m, s, k, h, total_sec;
int m,m2, s,s2, k, h, total_sec;
string text;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
//---- indicators
  EventSetMillisecondTimer(200);
//----
  return(0);
}
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
//int deinit()
//  {
//	ObjectDelete(0,ReminingTime_sname);
//   return(0);
//  }
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
	ObjectDelete(0,ReminingTime_sname);
}
//+------------------------------------------------------------------+
void draw_remaining_time()
{
  if(Period() < PERIOD_H1){
  	m = iTime(NULL,0,0) + Period()*60 - TimeCurrent(); // convert to sec
   	m2 = iTime(NULL,0,0) + Period()*60 - TimeLocal();
  }else if(PERIOD_H1 <= Period()){
  	m = iTime(NULL,0,0) + (Period()-16384)*3600 - TimeCurrent();
   	m2 = iTime(NULL,0,0) + (Period()-16384)*3600 - TimeLocal();
  }
	g = m/60.0;
	s = m%60;
	s2 = m2%60; if(s2<0)s2+=60;
  while(s < 0 || m < 0){
    m = m + Period()*60;
    s = m%60;
  }

  double Bid = SymbolInfoDouble(_Symbol,SYMBOL_BID); 
  double Ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK); 

  m = (m - m%60) / 60;
  if (0 < spread_mult){
    sp = (Ask - Bid)*spread_mult;
	}else{
    sp = (Ask - Bid)*pow(10,Digits()-1);
	}
	
	if (Period() <= PERIOD_H1) {
    if(display_digits){
  		text = "Next bar : " + m + " min " + s +"("+s2+ ")sec, sp: " +  DoubleToString(sp, 1) + " digi:" + Digits();
    }else{
  		//text = "Next bar : " + m + " min " + s +"("+s2+ ")sec, sp: " + DoubleToString(sp, 1) + " peri "+Period();
  		text = "Next bar : " + m + " min " + s +"("+s2+ ")sec, sp: " + DoubleToString(sp, 1);
    //  		text = "Next bar : " + m + " min " + s + " sec, sp: " +  DoubleToString(sp, 1) + " digi:" + Digits();
    //  }else{
    // 		text = "Next bar : " + m + " min " + s + " sec, sp: " + DoubleToString(sp, 1);
    }
    total_sec = s + m*60;
	}	else {
		if (m >= 60) h = m/60;
		else h = 0;
		k = m - (h*60);
		//text = "Next bar : " + h + " hr " + k + " min " + s + " sec, sp: " + DoubleToString(sp, 1) + " peri "+Period();
		text = "Next bar : " + h + " hr " + k + " min " + s + " sec, sp: " + DoubleToString(sp, 1);
    total_sec = s + ((h*60+k)*60);
	}

	ObjectCreate(0,ReminingTime_sname, OBJ_LABEL, 0, 0, 0);
  //ObjectSetText(ReminingTime_sname,submsg,FontSize,FontName,FontColor);
  ObjectSetString(0,ReminingTime_sname,OBJPROP_TEXT, text);
  ObjectSetString(0,ReminingTime_sname,OBJPROP_FONT, FontName);
	ObjectSetInteger(0,ReminingTime_sname, OBJPROP_FONTSIZE, FontSize);

  if(WarnSeconds < total_sec){
  	//ObjectSetText(0,ReminingTime_sname, text, FontSize, FontName, FontColor);
  	ObjectSetInteger(0,ReminingTime_sname, OBJPROP_COLOR, FontColor);
  }else{
  	//ObjectSetText(0,ReminingTime_sname, text, FontSize, FontName, FontColorWaning);
  	ObjectSetInteger(0,ReminingTime_sname, OBJPROP_COLOR, FontColorWaning);
  }
	ObjectSetInteger(0,ReminingTime_sname, OBJPROP_XDISTANCE, LocationX);
	ObjectSetInteger(0,ReminingTime_sname, OBJPROP_YDISTANCE, LocationY);
	ObjectSetInteger(0,ReminingTime_sname, OBJPROP_CORNER, Corner);
  if(2<=Corner){
  	ObjectSetInteger(0,ReminingTime_sname, OBJPROP_ANCHOR, ANCHOR_RIGHT_UPPER);
  }
  ChartRedraw(0);
}

//+------------------------------------------------------------------+
void OnTimer()
{
  draw_remaining_time();
}
//+------------------------------------------------------------------+

//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
//int start()
//{
//  draw_remaining_time();
//  return(0);
//}
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
//---
  draw_remaining_time();
   
//--- return value of prev_calculated for next call
  return(rates_total);
}
//+------------------------------------------------------------------+
