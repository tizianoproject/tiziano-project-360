package org.tizianoproject.view.components.brick
{
	import com.chrisaiv.utils.ShowHideManager;
	import com.chrisaiv.utils.TextFormatter;
	
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
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import org.tizianoproject.model.vo.Author;
	
	public class Author extends MovieClip
	{
		private static const DEFAULT_TEXT_X_POS:Number = 108;
		private static const DEFAULT_NAME_POS:Point = new Point( DEFAULT_TEXT_X_POS, 6 );
		private static const DEFAULT_LOCATION_POS:Point = new Point( DEFAULT_TEXT_X_POS, 65 );
		
		private static const DEFAULT_TEXT_WIDTH:Number = 140;
		private static const DEFAULT_AVATAR_WIDTH:Number = 100;
		private static const DEFAULT_AVATAR_HEIGHT:Number =100;
		
		private var bmp:Bitmap;
		private var imageLoader:Loader;
		private var loaderContext:LoaderContext;
		
		//Views
		public var container_mc:MovieClip;
		
		private var font:Font;
		private var nameTxt:TextField;
		private var ageTxt:TextField;
		private var locationTxt:TextField;
		
		public var _id:Number;
		public var _authorName:String;
		
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
			nameTxt = initTextField( "nameTxt", DEFAULT_NAME_POS, 0x2E94CB, 20 );
			nameTxt.text = string;	
			ShowHideManager.addContent( (this as Author), nameTxt );
		}
		
		public function writeGrade( string:String ):void
		{
			//Position ageTxt.y based on nameTxt
			var p:Point = new Point( DEFAULT_TEXT_X_POS, nameTxt.y + nameTxt.textHeight );
			ageTxt = initTextField( "ageTxt", p, 0x999999, 16 );
			ageTxt.text = string;
			ShowHideManager.addContent( (this as Author), ageTxt );
		}
		
		private function initTextField( name:String, point:Point, color:Number, size:Number ):TextField
		{
			font = new AGaramondSmallCaps();
			
			var textField:TextField = new TextField();
				textField.name = name;
				textField.x = point.x;
				textField.y = point.y;
				textField.mouseEnabled = true;
				textField.width = DEFAULT_TEXT_WIDTH;
				textField.autoSize = TextFieldAutoSize.LEFT;
				textField.defaultTextFormat = TextFormatter.returnTextFormat( font.fontName, color, size, 2 );
				textField.embedFonts = true;			
				textField.selectable = false;
				textField.wordWrap = true;
				textField.multiline = true;
				
			return textField;			
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
			
		public function set authorName( value:String ):void
		{
			_authorName = value;
		}
		
		public function get authorName():String
		{
			return _authorName;
		}
	}
}