package org.tizianoproject.view.components.profile
{
	import com.chrisaiv.utils.ShowHideManager;
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	import org.casalib.events.LoadEvent;
	import org.casalib.load.ImageLoad;
	
	public class RelatedAuthor extends MovieClip
	{
		private static const DEFAULT_POS:Point = new Point( 41, 510 );
		private static const MARGIN_RIGHT:Number = 20;
		
		private var loaderContext:LoaderContext;
		private var imageLoad;:ImageLoad
		
		private var _index:Number;
		
		public function RelatedAuthor()
		{			
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStageHandler, false, 0, true );
			addEventListener( Event.ADDED, onAddedHandler, false, 0, true );
			addEventListener( Event.REMOVED_FROM_STAGE, onRemovedFromStageHandler, false, 0, true );
		}

		private function init():void
		{
			loaderContext = new LoaderContext(true );
		}
		
		public function load( url:String ):void
		{
			imageLoad = new ImageLoad( new URLRequest( url ), loaderContext );
			imageLoad.addEventListener( LoadEvent.COMPLETE, onCompleteHandler, false, 0, true );
			imageLoad.start();
			ShowHideManager.addContent( (this as RelatedAuthor), imageLoad);
		}
		
		private function unload():void
		{
			imageLoad.destroy();	
		}		
		
		/**********************************
		 * Event Handlers
		 **********************************/
		private function onAddedHandler( e:Event ):void
		{
			//trace( "CompositeView::onAddedHandler:", e.target );
		}
		
		private function onAddedToStageHandler( e:Event ):void
		{
			init();
		}
		
		private function onRemovedFromStageHandler( e:Event ):void
		{
			unload();
		}		

		/**********************************
		 * Getters Setters
		 **********************************/
		public function set index( value:Number ):void
		{
			_index = value;
		}
		
		public function get index():Number
		{
			return _index;
		}
	}
}