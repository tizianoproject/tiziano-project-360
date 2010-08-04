package de.derhess.video.vimeo
{
    /**
     * Description
     * Class for managing the VimeoEvents for the VimeoWrapper Player
     * 
     * @author Florian Weil [derhess.de, Switzerland]
     */
     
	import flash.events.Event; 
	 
    public class VimeoEvent extends Event
    {
        //--------------------------------------------------------------------------
        //
        //  Class variables
        //
        //--------------------------------------------------------------------------
        public static const DURATION:String = "vimeoDurationChange";
		public static const STATUS:String = "vimeoStatus";
		public static const PLAYER_LOADED:String = "vimeoPlayerLoaded";
        //--------------------------------------------------------------------------
        //
        //  Initialization
        //
        //--------------------------------------------------------------------------
        
        public function VimeoEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false)
        {
            super(type, bubbles, cancelable);
            init();
        }
        /**
         * @private
         * Initializes the instance.
         */
        private function init():void
        {
            currentTime = 0;
			duration = 0;
			info = "";
        }
        
        //--------------------------------------------------------------------------
        //
        //  Variables
        //
        //--------------------------------------------------------------------------
        
        
        //--------------------------------------------------------------------------
        //
        //  Properties
        //
        //--------------------------------------------------------------------------
        public var currentTime:Number;
		public var duration:Number;
		public var info:String;
        
        //--------------------------------------------------------------------------
        //
        //  Additional getters and setters
        //
        //--------------------------------------------------------------------------
        
        
        
        //--------------------------------------------------------------------------
        //
        //  API
        //
        //--------------------------------------------------------------------------
        
        /**
         * Completely destroys the instance and frees all objects for the garbage
         * collector by setting their references to null.
         */
        public function destroy():void
        {
            
        }
        
        //--------------------------------------------------------------------------
        //
        //  Overridden methods: _SuperClassName_
        //
        //--------------------------------------------------------------------------
        override public function clone():Event 
        {	
        	var event:VimeoEvent = new VimeoEvent(type);
        	event.info = this.info;
        	event.currentTime = this.currentTime;
        	event.duration = this.duration;
            return event;
        }
        
        override public function toString():String 
        {
            return "VimeoEvent{info:" + info + ", currentTime:" + currentTime.toString()+",duration:"+duration.toString()+"}";
        }
        
        
        
    }
}