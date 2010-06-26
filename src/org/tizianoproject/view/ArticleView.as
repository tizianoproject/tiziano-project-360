/** -----------------------------------------------------------
 * Article View
 * -----------------------------------------------------------
 * Description: Display either a Text-based story, a Photogallery, or Video 
 * - ---------------------------------------------------------
 * Created by: cmendez@tizianoproject.org
 * Modified by: 
 * Date Modified: June 22, 2010
 * - ---------------------------------------------------------
 * Copyright ©2010
 * - ---------------------------------------------------------
 *
 *
 */

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
	import org.tizianoproject.view.components.FeatureHolder;
	import org.tizianoproject.view.components.article.Scroller;
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

		private var feature:Feature;
		private var featureHolder:FeatureHolder;		
		private var featureScrollBar:Scroller;

		public function ArticleView()
		{
			x = DEFAULT_X_POS;
			y = DEFAULT_Y_POS;
		
			eDispatcher = new EventDispatcher();

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler, false, 0, true );
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStageHandler, false, 0, true );
		}
		
		private function initNewStory():void
		{
			title_txt.text = DEFAULT_TITLE;
			author_txt.text = DEFAULT_AUTHOR;
			
			/***** Temporary Code Starts *****/
			//Features Holder holds the features
			initFeatureHolder();

			//Add new Related Features
			initFeatures( NumberUtil.randomWithinRange( 1, 10 ) );

			var random:uint = NumberUtil.randomWithinRange( 0, 3 );
			
			//Switch the Author
			showAuthorType( random );
			
			switch( random ){
				case 0:
					initText();
					break;
				case 1:
					initSlideshow();
					break;
				case 2:
					initVideo();
					break;
			}
			/***** Temporary Code Ends *****/			
		}
		
		/**********************************
		 * Story Types
		 **********************************/
		private function initText():void
		{
			text = new Text();
			text.name = "text";
			ShowHideManager.addContent( (this as ArticleView), text );
		}
		
		private function initSlideshow():void
		{
			slideshow = new Slideshow();
			slideshow.name = "slideshow";
			ShowHideManager.addContent( (this as ArticleView), slideshow );			
		}
		
		private function initVideo():void
		{
			video = new Video();
			video.name = "video";
			ShowHideManager.addContent( (this as ArticleView), video );
		}
		
		/**********************************
		 * Features
		 **********************************/
		private function initFeatureHolder():void
		{
			//Collect all the Features in an Array
			featureHolder = new FeatureHolder();			
			featureHolder.name = "featureHolder";
			featureHolder.addEventListener(Event.REMOVED, onFeatureHolderRemovedHandler, false, 0, true );
			ShowHideManager.addContent( (this as ArticleView), featureHolder );			
		}
		
		private function initFeatures( number:Number ):void
		{			
			var totalFeatures:Number = number;
			var columns:Number = 1;
			for( var i:Number = 0; i < totalFeatures; i++ ){
				var xx:Number = i%columns;
				var yy:Number = Math.floor(i/columns);
				
				feature = new Feature();
				feature.name = "feature" + i;
				//I am overriding y property in order to add DEFAULT_Y_POS
				feature.y = (i * feature.height);
				ShowHideManager.addContent( featureHolder, feature );				
			}
			
			//Once Feature holder is populated, load the Scroller
			if( featureHolder.numChildren > 5 ) initFeatureScrollBar();
		}
		
		private function initFeatureScrollBar():void
		{
			//Create the Features Holder
			featureScrollBar = new Scroller( featureHolder );
			featureScrollBar.name = "featureScrollBar";
			ShowHideManager.addContent( (this as ArticleView), featureScrollBar );
		}
		
		private function showAuthorType( number:Number ):void
		{
			if( number == 1 ) authorType_mc.gotoAndStop( "mentor" );
			else if( number == 2 ) authorType_mc.gotoAndStop( "student" );
		}
		
		/**********************************
		 * Clean Up
		 **********************************/
		private function unloadStory():void
		{
			//Delete any Story on the stage
			ShowHideManager.removeContent( (this as ArticleView), "text" );
			ShowHideManager.removeContent( (this as ArticleView), "slideshow" );
			ShowHideManager.removeContent( (this as ArticleView), "video" );
			ShowHideManager.removeContent( (this as ArticleView), "featureScrollBar" );
			
			//Delete any feature in the featureHolder
			ShowHideManager.unloadContent( featureHolder );
			ShowHideManager.removeContent( (this as ArticleView), "featureHolder" );	
			
			initNewStory();
		}
		
		/**********************************
		 * Event Handlers
		 **********************************/
		private function onAddedToStageHandler( e:Event ):void
		{
			//Load a new Story
			initNewStory();
			
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
			trace( "ArticleView::onRemovedFromStageHandler:" );
			ShowHideManager.unloadContent( (this as ArticleView ) );
		}
		
		private function onFeatureHolderRemovedHandler( e:Event ):void
		{
			//trace( "ArticleView::onFeatureHolderRemovedHandler:", featureHolder.numChildren );
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
			unloadStory();
		}
	}
}