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
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.printing.PrintJob;
	import flash.system.LoaderContext;
	
	import org.casalib.util.LocationUtil;
	import org.casalib.util.ValidationUtil;

	
	public class WallView extends CompositeView
	{
		private static const MIN_WIDTH:Number = 800;
		private static const TWEEN_SPEED:Number = 0.5;

		private var swfLoader:Loader;
		
		public function WallView( )
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler, false, 0, true );
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStageHandler, false, 0, true );
		}
		
		public function loadWall( path:String ):void
		{
			swfLoader = new Loader();				
			swfLoader.name = "swfLoader";
			swfLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler, false, 0, true ); 
			swfLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler, false, 0, true ); 
			swfLoader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onErrorHandler, false, 0, true );
			swfLoader.load( new URLRequest( path ), new LoaderContext( true ) );
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
		private function onCompleteHandler( e:Event ):void
		{
			trace( "WallView::onCompleteHandler:", "Wall is LOADED" );
		}
		
		private function onErrorHandler( e:Event ):void
		{
			trace( "WallView::onErrorHandler:", e );
		}
	}
}