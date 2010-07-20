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
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	
	public class Author extends MovieClip
	{
		private static const DEFAULT_AVATAR_WIDTH:Number = 100;
		private static const DEFAULT_AVATAR_HEIGHT:Number =100;
		
		private var bmp:Bitmap;
		private var imageLoader:Loader;
		private var loaderContext:LoaderContext;
		
		//Views
		public var container_mc:MovieClip;
		public var name_txt:TextField;
		public var grade_txt:TextField;
		
		public var _id:Number;
		
		public function Author()
		{
			buttonMode = true;
			loaderContext = new LoaderContext( true );
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler, false, 0, true );
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler, false, 0, true );
			
			addEventListener( MouseEvent.ROLL_OVER, onMouseRollOverHandler, false, 0, true );
			addEventListener( MouseEvent.ROLL_OUT, onMouseOutHandler, false, 0, true );
		}
		
		public function loadImage( url:String ):void
		{
			imageLoader = new Loader();
			imageLoader.name = "imageLoader";
			imageLoader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onErrorHandler, false, 0, true);	
			imageLoader.addEventListener( IOErrorEvent.IO_ERROR, onErrorHandler, false, 0, true);
			imageLoader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, onErrorHandler, false, 0, true);
			imageLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, onCompleteHandler, false, 0, true);
			imageLoader.load( new URLRequest( url ), loaderContext );
		}
		
		public function writeName( string:String ):void
		{
			name_txt.text = string;	
		}
		
		public function writeGrade( string:String ):void
		{
			grade_txt.text = string;
		}
		
		//Redraw the Image for a smaller size
		private function drawImage( loaderInfo:LoaderInfo ):void
		{
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
		
		private function onErrorHandler( e:ErrorEvent ):void
		{
			//trace( "Author::onErrorHandler:", e.text );
		}
		
		private function onCompleteHandler( e:Event ):void
		{
			//trace( "Author::onCompleteHandler:", e.currentTarget );
			drawImage( e.currentTarget as LoaderInfo );
		}
		
		private function onMouseRollOverHandler( e:MouseEvent ):void
		{
			//trace( "Author::onMouseRollOverHandler:", e.currentTarget );
		}
		
		private function onMouseOutHandler( e:MouseEvent ):void
		{
			//trace( "Author::onMouseOutHandler:", e.currentTarget );
		}
		
		/**********************************
		 * Read Write Accessors
		 **********************************/
		public function set id( value:Number ):void
		{
			_id = value;
		}
		
		public function get id():Number
		{
			return _id;
		}
			
	}
}