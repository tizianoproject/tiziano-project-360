/** -----------------------------------------------------------
 * BaseView
 * -----------------------------------------------------------
 * Description: BaseView is the base background for all views 
 * - ---------------------------------------------------------
 * Created by: cmendez@tizianoproject.org
 * Modified by: 
 * Date Modified: June 22, 2010
 * - ---------------------------------------------------------
 * Copyright ©2010
 * - ---------------------------------------------------------
 *
 *
 */

package org.tizianoproject.view
{
	import com.chrisaiv.utils.ShowHideManager;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	
	import org.casalib.util.LocationUtil;
	import org.tizianoproject.events.BaseViewEvent;
	
	public class BaseView extends CompositeView
	{
		public var close_btn:SimpleButton;
		
		private var baseViewArgs:Object;
		
		public function BaseView()
		{			
			baseViewArgs = new Object();			

			addEventListener( Event.ADDED_TO_STAGE, onAddedToStageHandler, false, 0, true );
			addEventListener( Event.REMOVED_FROM_STAGE, onRemovedFromStageHandler, false, 0, true );
		}
		
		override protected function init():void
		{
			drawBackground();
			
			close_btn.addEventListener(MouseEvent.CLICK, onMouseClickHandler, false, 0, true );	
			stage.addEventListener(FullScreenEvent.FULL_SCREEN, onFullScreenHandler, false, 0, true );
		}
		
		override protected function unload():void
		{
			close_btn.removeEventListener(MouseEvent.CLICK, onMouseClickHandler );
		}
		
		private function drawBackground():void
		{
			graphics.beginFill( 0x00FF00, 0 );
			graphics.drawRect( -parent.x, 0, stage.stageWidth, stage.stageHeight );
			graphics.endFill();
		}
		
		
		/**********************************
		 * Event Handlers
		 **********************************/
		private function onMouseClickHandler( e:MouseEvent ):void
		{
			//trace( "BaseView::onMouseClickHandler", e.currentTarget.parent.parent.name );
			baseViewArgs.viewName = e.currentTarget.parent.parent.name;			
			dispatchEvent( new BaseViewEvent( BaseViewEvent.CLOSE, baseViewArgs ) );
		}		
	}
}