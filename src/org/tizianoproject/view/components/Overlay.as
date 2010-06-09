/** ----------------------------------------------------------
 * Overlay
 * -----------------------------------------------------------
 * Description:
 * - ---------------------------------------------------------
 * Created by: chrisaiv
 * Modified by: 
 * Date Modified: June 9, 2010
 * - ---------------------------------------------------------
 * Copyright ©2010
 * - ---------------------------------------------------------
 * Purpose:
 *   Overlay is a transparent MovieClip that is placed on top of a Bitmap image
 *   allowing the user to click the image (or the overlay in this case) and 
 *   redirect the user to a larger view.  
 * 
 * */
package org.tizianoproject.view.components
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	public class Overlay extends Sprite
	{		
		private var eDispatcher:EventDispatcher = new EventDispatcher();

		public function Overlay( x:Number, y:Number, w:Number, h:Number )
		{			
			buttonMode = true;
			
			graphics.beginFill( 0xFF00FF, 0.5 );
			graphics.drawRect( x, y, w, h );
			graphics.endFill();
			
			addEventListener( MouseEvent.CLICK, onClickHandler, false, 0, true );
		}
		
		private function onClickHandler( e:MouseEvent ):void
		{
			trace( "Overlay::onClickHandler:" );
			dispatchEvent( new Event( Event.CLOSE ) );
		}

	}
}