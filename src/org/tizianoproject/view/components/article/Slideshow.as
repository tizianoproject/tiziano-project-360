package org.tizianoproject.view.components.article
{
	import com.chrisaiv.utils.ShowHideManager;
	import com.dtk.ImageManager;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Slideshow extends MovieClip
	{
		private static const DEFAULT_X_POS:Number = 50;
		private static const DEFAULT_Y_POS:Number = 50;
		
		private var images:Array;
		private var im:ImageManager;
		
		public function Slideshow()
		{
			images = new Array();
			images.push( { url : 'http://www.as3dtk.com/swf/images2/driveway.jpg', title : 'Driveway' } );
			images.push( { url : 'http://www.as3dtk.com/swf/images2/2930.jpg', title : '2930' } );
			images.push( { url : 'http://www.as3dtk.com/swf/images2/tow-wall.jpg', title : 'Tow Away Wall' } );
			images.push( { url : 'http://www.as3dtk.com/swf/images2/gray-garage.jpg', title : 'Garage' } );
			images.push( { url : 'http://www.as3dtk.com/swf/images2/blue-doors.jpg', title : 'Blue Doors' } );

			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler, false, 0, true );
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStageHandler, false, 0, true );
		}

		private function onAddedToStageHandler( e:Event ):void
		{
			trace( "SlideShow::onAddedToStageHandler:" );
			im = new ImageManager( 400, 250, 10, images );
			im.name = "im";
			im.x = DEFAULT_X_POS;
			im.y = DEFAULT_Y_POS;
			ShowHideManager.addContent( (this as Slideshow), im );
		}
		
		private function onRemovedFromStageHandler( e:Event ):void
		{
			trace( "SlideShow::onRemovedFromStageHandler:" );
		}		

		
	}
}