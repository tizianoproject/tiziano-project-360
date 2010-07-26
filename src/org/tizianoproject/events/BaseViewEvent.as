/** -----------------------------------------------------------
 * BaseView Event
 * -----------------------------------------------------------
 * Description: Event used for close_btn.addEventListener( MouseEvent.CLICK );
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

package org.tizianoproject.events
{
	import flash.events.Event;
	
	public class BaseViewEvent extends Event
	{
		public static const CLOSE:String = "close";
		public static const OPEN:String  = "open";
		
		public var results:*;
		
		//You place the custom value as the second param so that you don't have to manually fill in the other args beforehand
		public function BaseViewEvent(type:String, customArg:*=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this.results = customArg;
		}
		
		//THis is necessary to insure that event will behave properly if you need to redispatch it
		//If you don't create a clone, none of the attributes will carry through and you'll get a nasty error
		public override function clone():Event
		{
			return new BaseViewEvent( type, results, bubbles, cancelable );
		}
		
		public override function toString():String
		{
			return formatToString( "BaseViewEvent", "type", "results", "bubbles", "cancelable", "eventPhase" );	
		}
	}
}