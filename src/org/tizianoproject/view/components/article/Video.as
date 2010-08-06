/** -----------------------------------------------------------
 * YouTube Video Player
 * -----------------------------------------------------------
 * Description: 
 * - ---------------------------------------------------------
 * Created by: cmendez@tizianoproject.org
 * Modified by: 
 * Date Modified: June 22, 2010
 * - ---------------------------------------------------------
 * Copyright ©2010
 * - ---------------------------------------------------------
 *
 * http://code.google.com/apis/youtube/flash_api_reference.html#Examples
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
		
		//YouTube
		private var player:Object;
		private var loader:Loader;

		public function Video( )
		{
		}

		public function initPlayer( id:String ):void
		{
			var urlVars:URLVariables = new URLVariables();
				urlVars.cache_clear = new Date().getTime();
				urlVars.version = "3"
					
			var request:URLRequest = new URLRequest();
				request.method = URLRequestMethod.GET;
				request.url = "http://www.youtube.com/v/" + id;
				//request.url = "http://www.youtube.com/apiplayer";
				request.data = urlVars;
			
			loader = new Loader();
			loader.name = "loader";
			loader.contentLoaderInfo.addEventListener(Event.INIT, onLoaderInit);
			loader.load( request );
		}
		
		private function onLoaderInit( e:Event ):void
		{
			loader.content.addEventListener("onReady", onPlayerReady);
			loader.content.addEventListener("onError", onPlayerError);
			loader.content.addEventListener("onStateChange", onPlayerStateChange);
			loader.content.addEventListener("onPlaybackQualityChange", onVideoPlaybackQualityChange);
			ShowHideManager.addContent( (this as Video), loader );
		}
		
		private function onPlayerLoadedHandler( e:Event ):void
		{
		}
		
		private function unloadPlayer():void
		{
			if( player ){
				player.stopVideo();
				player.destroy();
			}			
		}
		
		private function unloadLoader():void
		{
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
			setQuality( "medium" );
			player.setSize( DEFAULT_WIDTH, DEFAULT_HEIGHT );
		}
		
		private function setQuality( suggestedQuality:String ):void
		{
			/*
			* Quality level small: Player resolution less than 640px by 360px.
			* Quality level medium: Minimum player resolution of 640px by 360px.
			* Quality level large: Minimum player resolution of 854px by 480px.
			* Quality level hd720: Minimum player resolution of 1280px by 720px.			
			*/			
			player.setPlaybackQuality( suggestedQuality );
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
			trace( "Video::onErrorHandler:", e.text );
		}		
	}
}