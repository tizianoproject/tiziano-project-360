package com.gfxcomplex.display 
{
	
	/**
	 * This Class holds the static constances for the Align settings. 
	 * @author Josh Chernoff | GFX Complex ~ 2009
	 */
	public class FullScreenAlign 
	{
		public static const TOP				:String = "T";
		public static const TOP_LEFT		:String = "TL";
		public static const TOP_RIGHT		:String = "TR";
		public static const CENTER			:String = "C";
		public static const CENTER_LEFT		:String = "CL";
		public static const CENETR_RIGHT	:String = "CR";
		public static const BOTTOM			:String = "B";
		public static const BOTTOM_LEFT		:String = "BL";
		public static const BOTTOM_RIGHT	:String = "BR";
		
		public function FullScreenAlign() 
		{
			new Error("Do not create instance of FullScreenAlign Class");
		}
		
	}
	
}