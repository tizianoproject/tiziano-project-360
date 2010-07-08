package org.tizianoproject.view
{
	import com.chargedweb.swfsize.SWFSizeEvent;
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.printing.PrintJob;
	
	import org.casalib.util.LocationUtil;
	import org.casalib.util.ValidationUtil;
	import org.tizianoproject.controller.IController;
	import org.tizianoproject.model.IModel;
	
	public class WallView extends MovieClip
	{
		private static const MIN_WIDTH:Number = 800;

		private static const TWEEN_SPEED:Number = 0.5;

		private var browserWidth:Number;
		private var browserHeight:Number;
		
		public function WallView( )
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler, false, 0, true );
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStageHandler, false, 0, true );
			stage.addEventListener( FullScreenEvent.FULL_SCREEN, onFullScreenHandler, false, 0, true );
		}
		
		private function init():void
		{			
			var alph:Number = ( LocationUtil.isIde() ) ? 0.5 : 0;
			graphics.beginFill( 0xffcc00, alph );
			graphics.drawRect( 0, 0, stage.stageWidth, stage.stageHeight );
			graphics.endFill();
			
			browserWidth = width;
			browserHeight = height;
		}
		
		public function showWall( duration:Number=TWEEN_SPEED ):void
		{
			//Show The Wall
			TweenLite.to( (this as WallView), duration, { alpha: 1 } );
		}
		
		public function hideWall( duration:Number=TWEEN_SPEED ):void
		{			
			//Hide the Wall
			TweenLite.to( (this as WallView), duration, { alpha: 0 } );
		}
		
		private function updatePosition( w:Number, h:Number ):void
		{
		//	if( w > MIN_WIDTH ) width = w;
		//	height = h;
		}
		//http://reports.tizianoproject.org/multimedia/soundslides/iraq-sdawood-noel/soundslider.swf?size=2&format=xml
		
		/**********************************
		 * Event
		 **********************************/		
		public function swfSizerHandler( e:SWFSizeEvent ):void
		{
			//trace( "HeaderView::swfSizerHandler:", e.topY, e.bottomY, e.leftX, e.rightX, e.windowWidth, e.windowHeight );
			browserWidth = e.rightX;
			browserHeight = e.bottomY;
			
			updatePosition( browserWidth, browserHeight );
		}
		
		private function onFullScreenHandler( e:FullScreenEvent ):void
		{
			var w:Number = stage.stageWidth;
			var h:Number = stage.stageHeight;
			
			trace( "WallView::onFullScreenHandler:" );
			if( e.fullScreen ){
				updatePosition( w, h );
			} else {
				updatePosition( browserWidth, browserHeight );
			}	
		}
		
		private function onAddedToStageHandler( e:Event ):void
		{
			init();
		}
		
		private function onRemovedFromStageHandler( e:Event ):void
		{
			trace( "WallView::onRemovedFromStageHandler:" );
		}
	}
}