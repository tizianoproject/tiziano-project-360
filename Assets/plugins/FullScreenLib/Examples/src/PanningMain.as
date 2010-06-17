package 
{

	import com.gfxcomplex.display.PanningFullScreenImage;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	
	/**
	 * ...
	 * @author ...
	 */
	public class PanningMain extends Sprite 
	{
		private var testing:PanningFullScreenImage;
		public function PanningMain():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			testing = new PanningFullScreenImage("http://gfxcomplex.com/images/TBK77337_Edit.jpg", true); 
			testing.addEventListener(Event.COMPLETE, onComplete);
			testing.addEventListener(ProgressEvent.PROGRESS, onProgress);
			addChild(testing);
			
			stage.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onClick(e:MouseEvent):void 
		{
			stage.displayState = StageDisplayState.FULL_SCREEN;
		}
		
		private function onProgress(e:ProgressEvent):void 
		{
			trace(String(int((e.bytesLoaded / e.bytesTotal) * 100)));
			loading_txt.text = String(int((e.bytesLoaded / e.bytesTotal) * 100));
		}
		
		private function onComplete(e:Event):void 
		{
			trace(e);
		}
		
	}
	
}