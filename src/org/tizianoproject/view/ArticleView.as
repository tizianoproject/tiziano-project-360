package org.tizianoproject.view
{
	import com.chrisaiv.utils.ShowHideManager;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import org.casalib.util.NumberUtil;
	import org.tizianoproject.view.components.Feature;
	import org.tizianoproject.view.components.article.Text;
	
	public class ArticleView extends MovieClip
	{
		private static const DEFAULT_TITLE:String = "DEFAULT_TITLE";
		private static const DEFAULT_AUTHOR:String = "DEFAULT_AUTHOR";
		private static const DEFAULT_X_POS:Number = 65;
		private static const DEFAULT_Y_POS:Number = 71;

		public var eDispatcher:EventDispatcher;
		
		//Views
		public var title_txt:TextField;
		public var author_txt:TextField;
		
		public var baseView_mc:BaseView;
		public var authorType_mc:MovieClip;
		public var prev_btn:SimpleButton;
		public var next_btn:SimpleButton;

		private var text:Text;

		private var features:Array;
		private var feature:Feature;

		public function ArticleView()
		{
			x = DEFAULT_X_POS;
			y = DEFAULT_Y_POS;
											
			eDispatcher = new EventDispatcher();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler, false, 0, true );
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStageHandler, false, 0, true );
		}
		
		private function onAddedToStageHandler( e:Event ):void
		{
			trace( "ArticleView::onAddedToStageHandler:" );

			title_txt.text = DEFAULT_TITLE;
			author_txt.text = DEFAULT_AUTHOR;
			
			var random:uint = NumberUtil.randomWithinRange( 1, 3 );
			authorType_mc.gotoAndStop( random );
			
			features = new Array();
			for( var i:uint = 0; i < 5; i++ ){
				feature = new Feature();
				feature.name = "feature" + i;
				feature.yPos = (i * feature.height); 
				ShowHideManager.addContent( (this as ArticleView), feature );
				features.push( feature );
			}
			
			text = new Text();
			text.name = "text";
			ShowHideManager.addContent( (this as ArticleView), text ); 			

			prev_btn.addEventListener(MouseEvent.ROLL_OVER, onRollOverHandler, false, 0, true );
			prev_btn.addEventListener(MouseEvent.ROLL_OUT, onRollOutHandler, false, 0, true );
			prev_btn.addEventListener(MouseEvent.CLICK, onMouseClickHandler, false, 0, true );
			
			next_btn.addEventListener(MouseEvent.ROLL_OVER, onRollOverHandler, false, 0, true );
			next_btn.addEventListener(MouseEvent.ROLL_OUT, onRollOutHandler, false, 0, true );
			next_btn.addEventListener(MouseEvent.CLICK, onMouseClickHandler, false, 0, true );
			
			baseView_mc.eDispatcher.addEventListener( Event.CLOSE, onEventCloseHandler );
		}
		
		private function onRemovedFromStageHandler( e:Event ):void
		{
			//trace( "ArticleView::onRemovedFromStageHandler:" );
			//Remove everything from the ArticleView, it cuts down on Memory
			ShowHideManager.unloadContent( (this as ArticleView ) );
		}
		
		private function onEventCloseHandler( e:Event ):void
		{
			//trace( "ArticleView::onEventCloseHandler:" );
			eDispatcher.dispatchEvent( new Event( Event.CLOSE ) );
		}
		
		private function onRollOverHandler( e:MouseEvent ):void
		{
			//trace( "ArticleView::onRollOverHandler:", e.currentTarget.name );
		}
		
		private function onRollOutHandler( e:MouseEvent ):void
		{
			//trace( "ArticleView::onRollOutHandler:", e.currentTarget.name );
		}
		
		private function onMouseClickHandler( e:MouseEvent ):void
		{
			//trace( "ArticleView:onMouseClickHandler", e.currentTarget.name );
		}
	}
}