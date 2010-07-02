package org.tizianoproject.view
{
	import com.chargedweb.swfsize.SWFSizeEvent;
	import com.chrisaiv.utils.ShowHideManager;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	
	public class HeaderView extends MovieClip
	{
		private static const DEFAULT_HEIGHT:Number = 70;
		
		private var bg:Sprite;
		private var browserWindowWidth:Number;
		private var marginRight:Number = 20;

		public var headerRight_mc:MovieClip;
		
		public function HeaderView(  )
		{
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false, 0, true );
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler, false, 0, true );
			stage.addEventListener(Event.RESIZE, onResizeHandler, false, 0, true );
		}

		/**********************************
		 * 
		 **********************************/
		private function updateBackground( value:Number ):void
		{
			//trace( "HeaderView::resizeBackground:", value );
			bg.width = value;
		}
		
		private function updatePosition( value:Number ):void
		{
			headerRight_mc.x = value - marginRight;
		}
		
		private function onResizeHandler( e:Event ):void
		{
			if( stage.displayState == FullScreenEvent.FULL_SCREEN ){
				updatePosition( stage.stageWidth - headerRight_mc.width );
				updateBackground( stage.stageWidth );
			} else {
				updatePosition( browserWindowWidth - headerRight_mc.width );
				updateBackground( browserWindowWidth );
			}
		}
		
		/**********************************
		 * 
		 **********************************/
		private function initBackground():void
		{
			bg = new Sprite();
			bg.name = "bg";
			bg.mouseChildren = true;
			bg.mouseEnabled = false;
			
			bg.graphics.beginFill( 0x000000, 1 );
			bg.graphics.drawRect( 0, 0, stage.stageWidth, DEFAULT_HEIGHT );
			bg.graphics.endFill();
			
			bg.graphics.lineStyle(1, 0x666666, 1 );
			bg.graphics.moveTo( 0, DEFAULT_HEIGHT );
			bg.graphics.lineTo( stage.stageWidth, DEFAULT_HEIGHT );
			
			addChildAt( bg, 0 );			
		}

		/**********************************
		 * Event
		 **********************************/		
		public function swfSizerHandler( e:SWFSizeEvent ):void
		{
			//trace( "HeaderView::swfSizerHandler:", e.topY, e.bottomY, e.leftX, e.rightX, e.windowWidth, e.windowHeight );
			browserWindowWidth = e.rightX;
			
			updatePosition( browserWindowWidth - headerRight_mc.width );
			updateBackground( browserWindowWidth );
		}
		
		private function addedToStageHandler( e:Event ):void
		{
			//trace( "HeaderView::addedToStageHandler:" );			
			initBackground();
		}
		
		private function removedFromStageHandler( e:Event ):void
		{
			trace( "HeaderView::removedFromStageHandler:" );
		}
		
	}
}