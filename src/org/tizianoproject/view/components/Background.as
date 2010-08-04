//http://www.senocular.com/?entry=476
package org.tizianoproject.view.components
{
	import com.chargedweb.swfsize.SWFSizeEvent;
	import com.chrisaiv.utils.ShowHideManager;
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.StageDisplayState;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.profiler.showRedrawRegions;
	import flash.system.LoaderContext;
	
	import org.casalib.events.LoadEvent;
	import org.casalib.load.ImageLoad;
	import org.tizianoproject.view.CompositeView;
	
	public class Background extends CompositeView
	{
		private static const DEFAULT_BG_IMAGE:String = "http://demo.chrisaiv.com/images/tiziano/360/wall/Wall-Bg.jpg"
		private static const MIN_WIDTH:Number = 800;
		private static const MIN_HEIGHT:Number = 600;
		
		private var defaultWidth:Number;
		private var defaultHeight:Number;
		private var browserWidth:Number;
		private var browserHeight:Number;
		private var aspectRatio:Number;
				
		private var imageLoad:ImageLoad;
		
		public function Background()
		{
		}
		
		public function load( path:String=DEFAULT_BG_IMAGE ):void
		{			
			//Destroy any previous version of the bitmap
			destroyLoader();
			
			//Insurance that it's all gone
			ShowHideManager.unloadContent( (this as Background ) );
			
			//Reload a new image
			imageLoad = new ImageLoad( new URLRequest( path ), new LoaderContext( true ) );
			imageLoad.addEventListener(LoadEvent.COMPLETE, onCompleteHandler, false, 0, true );
			imageLoad.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler, false, 0, true );
			imageLoad.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onErrorHandler, false, 0, true );
			ShowHideManager.addContent( (this as Background), imageLoad.loader );
			imageLoad.start();
		}

		private function drawBitmap( e:LoadEvent ):void
		{
			//Tween In Loader
			var l:Loader = e.currentTarget.loader as Loader;
				l.alpha = 0;
			//Get the Bitmap Measurements
			var bmp:Bitmap = imageLoad.contentAsBitmap;
			//Assign the measurements
			defaultWidth = bmp.width;	
			defaultHeight = bmp.height;
			//Create an Aspect Ratio for the Background IMage
			aspectRatio = defaultWidth / defaultHeight;
			//Resize the Bitmap to fit either the browser or Theatre Mode (Full Screen)
			resize( new FullScreenEvent( "normal" ) );
			//Tween in the image
			TweenLite.to( l, 1, { alpha: 1 } );			
		}
		
		private function adjustSize( w:Number, h:Number ):void
		{
			//The Bitmap Image is loaded
			if( imageLoad.loaded ){
				//Browser window is larger than the default Bitmap image
				if( w > MIN_WIDTH ){
					width = w;
					height = w / aspectRatio;
				} 
				//The Browswer window is smaller than the minimum width
				else {
					width = MIN_WIDTH;
					height = MIN_WIDTH / aspectRatio;
				}
			}
		}
		
		/**********************************
		 * Memory Management
		 **********************************/
		private  function destroyLoader():void
		{
			if( imageLoad ){
				if( imageLoad.loaded || imageLoad.loading ){
					imageLoad.stop();
					imageLoad.destroy();
				}
			}
		}
		
		override protected function unload():void
		{
			destroyLoader();
		}
		
		/**********************************
		 * Resize
		 **********************************/
		override public function browserResize(e:SWFSizeEvent):void
		{
			//Keep track of the Browser Window
			browserWidth = e.windowWidth;
			browserHeight = e.windowHeight;			
			//trace( "Background::browserResize:", e.type, e.windowWidth, e.windowHeight );
			
			resize( new FullScreenEvent( "normal" ) );
		}
		
		//Resize Bitmap handles fullScreen and normalScreen so that you only need to update from one place
		override protected function resize(e:FullScreenEvent):void
		{
			//Adjust the image to the browser window
			if( stage.displayState == StageDisplayState.FULL_SCREEN ){
				adjustSize( stage.stageWidth, (stage.stageHeight / aspectRatio) );				
			} else {
				//Adjust the Background to match the size of the browser
				if( browserWidth && browserHeight ) adjustSize( browserWidth, browserHeight );
					//SWF is being loaded from IDE
				else adjustSize( defaultWidth, defaultHeight );
			}			
		}
		
		/**********************************
		 * Event
		 **********************************/	
		private function onCompleteHandler( e:LoadEvent ):void
		{
			trace( "Background:onCompleteHandler:" );
			drawBitmap( e );
		}
		
		private function onErrorHandler( e:ErrorEvent ):void
		{
			trace( "Background::onErrorHandler:", e.text );
		}		
	}
}