/** -----------------------------------------------------------
 * Feature
 * -----------------------------------------------------------
 * Description: A Single 360 Feature 
 * - ---------------------------------------------------------
 * Created by: cmendez@tizianoproject.org
 * Modified by: 
 * Date Modified: June 22, 2010
 * - ---------------------------------------------------------
 * Copyright ©2010
 * - ---------------------------------------------------------
 *
 * Features are responses to Articles [ Text, Photo, Video ] and appear on the right hand column
 *
 */

package org.tizianoproject.view.components.article
{
	import com.chrisaiv.utils.CSSFormatter;
	import com.chrisaiv.utils.ShowHideManager;
	import com.chrisaiv.utils.TextFormatter;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	
	import org.casalib.events.LoadEvent;
	import org.casalib.load.ImageLoad;
	import org.tizianoproject.model.vo.Story;
	import org.tizianoproject.view.CompositeView;
	
	public class Feature extends CompositeView
	{
		private static const DEFAULT_TEXT_WIDTH:Number = 175;
		private static const DEFAULT_BITMAP_POS:Point = new Point( 12, 10 );
		
		private var imageLoad:ImageLoad;
		private var bmp:Bitmap;
		private var loaderContext:LoaderContext;
		
		public var authorType_mc:MovieClip;
		public var image_mc:MovieClip;
		
		public var title_txt:TextField;
		public var subhed_txt:TextField;
		
		private var _y:Number;
		private var _storyID:Number;
		private var _author:String;
		private var _vo:Story;
		
		public function Feature(  )
		{			
		}
		
		override protected function init():void
		{
			//Write the Title	
			writeTitle( vo.title );
			
			//Write Subheadline
			writeSubhead( "By: " + vo.authorName );
			
			//Set the Author Type
			authorType( vo.authorType );
			
			//Load the image
			loadImage( vo.image );
			buttonMode = true;
		}
		
		private function authorType( value:String ):void
		{
			//trace( "Feature::authorType:", value );
			authorType_mc.gotoAndStop( value.toLowerCase() );
		}
		
		private function loadImage( url:String ):void
		{
			loaderContext = new LoaderContext( true );
			imageLoad = new ImageLoad( new URLRequest( url ), loaderContext );
			imageLoad.addEventListener( LoadEvent.COMPLETE, onCompleteHandler, false, 0, true );
			imageLoad.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler, false, 0, true );
			imageLoad.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onErrorHandler, false, 0, true );
			imageLoad.start();
		}
		
		private function writeTitle( value:String ):void
		{
			title_txt.htmlText = "<a href='event:blank'>" + value + "</a>";
			title_txt.styleSheet = CSSFormatter.simpleUnderline();
		}
		
		private function writeSubhead( value:String ):void
		{
			subhed_txt.text = value;			
		}
		
		private function clearLoader():void
		{
			if( imageLoad ) imageLoad.destroy()
		}
		
		private function clearBitmap():void
		{
			if( bmp ) bmp.bitmapData.dispose();
		}
		
		private function resetAuthorType():void
		{
			authorType( "blank" );
		}
		
		override protected function unload():void
		{
			writeTitle( "" );
			writeSubhead( "" );
			clearBitmap();
			clearLoader();
			resetAuthorType();
		}
		
		//Redraw the Image for a smaller size
		private function drawImage( ):void
		{
			bmp = imageLoad.contentAsBitmap;
			ShowHideManager.addContent( image_mc, bmp );
		}

		/**********************************
		 * Event
		 **********************************/	
		private function onCompleteHandler( e:Event ):void
		{
			drawImage();
		}
		
		private function onErrorHandler( e:ErrorEvent ):void
		{
			trace( "Feature::onErrorHandler:", e.text );
		}		
				
		/*********************************
		 * Getters | Setters
		 *********************************/
		public function set vo( value:Story ):void
		{
			_vo = value;
		}
		
		public function get vo():Story
		{
			return _vo;
		}
		/*********************************
		 * Overrrides
		*********************************/
		override public function set y( value:Number ):void
		{
			super.y = value;
		}
		
		override public function get y():Number
		{
			return super.y;
		}		
	}
}