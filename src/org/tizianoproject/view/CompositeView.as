package org.tizianoproject.view
{
	
	import flash.events.Event;

	public class CompositeView extends ComponentView
	{
		private var children:Array;
		
		public function CompositeView(m:Object, c:Object=null)
		{
			super(m, c);
			children = new Array();	
		}
		
		override public function add(c:ComponentView) : void
		{
			children.push( c );
		}
		
		override public function update(e:Event=null) : void
		{
			trace( ":::::::::::: " + new Date().getSeconds() + " :::::::::::::::" );
			//trace( "CompositeView::", e.type, ":" );

			//Calls an update method on all the children
			for each( var c:ComponentView in children )
			{
				c.update( e );
			}
		}
	}
}