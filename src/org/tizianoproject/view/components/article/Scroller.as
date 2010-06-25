/**
 * -------------------------------------------------------
 * Scroller
 * -------------------------------------------------------
 * 
 * Version: 1
 * Created: chrisaiv@gmail.com
 * Modified: 6/24/2010
 * 
 * -------------------------------------------------------
 * Notes:
 * Scroller extends com.tis.utils.components.Scrollbar
 * but adds TweenLite into for smoother scrolling.
 * 
 * */
package org.tizianoproject.view.components.article
{
	import com.greensock.TimelineLite;
	import com.greensock.TweenAlign;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Strong;
	import com.tis.utils.components.Scrollbar;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import org.casalib.transitions.Tween;
	
	public class Scroller extends Scrollbar
	{
		private static const TWEEN_SPEED:Number = 0.4;
		
		public function Scroller( target:MovieClip )
		{
			super( target );	

			dragHandleMC.buttonMode = true;
			upScrollControl.alpha = 0;
			downScrollControl.alpha = 0;
		}
		
		override public function moveScroll(event:MouseEvent):void
		{
			onScrollHandler( event );
		}
		
		public function resetTarget( origY:Number ):void
		{
			dragHandleMC.y = 0;
			TweenLite.to( targetMC, TWEEN_SPEED, { y: origY, ease: Strong.easeInOut, onComplete: onCompleteHandler } );
		}
		
		private function onScrollHandler( e:MouseEvent ):void
		{
			ratio = (targetMC.height - range ) / range;
			var yPos:Number = (dragHandleMC.y * ratio ) - ctrl;
			
			var tweenLite = new TweenLite( targetMC, TWEEN_SPEED, { y: -yPos, ease: Strong.easeOut } );
			
			//use updateAfterEvent() so that Flash doesn't have to rely on the 
			//frame rate to make on  MOUSE_MOVE.  Otherwise it's sluggish
			e.updateAfterEvent();
		}
		
		private function onCompleteHandler( ):void
		{
			trace( "Scroller::onCompleteHandler:" );
		}
	}
}
