package org.tizianoproject.view
{
	import flash.events.Event;
	import flash.geom.Point;
	
	import org.tizianoproject.events.BaseViewEvent;
	import org.tizianoproject.model.IModel;

	public class ProfileView extends CompositeView
	{
		private static const DEFAULT_POS:Point = new Point( 65, 71 );
		
		private var iModel:IModel;
		
		public var baseView_mc:BaseView;		
		
		public function ProfileView( m:IModel )
		{
			x = DEFAULT_POS.x;
			y = DEFAULT_POS.y;

			iModel = m;
		}

		override protected function init():void
		{
			baseView_mc.addEventListener( BaseViewEvent.CLOSE, onBaseCloseHandler, false, 0, true );
		}

		override protected function resize():void
		{

		}

		override protected function unload():void
		{
	
		}
		
		public function load( name:String ):void
		{
			//trace( "ProfileView::load:", iModel.getAuthorByName( name ) );
		}

		private function onBaseCloseHandler( e:BaseViewEvent ):void
		{
			dispatchEvent( e );
		}		
	}
}