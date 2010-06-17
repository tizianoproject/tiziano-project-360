package 
{
	import com.gfxcomplex.display.events.VideoStatusEvent;
	import com.gfxcomplex.display.FullScreenAlign;
	import com.gfxcomplex.display.FullScreenVideo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	/**
	 * ...
	 * @author Josh Chernoff | GFX Complex
	 * @version Beta 1
	 */
	public class VideoMain extends MovieClip 
	{
		private var nc:NetConnection;
		private var ns:NetStream;
		private var video:Video;
		
		public function VideoMain():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			var testing:FullScreenVideo = new FullScreenVideo("http://www.istockphoto.com/video_headers/video_1.flv", FullScreenAlign.CENTER, 1, 2, true);
			testing.addEventListener(VideoStatusEvent.ON_STATUS, onStatus);
			addChild(testing);

		}
		
		private function onStatus(e:VideoStatusEvent):void 
		{
			trace(e.status);
		}
	}
}