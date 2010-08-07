
package org.tizianoproject.events
{
	import flash.events.Event;
	
	public class StoryEvent extends Event
	{
		public static const NEW_STORY:String = "newStory";
		public static const INIT:String  = "init";
		
		public var results:*;
		
		//You place the custom value as the second param so that you don't have to manually fill in the other args beforehand
		public function StoryEvent(type:String, customArg:*=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this.results = customArg;
		}
		
		//THis is necessary to insure that event will behave properly if you need to redispatch it
		//If you don't create a clone, none of the attributes will carry through and you'll get a nasty error
		public override function clone():Event
		{
			return new StoryEvent( type, results, bubbles, cancelable );
		}
		
		public override function toString():String
		{
			return formatToString( "StoryEvent", "type", "results", "bubbles", "cancelable", "eventPhase" );	
		}
	}
}