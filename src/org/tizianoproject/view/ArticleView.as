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
 * var students:Array = new Array("ashna-lg.jpg", "dilpak-lg.jpg", "mohamad-lg.jpg", "mustafa-lg.jpg", "rasi-lg.jpg", "rebin-lg.jpg", "sevina-lg.jpg", "shivan-lg.jpg", "zana-lg.jpg");
 *
 */

package org.tizianoproject.view
{
	import com.chargedweb.swfsize.SWFSizeEvent;
	import com.chrisaiv.utils.ShowHideManager;
	import com.tis.utils.components.Scrollbar;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import org.casalib.util.NumberUtil;
	import org.tizianoproject.controller.IController;
	import org.tizianoproject.events.BaseViewEvent;
	import org.tizianoproject.model.IModel;
	import org.tizianoproject.view.components.Feature;
	import org.tizianoproject.view.components.FeatureHolder;
	import org.tizianoproject.view.components.article.Scroller;
	import org.tizianoproject.view.components.article.Slideshow;
	import org.tizianoproject.view.components.article.Text;
	import org.tizianoproject.view.components.article.Video;
	
	public class ArticleView extends CompositeView
	{
		private static const DEFAULT_TITLE:String = "DEFAULT_TITLE";
		private static const DEFAULT_AUTHOR:String = "DEFAULT_AUTHOR";

		//This is the height of the Top Header
		private static const DEFAULT_Y_POS:Number = 71;		
		
		//1/2 Close_btn is 20px.  Use the negative in order to adjust centering
		//This is the Default Width + Close Button
		private static const MIN_WIDTH:Number = 900;
		//This is the Default Height
		private static const MIN_HEIGHT:Number = 600;

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
		
		private var xPos:Number;
		private var yPos:Number;
		private var fullscreenXPos:Number;
		private var fullscreenYPos:Number;

		public function ArticleView( m:IModel, c:IController=null )
		{
			super( m, c );
			
			
			prev_btn.addEventListener(MouseEvent.ROLL_OVER, onRollOverHandler, false, 0, true );
			prev_btn.addEventListener(MouseEvent.ROLL_OUT, onRollOutHandler, false, 0, true );
			prev_btn.addEventListener(MouseEvent.CLICK, onMouseClickHandler, false, 0, true );
			
			next_btn.addEventListener(MouseEvent.ROLL_OVER, onRollOverHandler, false, 0, true );
			next_btn.addEventListener(MouseEvent.ROLL_OUT, onRollOutHandler, false, 0, true );
			next_btn.addEventListener(MouseEvent.CLICK, onMouseClickHandler, false, 0, true );			

			addEventListener( Event.ADDED_TO_STAGE, onAddedToStageHandler, false, 0, true );
			addEventListener( Event.ADDED, onAddedHandler, false, 0, true );
			addEventListener( Event.REMOVED_FROM_STAGE, onRemovedFromStageHandler, false, 0, true );
			//Listen for when the user clicks on the [ X ] button
			baseView_mc.addEventListener( BaseViewEvent.CLOSE, onBaseCloseHandler, false, 0, true );			
		}
		
		private function recordPosition( w:Number, h:Number ):void
		{
			if( stage ){
				if( stage.displayState == "normal" || stage.displayState == null ){
					var browserWidth:Number = ( w > MIN_WIDTH ) ? w : MIN_WIDTH;
					var browserHeight:Number = ( h > MIN_HEIGHT ) ? h : MIN_HEIGHT ;
					xPos = ( browserWidth / 2) - ( MIN_WIDTH / 2 );
					yPos = ( browserHeight / 2 ) - ( MIN_HEIGHT / 2 );
				}
			}
		}
		
		private function updatePosition( xx:Number, yy:Number ):void
		{
			x = xx;
			y = ( yy > + DEFAULT_Y_POS ) ? yy : DEFAULT_Y_POS;
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
		private function unloadStories():void
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
			//Mainly done for Local Testing
			recordPosition( stage.stageWidth, stage.stageHeight )
			updatePosition( xPos, yPos );
			
			stage.addEventListener(FullScreenEvent.FULL_SCREEN, onFullScreenHandler, false, 0, true );
			trace( "ArticleView::onAddedToStageHandler:" );
			
			//Load a new Story
			//initNewStory();				
		}
		
		private function onFullScreenHandler( e:FullScreenEvent ):void
		{
			trace( "ArticleView::onFullScreenHandler:", stage.fullScreenWidth, stage.fullScreenHeight );
			if( e.fullScreen ){
				updatePosition( stage.fullScreenWidth / 2 - ( MIN_WIDTH / 2 ), stage.fullScreenHeight / 2 - ( MIN_HEIGHT / 2 ) );
			} else {
				updatePosition( xPos, yPos );				
			}
		}

		public function swfSizerHandler( e:SWFSizeEvent ):void
		{
			trace( "ArticleView::swfSizerHandler:", e.type, e.windowWidth, e.windowHeight );
			recordPosition( e.windowWidth, e.windowHeight );
			updatePosition( xPos, yPos );				
		}

		private function onAddedHandler( e:Event ):void
		{
			//trace( "ArticleView::onAddedHandler:", e.target );
		}

		private function onRemovedFromStageHandler( e:Event ):void
		{
			//trace( "ArticleView::onRemovedFromStageHandler:" );
			unloadStories();
		}
		
		private function onFeatureHolderRemovedHandler( e:Event ):void
		{
			//trace( "ArticleView::onFeatureHolderRemovedHandler:", featureHolder.numChildren );
		}
		
		private function onBaseCloseHandler( e:BaseViewEvent ):void
		{
			//trace( e.results.viewName, "::onBaseCloseHandler:" );
			dispatchEvent( e );
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
			unloadStories();
		}
		
		override public function update(e:Event=null):void
		{
			
		}
	}
}