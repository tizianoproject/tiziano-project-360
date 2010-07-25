package com.chrisaiv.utils
{
	import flash.text.StyleSheet;

	public class CSSFormatter
	{
		public function CSSFormatter()
		{
		}
		
		public static function simpleUnderline():StyleSheet
		{
			var aHover:Object = new Object();
				aHover.textDecoration = "underline";
			
			var style:StyleSheet = new StyleSheet();
				style.setStyle("a:hover", aHover);
				style.setStyle("span", aHover );
			
			return style;
		}		
		

	}
}