package org.tizianoproject.view
{
	import com.chrisaiv.utils.ShowHideManager;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	public class BaseView extends MovieClip
	{
		public var close_btn:SimpleButton;
		
		public var eDispatcher:EventDispatcher;
		
		public function BaseView()
		{			
			eDispatcher = new EventDispatcher();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler, false, 0, true );
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStageHandler, false, 0, true );
		}
		
		private function closeView():void
		{
		}
		
		private function onAddedToStageHandler( e:Event ):void
		{
			close_btn.addEventListener(MouseEvent.CLICK, onMouseClickHandler, false, 0, true );
			//trace( "Feature::onAddedToStageHandler:" );
		}
		
		private function onRemovedFromStageHandler( e:Event ):void
		{
			//trace( "Feature::onRemovedFromStageHandler:" );
			ShowHideManager.unloadContent( (this as BaseView ) );
		}	
		
		private function onMouseClickHandler( e:MouseEvent ):void
		{
			//trace( "BaseView::onMouseClickHandler" );
			eDispatcher.dispatchEvent( new Event( Event.CLOSE ) );
		}
	}
}