package org.tizianoproject.view
{
	import com.chrisaiv.utils.ShowHideManager;
	
	import flash.events.Event;
	import flash.geom.Point;
	
	import org.tizianoproject.events.BaseViewEvent;
	import org.tizianoproject.model.IModel;
	import org.tizianoproject.view.components.brick.Author;

	public class DirectoryView extends CompositeView
	{
		private static const DEFAULT_X_POS:Number = 65;
		private static const DEFAULT_Y_POS:Number = 71;
		private static const DEFAULT_COLUMNS:Number = 3;
		private static const DEFAULT_AUTHOR_POS:Point = new Point( 40, 97 );
		
		private var iModel:IModel;
		private var author:Author;

		public var baseView_mc:BaseView;
		
		public function DirectoryView( m:IModel )
		{
			iModel = m;
			
			x = DEFAULT_X_POS;
			y = DEFAULT_Y_POS;			
		}
		
		override protected function init():void
		{
			var students:Array = new Array("ashna-sm.jpg", "dilpak-sm.jpg", "mohamad-sm.jpg", "mustafa-sm.jpg", "rasi-sm.jpg", "rebin-sm.jpg", "sevina-sm.jpg", "shivan-sm.jpg", "zana-sm.jpg");
			
			createTable( students );			
		}
		
		private function createTable(authors:Array):void
		{
			var columns:Number = DEFAULT_COLUMNS;
			for( var i:Number = 0; i < authors.length; i++ ){
				var xx:Number = i%columns;
				var yy:Number = Math.floor(i/columns);
				author = new Author( );
				author.name = "author" + i;
				author.x = i * DEFAULT_AUTHOR_POS.x;
				author.y = i * DEFAULT_AUTHOR_POS.y;
				ShowHideManager.addContent( (this as StudentsView), author );
			}
		}

		/**********************************
		 * Event Handlers
		 **********************************/
		protected function onBaseCloseHandler( e:BaseViewEvent ):void
		{
			//trace( e.results.name, "::onBaseCloseHandler:" );
			dispatchEvent( e );
		}	
		
		override protected function onAddedToStageHandler( e:Event ):void
		{
			init();
			//Listen to BaseView::close_btn
			baseView_mc.addEventListener( BaseViewEvent.CLOSE, onBaseCloseHandler, false, 0, true );			
		}
	}
}
