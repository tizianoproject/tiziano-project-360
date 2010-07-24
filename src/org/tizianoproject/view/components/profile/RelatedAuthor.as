package org.tizianoproject.view.components.profile
{
	import com.chrisaiv.utils.ShowHideManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	import org.casalib.events.LoadEvent;
	import org.casalib.load.ImageLoad;
	import org.tizianoproject.model.vo.Author;
	
	public class RelatedAuthor extends MovieClip
	{
		private static const DEFAULT_AVATAR_WIDTH:Number = 50;
		private static const DEFAULT_AVATAR_HEIGHT:Number = 50;
//		private static const DEFAULT_POS:Point = new Point( 45, 510 );
		private static const DEFAULT_POS:Point = new Point( 0, 0 );
		private static const MARGIN_RIGHT:Number = 20;
		
		private var loaderContext:LoaderContext;
		private var imageLoad:ImageLoad;
		private var bmp:Bitmap;
		private var _vo:Author;
		
		private var _index:Number;
		
		public function RelatedAuthor()
		{
			buttonMode = true;
			
			y = DEFAULT_POS.y;
			
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStageHandler, false, 0, true );
			addEventListener( Event.ADDED, onAddedHandler, false, 0, true );
			addEventListener( Event.REMOVED_FROM_STAGE, onRemovedFromStageHandler, false, 0, true );
			addEventListener(MouseEvent.CLICK, onMouseClickHandler, false, 0, true );
		}

		private function init():void
		{
			loaderContext = new LoaderContext(true );
		}
		
		public function load( url:String ):void
		{
			imageLoad = new ImageLoad( new URLRequest( url ), loaderContext );
			imageLoad.addEventListener( LoadEvent.COMPLETE, onCompleteHandler, false, 0, true );
			imageLoad.start();
		}

		//Redraw the Image for a smaller size
		private function drawImage( ):void
		{
			bmp = imageLoad.contentAsBitmap;
			
			var bmpData:BitmapData = new BitmapData( bmp.width, bmp.height );
				bmpData.draw( bmp );

			bmp.width = DEFAULT_AVATAR_WIDTH;
			bmp.height = DEFAULT_AVATAR_HEIGHT;
			bmp.smoothing = true;
			
			ShowHideManager.addContent( (this as RelatedAuthor), bmp );
			
			//Since you are drawing a Bitmap then you don't nead Loader		
			clearLoader();
		}
		
		private function clearBitmap():void
		{
			bmp.bitmapData.dispose();
		}
		
		private function clearLoader():void
		{
			imageLoad.destroy()
		}

		private function unload():void
		{
			clearBitmap();
			clearLoader();
		}		
		
		/**********************************
		 * Event Handlers
		 **********************************/
		private function onMouseClickHandler( e:MouseEvent ):void
		{
			trace( "RelatedAuthor::onMouseClickHandler:" );
		}
		
		private function onCompleteHandler( e:Event ):void
		{
			drawImage( );
		}
		
		private function onAddedHandler( e:Event ):void
		{
			//trace( "CompositeView::onAddedHandler:", e.target );
		}
		
		private function onAddedToStageHandler( e:Event ):void
		{
			init();
		}
		
		private function onRemovedFromStageHandler( e:Event ):void
		{
			unload();
		}		

		/**********************************
		 * Getters Setters
		 **********************************/
		override public function set x( value:Number ):void
		{
			super.x = ( (DEFAULT_AVATAR_WIDTH + MARGIN_RIGHT) * value)// + DEFAULT_POS.x;
		}
		
		override public function get x():Number
		{
			return super.x;
		}		
		
		public function set index( value:Number ):void
		{
			_index = value;
		}
		
		public function get index():Number
		{
			return _index;
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