/** -----------------------------------------------------------
 * Vimeo Video Player
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
 *
 */
package org.tizianoproject.view.components.article
{
	import com.chrisaiv.utils.ShowHideManager;
	
	import de.derhess.video.vimeo.VimeoEvent;
	import de.derhess.video.vimeo.VimeoPlayer;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.Video;
	import flash.text.TextField;
	import flash.utils.describeType;
	
	import org.tizianoproject.view.CompositeView;
	
	public class Video extends CompositeView
	{
		private static const DEFAULT_POS:Point = new Point( 35, 105 );
		private static const DEFAULT_WIDTH:Number = 451;
		private static const DEFAULT_HEIGHT:Number = 256;
		
		private var _consumerKey:String;
		
		private var vimeoPlayer:VimeoPlayer;
		
		private var isPlaying:Boolean;

		public function Video( )
		{
		}

		public function stopVideo():void
		{
			if( vimeoPlayer){
				if( isPlaying ){
					//vimeoPlayer.stop();
					vimeoPlayer.unloadVideo();
					isPlaying = false;
				}				
			}
		}		

		public function load( id:Number ):void
		{
			isPlaying = false;
			//A video player already exists
			if( vimeoPlayer ) vimeoPlayer.loadVideo( id );
			//Create video player
			else initVimeoPlayer( id );
		}
		
		private function initVimeoPlayer( id:Number ):void
		{
			//Load new video
			vimeoPlayer = new VimeoPlayer( consumerKey, id, DEFAULT_WIDTH, DEFAULT_HEIGHT );
			vimeoPlayer.addEventListener( VimeoEvent.PLAYER_LOADED, vimeoLoadedHandler, false, 0, true );
			vimeoPlayer.addEventListener( VimeoEvent.DURATION, vimeoDurationHandler, false, 0, true );
			vimeoPlayer.addEventListener( VimeoEvent.STATUS, vimeoStatusHandler, false, 0, true );
			vimeoPlayer.name = "vimeoPlayer";
			vimeoPlayer.x = DEFAULT_POS.x;
			vimeoPlayer.y = DEFAULT_POS.y;
			ShowHideManager.addContent( (this as Video), vimeoPlayer );	
		}
		
		override protected function unload():void
		{
			trace( "Video::unload:" );
			stopVideo();
		}
		
		/**********************************
		 * Event Handlers
		 **********************************/
		private function vimeoLoadedHandler( e:VimeoEvent ):void
		{
			trace( "Video::vimeoLoadedHandler:", e.type );
			isPlaying = true;
		}

		private function vimeoDurationHandler( e:VimeoEvent ):void
		{
			trace( "Video::vimeoDurationHandler:", e.duration );
		}

		private function vimeoStatusHandler( e:VimeoEvent ):void
		{
			trace( "Video::vimeoStatusHandler:", e.type, e.info );
			switch( e.info ){
				case "vimeoNewVideo":
					break;
			}
		}

		/**********************************
		 * Read Write Accessors
		 **********************************/
		public function set consumerKey( value:String ):void
		{
			_consumerKey = value;
		}
		
		public function get consumerKey():String
		{
			return _consumerKey;
		}
	}
}