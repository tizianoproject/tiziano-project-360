package org.tizianoproject.view
{
	import com.chargedweb.swfsize.SWFSizeEvent;
	import com.chrisaiv.utils.ShowHideManager;
	import com.greensock.TweenLite;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.StageDisplayState;
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
	import org.tizianoproject.view.components.Mask;
	
	public class WallView extends CompositeView
	{
		private static const MIN_WIDTH:Number = 800;
		private static const TWEEN_SPEED:Number = 0.5;

		private var swfLoader:Loader;
		private var wallMask:Mask;
		
		private var browserWidth:Number;
		private var browerHeight:Number;
		
		public function WallView( )
		{
		}
		
		public function loadWall( path:String ):void
		{
			swfLoader = new Loader();				
			swfLoader.name = "swfLoader";
			swfLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler, false, 0, true ); 
			swfLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler, false, 0, true ); 
			swfLoader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onErrorHandler, false, 0, true );
			
			try{
				swfLoader.load( new URLRequest( path ), new LoaderContext( true ) );				
			} catch( e:Error ){ trace( "WallView::load Error:" ) }

			ShowHideManager.addContent( (this as WallView), swfLoader );			
		}
		
		public function showWall( duration:Number=TWEEN_SPEED ):void
		{
			//Show The Wall
			TweenLite.to( (this as WallView), duration, { alpha: 1, onInit: onTweenInitHandler, onInitParams: ["show"] } );
		}
		
		public function hideWall( duration:Number=TWEEN_SPEED ):void
		{			
			//Hide the Wall
			TweenLite.to( (this as WallView), duration, 
				{ alpha: 0, onInit: onTweenInitHandler, onInitParams: ["hide"], onComplete: onTweenCompleteHandler } );
		}
		
		private function showMask():void
		{
			wallMask = new Mask();
			wallMask.name = "wallMask";
			ShowHideManager.addContent( (this as WallView), wallMask );
		}
		
		private function hideMask():void
		{
			ShowHideManager.removeContent( (this as WallView), "wallMask" );
		}
		
		override public function browserResize(e:SWFSizeEvent):void
		{
			browserWidth = e.rightX;
			browerHeight = e.bottomY;
			
			if( wallMask ) wallMask.updateSize( browserWidth, browerHeight );
		}
		
		override protected function resize(e:FullScreenEvent):void
		{
			if( stage ){
				if( stage.displayState == StageDisplayState.FULL_SCREEN ){
					if( wallMask ) wallMask.updateSize( stage.fullScreenWidth, stage.fullScreenHeight );
				} else {
					if( wallMask ) wallMask.updateSize( browserWidth, browerHeight );
				}
			}
		}
		
		/**********************************
		 * Event
		 **********************************/
		private function onTweenInitHandler( message:String ):void
		{
			switch( message ){
				case "hide":
					showMask();
					break;
				case "show":
					hideMask();
					break;
			}
			trace( "WallView::onTweenInitHandler:", message );			
		}
		
		private function onTweenCompleteHandler():void
		{
			trace( "WallView::onTweenCompleteHandler:" );			
		}
		
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