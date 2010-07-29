package org.tizianoproject.view
{	
	import com.chargedweb.swfsize.SWFSize;
	import com.chargedweb.swfsize.SWFSizeEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FullScreenEvent;

	public class CompositeView extends ComponentView
	{
		private var children:Array;
		
		public function CompositeView()
		{
			children = new Array();
			
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStageHandler, false, 0, true );
			addEventListener( Event.ADDED, onAddedHandler, false, 0, true );
			addEventListener( Event.REMOVED_FROM_STAGE, onRemovedFromStageHandler, false, 0, true );
		}

		protected function init():void
		{
		}
		
		protected function resize( e:FullScreenEvent ):void
		{
		}
		
		protected function unload():void
		{
			
		}	

		override public function add(c:ComponentView) : void
		{
			children.push( c );
		}
		
		/**********************************
		 * Event Handlers
		 **********************************/	
		//This must remain public in order for Application.as::swfSizer can access
		public function swfSizerHandler( e:SWFSizeEvent ):void
		{
			//trace( "CompositeView::browserResize:", e.topY, e.bottomY, e.leftX, e.rightX, e.windowWidth, e.windowHeight );
			
			//Notify to all the children that the browser has updated
			for each( var c:ComponentView in children )
			{
				c.browserResize( e );
			}
		}
		
		protected function onAddedHandler( e:Event ):void
		{
			//trace( "CompositeView::onAddedHandler:", e.target );
		}

		protected function onAddedToStageHandler( e:Event ):void
		{
			init();
			//You Must first wait for the View to be loaded before you can activate the stage listener
			stage.addEventListener(FullScreenEvent.FULL_SCREEN, onFullScreenHandler, false, 0, true );
		}
		
		protected function onRemovedFromStageHandler( e:Event ):void
		{
			unload();
		}		
		
		protected function onFullScreenHandler( e:FullScreenEvent ):void
		{
			resize( e );
		}
	}
}