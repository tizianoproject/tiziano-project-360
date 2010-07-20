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

package org.tizianoproject.view.components
{
	import com.chrisaiv.utils.ShowHideManager;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	
	import org.tizianoproject.model.vo.Story;
	
	public class Feature extends MovieClip
	{
		//These Positions are Relative to ArticleView
		private static const DEFAULT_X_POS:Number = 0;
		private static const DEFAULT_Y_POS:Number = 0;
		
		private var id:Number;
		private var imageLoader:Loader;
		private var loaderContext:LoaderContext;
		
		public var authorType_mc:MovieClip;
		public var image_mc:MovieClip;
		
		public var title_txt:TextField;
		public var subhed_txt:TextField;

		private var _y:Number;
		private var _storyID:Number;
		
		public function Feature( story:Story )
		{
			x = DEFAULT_X_POS;
			buttonMode = true;
			
			storyID = story.id;
			title_txt.text = story.title;
			subhed_txt.text = story.subheadline;

			//Set the Author Type
			authorType( story.authorType );
			//Load the image
			loadImage( story.image );		

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler, false, 0, true );
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStageHandler, false, 0, true );
		}
		
		private function init():void
		{
			title_txt.mouseEnabled = false;
			subhed_txt.mouseEnabled = false;
			image_mc.mouseEnabled = false;
			
			//addEventListener(MouseEvent.CLICK, onMouseClickHandler, false, 0, true );			
		}
		
		private function loadImage( path:String ):void
		{
			loaderContext = new LoaderContext( true );
			imageLoader = new Loader();				
			imageLoader.name = "imageLoader";
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler, false, 0, true ); 
			imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler, false, 0, true ); 
			imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.NETWORK_ERROR, onErrorHandler, false, 0, true ); 
			imageLoader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onErrorHandler, false, 0, true );
			imageLoader.load( new URLRequest( path ), loaderContext );
			ShowHideManager.addContent( image_mc, imageLoader );			
		}

		private function showBitmap( e:Event ):void
		{
			var assetLoader:Loader = e.currentTarget.loader as Loader;
			var asset:LoaderInfo = e.currentTarget as LoaderInfo;
		}
		
		private function removeBitmap( name:String="" ) :void
		{
			var childName:String = name;
			var container:MovieClip = image_mc;
			if( container.getChildByName( childName ) != null){
				//Next check if it's currently visible. If it is, then remove it from the stage
				if( container.getChildByName( childName ).visible ){
					//Destroy the BitmapData and lower the memory
					//trace( "Feature::removeBitmap:", Bitmap( Loader(container.getChildByName( childName )).content ).bitmapData );
					Bitmap( Loader(container.getChildByName( childName )).content ).bitmapData.dispose();
					container.removeChild( container.getChildByName( childName ) );
				}
			}			  
		}		
		
		private function unload():void
		{
			removeBitmap( "imageLoader" )
		}
		
		/**********************************
		 * Event
		 **********************************/	
		private function onAddedToStageHandler( e:Event ):void
		{
			init();
			//trace( "Feature::onAddedToStageHandler:" );
		}
		
		private function onRemovedFromStageHandler( e:Event ):void
		{
			unload();
			//trace( "Feature::onRemovedFromStageHandler:" );
		}
		
		private function onMouseClickHandler( e:MouseEvent ):void
		{
			trace( "Feature::onMouseClickHandler:", e.currentTarget.name );			
		}
		
		private function onCompleteHandler( e:Event ):void
		{
			showBitmap( e );
		}
		
		private function onErrorHandler( e:ErrorEvent ):void
		{
			trace( "Feature::onErrorHandler:", e.text );
		}		
				
		/*********************************
		 * Getters | Setters
		 *********************************/
		public function authorType( value:String ):void
		{
			authorType_mc.gotoAndStop( value );
		}

		public function set storyID( value:Number ):void
		{
			_storyID = value;
		}
		
		public function get storyID():Number
		{
			return _storyID;
		}
		
		/*********************************
		 * Overrrides
		*********************************/
		override public function set y( value:Number ):void
		{
			super.y = DEFAULT_Y_POS + value;
		}
		
		override public function get y():Number
		{
			return super.y;
		}		
	}
}