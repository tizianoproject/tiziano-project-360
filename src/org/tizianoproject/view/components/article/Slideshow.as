package org.tizianoproject.view.components.article
{
	import com.chrisaiv.flickr.FlickrLoader;
	import com.chrisaiv.flickr.FlickrPhotoSetLoader;
	import com.chrisaiv.utils.ShowHideManager;
	import com.dtk.ImageManager;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class Slideshow extends MovieClip
	{
		private static const DEFAULT_X_POS:Number = 50;
		private static const DEFAULT_Y_POS:Number = 50;

		private var images:Array;
		private var im:ImageManager;
		private var flickrLoader:FlickrLoader;
		private var  xmlURL:String = "http://api.flickr.com/services/rest/?method=flickr.photosets.getPhotos&api_key=4415d421495d5b59d8537c0937fcce38&photoset_id=72157624101532779";

		public function Slideshow()
		{
			flickrLoader = new FlickrLoader();
			flickrLoader.load( "72157624101532779" );
			flickrLoader.addEventListener( Event.COMPLETE, photoSetCompleteHandler, false, 0, true );
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler, false, 0, true );
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStageHandler, false, 0, true );
		}

		private function photoSetCompleteHandler( e:Event ):void
		{
			var flickrLoader:FlickrLoader = FlickrLoader( e.currentTarget );
				flickrLoader.removeEventListener( Event.COMPLETE, photoSetCompleteHandler );
			//trace( "photoSetCompleteHandler:", flickrLoader.getImageData() );
			var totalImages:Number = flickrLoader.getImageData().length;
			
			images = new Array();
			for( var i:uint = 0; i < totalImages; i++ ){
				images.push( { url: flickrLoader.getImageData()[i].url, 
								title: flickrLoader.getImageData()[i].title } );
			}
			initSlideshow();
		}
		
		private function initSlideshow():void
		{
			im = new ImageManager( 450, 300, 0, images );
			im.name = "im";
			im.x = DEFAULT_X_POS;
			im.y = DEFAULT_Y_POS;
			ShowHideManager.addContent( (this as Slideshow), im );			
		}

		private function onAddedToStageHandler( e:Event ):void
		{
			trace( "SlideShow::onAddedToStageHandler:" );
		}
		
		private function onRemovedFromStageHandler( e:Event ):void
		{
			trace( "SlideShow::onRemovedFromStageHandler:" );
		}		
	}
}
