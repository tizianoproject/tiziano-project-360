package org.tizianoproject.view.components.directory
{
	import com.chrisaiv.utils.CSSFormatter;
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
	import org.tizianoproject.view.CompositeView;
	
	public class AuthorListing extends CompositeView
	{
		private static const DEFAULT_TEXT_X_POS:Number = 108;
		private static const DEFAULT_NAME_POS:Point = new Point( DEFAULT_TEXT_X_POS, 6 );
		private static const DEFAULT_LOCATION_POS:Point = new Point( DEFAULT_TEXT_X_POS, 65 );
		
		private static const DEFAULT_TEXT_WIDTH:Number = 140;
		private static const DEFAULT_AVATAR_WIDTH:Number = 100;
		private static const DEFAULT_AVATAR_HEIGHT:Number =100;
		
		private var bmp:Bitmap;
		private var imageLoader:Loader;
		
		//Views
		public var container_mc:MovieClip;
		
		private var font:Font;
		private var nameTxt:TextField;
		private var ageTxt:TextField;
		private var locationTxt:TextField;

		public var name_txt:TextField;
		
		private var _id:Number;
		private var _authorName:String;
		private var _vo:Author;
		
		public function AuthorListing()
		{
		}
		
		override protected function init():void
		{
			buttonMode = true;
			writeName( vo.name );
			writeGrade( vo.age );
			loadImage( vo.avatar );
		}
		
		public function loadImage( url:String ):void
		{
			imageLoader = new Loader();
			imageLoader.name = "imageLoader";
			imageLoader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onErrorHandler, false, 0, true);	
			imageLoader.addEventListener( IOErrorEvent.IO_ERROR, onErrorHandler, false, 0, true);
			imageLoader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, onErrorHandler, false, 0, true);
			imageLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, onCompleteHandler, false, 0, true);
			imageLoader.load( new URLRequest( url ), new LoaderContext(true) );
		}
		
		public function writeName( value:String ):void
		{
			name_txt.htmlText = "<a href='event:blank'>" + value + "</a>";
			name_txt.autoSize = TextFieldAutoSize.LEFT;
			name_txt.styleSheet = CSSFormatter.simpleUnderline();
		}
		
		public function writeGrade( value:String ):void
		{
			//Position age_txt.y based on nameTxt
			var p:Point = new Point( DEFAULT_TEXT_X_POS, name_txt.y + name_txt.textHeight );
			ageTxt = initTextField( "ageTxt", p, DEFAULT_TEXT_WIDTH, 0x999999, 16 );
			ageTxt.text = value;
			ShowHideManager.addContent( (this as AuthorListing), ageTxt );
		}
		
		private function initTextField( name:String, point:Point, w:Number, color:Number, size:Number ):TextField
		{
			font = new AGaramondSmallCaps();
			
			var textField:TextField = new TextField();
				textField.name = name;
				textField.x = point.x;
				textField.y = point.y;
				textField.mouseEnabled = true;
				textField.width = w;
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
		
		override protected function unload():void
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
		private function onErrorHandler( e:ErrorEvent ):void
		{
			//trace( "Author::onErrorHandler:", e.text );
		}
		
		private function onCompleteHandler( e:Event ):void
		{
			//trace( "Author::onCompleteHandler:", e.currentTarget );
			drawImage( e.currentTarget as LoaderInfo );
		}
		
		/**********************************
		 * Read Write Accessors
		 **********************************/
		public function get id():Number
		{
			return _vo.id;
		}
			
		public function get authorName():String
		{
			return _vo.name;
		}
		
		public function set vo( value:Author ):void
		{
			_vo = value;	
		}
		
		public function get vo():Author
		{
			return _vo;
		}
	}
}