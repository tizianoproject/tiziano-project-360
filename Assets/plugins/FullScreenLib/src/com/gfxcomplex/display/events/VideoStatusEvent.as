package com.gfxcomplex.display.events 
{
	import flash.events.Event;
	
	/**
	 * Status Event used to send info about the current video.
	 * @author Josh Chernoff | GFX Complex ~ copyright 2009
	 */
	public class VideoStatusEvent extends Event 
	{
		public static const ON_STATUS:String = "on_status";
		
		private var _status:String;
		
		public function VideoStatusEvent(type:String, status:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);		
			_status = status;
		} 
		
		public override function clone():Event 
		{ 
			return new VideoStatusEvent(type, _status, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("VideoStatusEvent", "type", "status", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get status():String { return _status; }
		
	}
	
}