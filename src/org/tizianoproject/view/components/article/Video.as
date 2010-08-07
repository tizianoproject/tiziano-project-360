/** -----------------------------------------------------------
 * YouTube Video Player
 * -----------------------------------------------------------
 * Description: 
 * - ---------------------------------------------------------
 * Created by: cmendez@tizianoproject.org
 * Modified by: 
 * Date Modified:
 * - ---------------------------------------------------------
 * Copyright ©2010
 * - ---------------------------------------------------------
 *
 * Excellent References
 * http://code.google.com/apis/youtube/flash_api_reference.html#Examples
 * http://code.google.com/p/gdata-samples/source/browse/trunk/ytplayer/actionscript3/com/google/youtube/examples/AS3Player.as
 */
package org.tizianoproject.view.components.article
{
	import com.chrisaiv.utils.ShowHideManager;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Point;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.text.TextField;
	
	import org.tizianoproject.view.CompositeView;
	
	public class Video extends CompositeView
	{	
		private static const DEFAULT_POS:Point = new Point( 35, 105 );
		
		private static const DEFAULT_WIDTH:Number = 451;
		private static const DEFAULT_HEIGHT:Number = 370;
		
		private static const YOU_TUBE_PLAYER_URL:String = "http://www.youtube.com/v/";
		//Use this if you want to create your own custom chrome
		private static const YOU_TUBE_API_PLAYER_URL:String = "http://www.youtube.com/apiplayer"; 
		private static const YOU_TUBE_API_VERSION:String = "3";
		private static const YOUTUBE_API_PREFIX:String = "http://gdata.youtube.com/feeds/api/videos/";
		private static const QUALITY_TO_PLAYER_WIDTH:Object = { small: 320, medium: 640, large: 854, hd720: 1280 };

		//YouTube
		private var youtubeApiLoader:URLLoader;
		private var player:Object;
		private var loader:Loader;
		
		private var _aspectRatio:String;

		public function Video( )
		{
			setupYouTubeApiLoader();
		}

		public function load( id:String, ratio:String ):void
		{
			aspectRatio = ratio;
			
			var urlVars:URLVariables = new URLVariables();
				urlVars.cache_clear = new Date().getTime();
				urlVars.version = YOU_TUBE_API_VERSION;
					
			var request:URLRequest = new URLRequest();
				request.method = URLRequestMethod.GET;
				request.url = YOU_TUBE_PLAYER_URL + id;
				request.data = urlVars;
			
			loader = new Loader();
			loader.name = "loader";
			loader.contentLoaderInfo.addEventListener(Event.INIT, onLoaderInit);
			loader.load( request );
			
			//Load the Aspect Ratio Information
			try {
				youtubeApiLoader.load( new URLRequest(YOUTUBE_API_PREFIX + id ));
			} catch (error:SecurityError) {
				trace("A SecurityError occurred while loading", request.url);
			}
		}
		
		private function onLoaderInit( e:Event ):void
		{
			loader.content.addEventListener("onReady", onPlayerReady);
			loader.content.addEventListener("onError", onPlayerError);
			loader.content.addEventListener("onStateChange", onPlayerStateChange);
			loader.content.addEventListener("onPlaybackQualityChange", onVideoPlaybackQualityChange);
			ShowHideManager.addContent( (this as Video), loader );
		}
		
		private function unloadPlayer():void
		{
			if( player ){
				player.stopVideo();
				player.destroy();
			}			
		}
		
		private function setupYouTubeApiLoader():void {
			youtubeApiLoader = new URLLoader();
			youtubeApiLoader.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler, false, 0, true );
			youtubeApiLoader.addEventListener(Event.COMPLETE, youtubeApiLoaderCompleteHandler, false, 0, true );
		}

		//Not used yet
		private function youtubeApiLoaderCompleteHandler( e:Event ):void
		{
			var atomData:String = youtubeApiLoader.data;
			// Parse the YouTube API XML response and get the value of the aspectRatio element.
			var atomXml:XML = new XML(atomData);
			var aspectRatios:XMLList = atomXml..*::aspectRatio;
		}
		
		private function unloadLoader():void
		{
			ShowHideManager.removeContent( (this as Video), "loader" );
			if( loader ) loader.unload();	
		}
		
		private function onPlayerReady( e:Event ):void
		{
			// Event.data contains the event parameter, which is the Player API ID 
			trace("Video::onPlayerReady:", Object(e).data);

			// Once this event has been dispatched by the player, we can use
			// cueVideoById, loadVideoById, cueVideoByUrl and loadVideoByUrl
			// to load a particular YouTube video.
			player = loader.content;
			player.x = DEFAULT_POS.x;
			player.y = DEFAULT_POS.y;
			setQuality( QUALITY_TO_PLAYER_WIDTH.medium );
			resizePlayer(  );
		}
		
		private function setQuality( suggestedQuality:String ):void
		{
			player.setPlaybackQuality( suggestedQuality );
		}
		
		private function resizePlayer():void
		{
			var newHeight:Number
			if( aspectRatio == "16:9" ) newHeight = DEFAULT_WIDTH * 9 / 16;
			else newHeight = DEFAULT_WIDTH * 3 / 4; 
			
			player.setSize( DEFAULT_WIDTH, newHeight );
		}

		// Event.data contains the event parameter, which is the error code
		private function onPlayerError( e:Event ):void
		{
			trace( "Video::onPlayerError", Object(e).data );
		}

		// Event.data contains the event parameter, which is the new player state
		private function onPlayerStateChange( e:Event ):void
		{
			trace( "Video::onPlayerStateChange", Object(e).data );
		}

		// Event.data contains the event parameter, which is the new video quality
		private function onVideoPlaybackQualityChange( e:Event ):void
		{
			trace( "Video::onVideoPlaybackQualityChange", Object(e).data );
		}

		override protected function unload():void
		{
			trace( "Video::unload:" );
			unloadLoader()
			unloadPlayer();
		}
		
		/**********************************
		 * Event Handlers
		 **********************************/
		private function onErrorHandler( e:ErrorEvent ):void
		{
			trace( "Video::onErrorHandler:", e.currentTarget, e.text );
		}
		
		/**********************************
		 * Getters Setters
		 **********************************/
		private function set aspectRatio( value:String ):void
		{
			_aspectRatio = value;
		}
		
		private function get aspectRatio( ):String
		{
			return _aspectRatio;
		}
	}
}