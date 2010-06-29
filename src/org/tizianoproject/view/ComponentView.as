package org.tizianoproject.view
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	
	public class ComponentView extends MovieClip
	{
		protected var model:Object;
		protected var controller:Object;
		
		public function ComponentView( m:Object, c:Object = null )
		{
			model = c;
			controller = c;
		}
		
		public function add( c:ComponentView ):void
		{
			throw new IllegalOperationError( "add operation not supported" );
		}			
		
		public function remove( c:ComponentView ):void
		{
			throw new IllegalOperationError( "remove operation not supported" );
		}
		
		public function getChild( n:uint ):ComponentView
		{
			throw new IllegalOperationError( "getChild operation not supported" );
			return null;
		}
		
		public function update( e:Event = null ):void
		{
			
		}
	}
}