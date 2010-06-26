package org.tizianoproject.view.components.brick
{
	import com.chrisaiv.utils.ShowHideManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	
	public class Author extends SimpleButton
	{
		private static const DEFAULT_AVATAR:String = "../Assets/Student.jpg";
		private static const DEFAULT_AVATAR_WIDTH:Number = 100;
		private static const DEFAULT_AVATAR_HEIGHT:Number =100;
		
		private var bmp:Bitmap;
		private var imageLoader:Loader;
		private var loaderContext:LoaderContext;
		
		public var container_mc:MovieClip;
		public var name_txt:TextField;
		public var grade_txt:TextField;
		
		public function Author(upState:DisplayObject=null, overState:DisplayObject=null, downState:DisplayObject=null, hitTestState:DisplayObject=null)
		{
			//super(upState, overState, downState, hitTestState);
			loaderContext = new LoaderContext( true );
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler, false, 0, true );
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler, false, 0, true );
			
			addEventListener( MouseEvent.ROLL_OVER, onMouseRollOverHandler, false, 0, true );
			addEventListener( MouseEvent.ROLL_OUT, onMouseOutHandler, false, 0, true );
			addEventListener( MouseEvent.CLICK, onMouseClickHandler, false, 0, true );
		}
		
		public function loadImage( url:String ):void
		{
			imageLoader = new Loader();
			imageLoader.name = "imageLoader";
			imageLoader.addEventListener( HTTPStatusEvent.HTTP_STATUS, httpStatusHandler, false, 0, true);
			imageLoader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, false, 0, true);	
			imageLoader.addEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
			imageLoader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
			imageLoader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, progressHandler, false, 0, true);
			imageLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, onCompleteHandler, false, 0, true);
			imageLoader.load( new URLRequest( url ), loaderContext );	
		}
		
		private function drawImage( loaderInfo:LoaderInfo ):void
		{
			//width: 96, height: 120
			bmp = loaderInfo.content as Bitmap;			
			var bmpData:BitmapData = new BitmapData( bmp.width, bmp.height );
				bmpData.draw( bmp );

			bmp.width = DEFAULT_AVATAR_WIDTH;
			bmp.height = DEFAULT_AVATAR_HEIGHT;
			bmp.smoothing = true;
			
			ShowHideManager.addContent( container_mc, bmp );
			
			//Since you are drawing a Bitmap then you don't nead Loader		
			clearLoader();			
		}
		
		private function init():void
		{
			//loadImage( DEFAULT_AVATAR );
		}		
		
		private function unload():void
		{
			clearLoader();
			clearBitmap();
		}

		private function clearLoader():void
		{
			imageLoader.unload();
		}
		
		public function clearBitmap():void
		{
			if( bmp ) bmp.bitmapData.dispose();
		}

		/**********************************
		 * Event Handlers
		 **********************************/
		private function onAddedToStageHandler( e:Event ):void
		{
			removeEventListener( e.type, arguments.callee );			
			//trace( "Author::onAddedToStageHandler:" );
			init();
		}
		
		private function removedFromStageHandler( e:Event ):void
		{
			removeEventListener( e.type, arguments.callee );
			//trace( "Author::removedFromStageHandler:" );
			unload();
		}
		
		private function httpStatusHandler( e:HTTPStatusEvent ):void
		{
			//trace( "Author::httpStatusHandler:" );
		}
		
		private function progressHandler( e:ProgressEvent ):void
		{
			trace( "Author::progressHandler:" );
		}
		
		private function securityErrorHandler( e:SecurityErrorEvent ):void
		{
			trace( "Author::securityErrorHandler:" );
		}
		
		private function ioErrorHandler( e:IOErrorEvent ):void
		{
			trace( "Author::ioErrorHandler:" );
		}
		
		private function onCompleteHandler( e:Event ):void
		{
			drawImage( e.currentTarget as LoaderInfo );
			//trace( "Author::onCompleteHandler:" );
		}
		
		private function onMouseRollOverHandler( e:MouseEvent ):void
		{
			//trace( "Author::onMouseRollOverHandler:", e.currentTarget );
		}
		
		private function onMouseOutHandler( e:MouseEvent ):void
		{
			//trace( "Author::onMouseOutHandler:", e.currentTarget );
		}
		
		private function onMouseClickHandler( e:MouseEvent ):void
		{
			//trace( "Author::onMouseClickHandler:", e.currentTarget, e.target.name );
		}
	}
}