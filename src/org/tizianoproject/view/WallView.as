package org.tizianoproject.view
{
	import com.chargedweb.swfsize.SWFSizeEvent;
	import com.chrisaiv.utils.ShowHideManager;
	import com.greensock.TweenLite;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.printing.PrintJob;
	import flash.system.LoaderContext;
	
	import org.casalib.util.LocationUtil;
	import org.casalib.util.ValidationUtil;
	import org.tizianoproject.controller.IController;
	import org.tizianoproject.model.IModel;
	
	public class WallView extends MovieClip
	{
		private static const DEFAULT_X_POS:Number = 0;
		private static const DEFAULT_Y_POS:Number = 0;
		
		private static const MIN_WIDTH:Number = 800;

		private static const TWEEN_SPEED:Number = 0.5;

		private var browserWidth:Number;
		private var browserHeight:Number;
		
		private var swfLoader:Loader;
		private var loaderContext:LoaderContext;
		
		public function WallView( )
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler, false, 0, true );
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStageHandler, false, 0, true );
		}
		
		private function init():void
		{			
			stage.addEventListener( FullScreenEvent.FULL_SCREEN, onFullScreenHandler, false, 0, true );
		}
		
		public function loadWall( path:String ):void
		{
			loaderContext = new LoaderContext( true );
			swfLoader = new Loader();				
			swfLoader.name = "swfLoader";
			swfLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler, false, 0, true ); 
			swfLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler, false, 0, true ); 
			swfLoader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onErrorHandler, false, 0, true );
			swfLoader.load( new URLRequest( path ), loaderContext );
			ShowHideManager.addContent( (this as WallView), swfLoader );			
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
		
		/**********************************
		 * Event
		 **********************************/		
		public function swfSizerHandler( e:SWFSizeEvent ):void
		{
			//trace( "HeaderView::swfSizerHandler:", e.topY, e.bottomY, e.leftX, e.rightX, e.windowWidth, e.windowHeight );
			browserWidth = e.rightX;
			browserHeight = e.bottomY;
		}
		
		private function onFullScreenHandler( e:FullScreenEvent ):void
		{
		}
		
		private function onCompleteHandler( e:Event ):void
		{
			trace( "WallView::onCompleteHandler:", "Wall is LOADED" );
		}
		
		private function onErrorHandler( e:Event ):void
		{
			trace( "WallView::onErrorHandler:", e );
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