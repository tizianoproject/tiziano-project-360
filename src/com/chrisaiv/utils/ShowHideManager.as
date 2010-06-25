package com.chrisaiv.utils
{
	import flash.display.*;

	public class ShowHideManager
	{
		
		public function ShowHideManager()
		{
		}
		
		public static function addContent( container:*, view:DisplayObject ):void
		{
			container.addChild( view );
		}
		
		public static function removeContent( container:*, childName:String ):void
		{
			//trace( "ShowHideManager::removeContent:", container, childName );
			//First check to see if there's a child with that particular name on the Stage
			if( container.getChildByName( childName ) != null){
				//Next check if it's currently visible. If it is, then remove it from the stage
				if( container.getChildByName( childName ).visible ) container.removeChild( container.getChildByName( childName ) );					
			}			  
			
		}
				
		public static function unloadContent( mc:MovieClip, baseline:Number=0 ):void
		{
			//The Baseline param is meant for some movieclips to have a Background Shape object as the base layer.  I don't want to delete it so I avoid it with baseline
			//trace( "ShowHideManager::unloadContent:", mc.numChildren, baseline );
			for ( var z:Number = ( mc.numChildren -1 ); z >= baseline; z-- ) {
				//When you remove items, Flash automatically resorts the Indecies so you have to count backwards
				mc.removeChild( mc.getChildAt(z) );
			}
		}
	}
}