package org.tizianoproject.view
{
	import com.chargedweb.swfsize.SWFSizeEvent;
	
	import flash.display.MovieClip;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	
	public class ComponentView extends MovieClip
	{
		public function ComponentView( )
		{
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
		
		//Resize Browser
		public function browserResize( e:SWFSizeEvent ):void
		{
			
		}
	}
}