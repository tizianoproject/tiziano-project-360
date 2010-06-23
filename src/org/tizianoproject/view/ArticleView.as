package org.tizianoproject.view
{
	import com.chrisaiv.utils.ShowHideManager;
	import com.tis.utils.components.Scrollbar;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import org.casalib.util.NumberUtil;
	import org.tizianoproject.view.components.Feature;
	import org.tizianoproject.view.components.article.Slideshow;
	import org.tizianoproject.view.components.article.Text;
	import org.tizianoproject.view.components.article.Video;
	
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
		private var slideshow:Slideshow;
		private var video:Video;

		private var features:Array;
		private var feature:Feature;
		private var featureHolder:MovieClip;
		
		private var scrollBar:Scrollbar;
		

		public function ArticleView()
		{
			x = DEFAULT_X_POS;
			y = DEFAULT_Y_POS;
											
			eDispatcher = new EventDispatcher();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler, false, 0, true );
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStageHandler, false, 0, true );
		}
		
		private function initFeatures():void
		{
			//Collect all the Features in an Array
			initFeaturesHolder();
			
			features = new Array();
			var columns:Number = 1;
			for( var i:Number = 0; i < 10; i++ ){
				var xx:Number = i%columns;
				var yy:Number = Math.floor(i/columns);
				
				feature = new Feature();
				feature.name = "feature" + i;
				//I am overriding y property in order to add DEFAULT_Y_POS
				feature.y = (i * feature.height);
				features.push( feature );
				ShowHideManager.addContent( featureHolder, feature );
			}			
			
			//Create the Features Holder
			scrollBar = new Scrollbar( featureHolder );
			scrollBar.name = "scrollBar";
			ShowHideManager.addContent( (this as ArticleView), scrollBar );
		}
		
		private function initFeaturesHolder():void
		{
			featureHolder = new MovieClip();
			featureHolder.tabEnabled = false;
			featureHolder.name = "featureHolder";
			featureHolder.graphics.beginFill( 0xff00ff, 1 );
			featureHolder.graphics.drawRect( 0, 0, 360, 500 );
			featureHolder.graphics.endFill();
			featureHolder.x = 530;
			featureHolder.y = 73;
			ShowHideManager.addContent( (this as ArticleView), featureHolder );
		}
		
		
		/**********************************
		 * Event Handlers
		 **********************************/
		private function onAddedToStageHandler( e:Event ):void
		{
			//Add new Related Features
			initFeatures();

			title_txt.text = DEFAULT_TITLE;
			author_txt.text = DEFAULT_AUTHOR;
			
			var random:uint = NumberUtil.randomWithinRange( 1, 3 );
			authorType_mc.gotoAndStop( random );
			
			/*
			text = new Text();
			text.name = "text";
			ShowHideManager.addContent( (this as ArticleView), text );
			*/
			/*
			slideshow = new Slideshow();
			slideshow.name = "slideshow";
			ShowHideManager.addContent( (this as ArticleView), slideshow );
			*/
			
			video = new Video();
			video.name = "video";
			ShowHideManager.addContent( (this as ArticleView), video );
			

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
			eDispatcher.dispatchEvent( e );
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