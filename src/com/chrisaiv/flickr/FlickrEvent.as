/** -----------------------------------------------------------
* Flickr Loader
* -----------------------------------------------------------
* Description: Generic Flickr Event that carries over
* - ---------------------------------------------------------
* Created by: cmendez@tizianoproject.org
* Modified by: 
* Date Modified: June 20, 2010
* - ---------------------------------------------------------
* Copyright ©2009
* - ---------------------------------------------------------
*
*
*/

package com.chrisaiv.flickr
{
	import flash.events.Event;

	public class FlickrEvent extends Event
	{
		//Allow this Event to be Specified, think MouseEvent.CLICK
		public static const CUSTOM:String = "custom";
		
		//Public property you want to send with the event
		public var arg:*;
		
		//You place the custom value as the second param so that you don't have to manually fill in the other args beforehand
		public function FlickrEvent(type:String, customArg:*=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this.arg = customArg;
		}
		
		//This is necessary to insure that your event will behave properly if you need to redispatch it
		//If you don't create a clone, non of the attributes will carry through and you'll get a nasty error
		public override function clone():Event
		{
			return new FlickrEvent( type, arg, bubbles, cancelable );
		}
		
		//This allows your custom class to appear in any trace() of the event
		public override function toString():String
		{
			return formatToString("FlickrEvent", "type", "arg", "bubbles", "cancelable", "eventPhase");
		}
		
	}
}