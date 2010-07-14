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
	
	import nl.demonsters.debugger.MonsterDebugger;
	
	import org.casalib.util.NumberUtil;
	import org.tizianoproject.controller.IController;
	import org.tizianoproject.events.BaseViewEvent;
	import org.tizianoproject.model.IModel;
	import org.tizianoproject.model.vo.Story;
	import org.tizianoproject.view.components.Feature;
	import org.tizianoproject.view.components.FeatureHolder;
	import org.tizianoproject.view.components.article.Scroller;
	import org.tizianoproject.view.components.article.Slideshow;
	import org.tizianoproject.view.components.article.SoundSlide;
	import org.tizianoproject.view.components.article.Text;
	import org.tizianoproject.view.components.article.Video;
	
	public class ArticleView extends CompositeView
	{
		private static const STORY_TYPE:Array = new Array( "text", "video", "slideshow", "soundslide" );
		private static const DEFAULT_TITLE:String = "DEFAULT_TITLE";
		private static const DEFAULT_AUTHOR:String = "DEFAULT_AUTHOR";

		//This is the height of the Top Header
		private static const DEFAULT_Y_POS:Number = 71;	

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
		private var soundslide:SoundSlide;

		private var feature:Feature;
		private var featureHolder:FeatureHolder;		
		private var featureScrollBar:Scroller;
		
		private var browserWidth:Number;
		private var browserHeight:Number;
		private var defaultWidth:Number;
		private var defaultHeight:Number;

		private var _currentIndex:Number;		
		private var _stories:Array;

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
		
		private function init():void
		{
			currentIndex = 0;
			
			stage.addEventListener(FullScreenEvent.FULL_SCREEN, onFullScreenHandler, false, 0, true );
			defaultWidth  = stage.stageWidth;
			defaultHeight = stage.stageHeight;
			updatePosition( );
		}
		
		public function loadStory( ):void
		{					
			title_txt.text = DEFAULT_TITLE;
			author_txt.text = DEFAULT_AUTHOR;
			
			/***** Temporary Code Starts *****/
			//Features Holder holds the features
//			initFeatureHolder();

			//Add new Related Features
//			initFeatures( NumberUtil.randomWithinRange( 1, 10 ) );

			var random:uint = NumberUtil.randomWithinRange( 0, 4 );
			
			//Switch the Author
			showAuthorType( random );
			
			var story:Story = stories[currentIndex] as Story
				
			switch( story.type ){
				case "text":
					initText();
					break;
				case "slideshow":
					initSlideshow();
					break;
				case "video":
					initVideo( story );
					break;
				case "soundslide":
					initSoundSlide( story );
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
		
		private function initVideo( story:Story ):void
		{
			video = new Video();
			video.name = "video";
			video.consumerKey = story.vimeoConsumerKey;
			video.load( story.vimeoID );
			ShowHideManager.addContent( (this as ArticleView), video );
		}
		
		private function initSoundSlide( story:Story ):void
		{
			soundslide = new SoundSlide();
			soundslide.name = "soundslide";
			trace( "ArticleView::initSoundSlide:", story.path );
			soundslide.load( story.path );
			ShowHideManager.addContent( (this as ArticleView), soundslide );
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
			ShowHideManager.removeContent( (this as ArticleView), "soundslide" );
			ShowHideManager.removeContent( (this as ArticleView), "featureScrollBar" );
			
			//Delete any feature in the featureHolder
			//ShowHideManager.unloadContent( featureHolder );
			ShowHideManager.removeContent( (this as ArticleView), "featureHolder" );
			
			loadStory();
		}

		/**********************************
		 * Update Position
		 **********************************/
		private function updatePosition( ):void
		{
			if( stage ){
				if( stage.displayState == "fullScreen" ){
					x = stage.fullScreenWidth / 2 - ( MIN_WIDTH / 2 );
					y = stage.fullScreenHeight / 2 - ( MIN_HEIGHT / 2 );
				} else {
					if( browserWidth && browserHeight ){
						var dynWidth:Number = ( browserWidth > MIN_WIDTH) ? browserWidth : MIN_WIDTH;
						var dynHeight:Number = ( browserHeight > MIN_HEIGHT ) ? browserHeight : MIN_HEIGHT ;
						var yPos:Number = ( dynHeight / 2) - ( MIN_HEIGHT / 2 );
						x = ( dynWidth / 2) - ( MIN_WIDTH / 2 );
						y = ( yPos > + DEFAULT_Y_POS ) ? yPos : DEFAULT_Y_POS;
					}
						//App is loading without a browser
					else {
						x = (defaultWidth / 2) - ( MIN_WIDTH / 2 );
						y = ( (defaultHeight - DEFAULT_Y_POS) / 2) - ( MIN_HEIGHT / 2 ) + DEFAULT_Y_POS;
					}
				}
			}
		}
		
		/**********************************
		 * Event Handlers
		 **********************************/
		public function swfSizerHandler( e:SWFSizeEvent ):void
		{
			browserWidth = e.windowWidth;
			browserHeight = e.bottomY;
			
			trace( "ArticleView::swfSizerHandler:" );
			updatePosition( );
		}
		

		private function onAddedToStageHandler( e:Event ):void
		{
			init();
		}
		
		private function onFullScreenHandler( e:FullScreenEvent ):void
		{
			trace( "ArticleView::onFullScreenHandler:", stage.fullScreenWidth, stage.fullScreenHeight );
			updatePosition();
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
			trace( "ArticleView:onMouseClickHandler", e.currentTarget.name );
			if( e.currentTarget.name == "next_btn" ){
				if( currentIndex == stories.length - 1 ) currentIndex = 0;
				else currentIndex++;
				
			} else if( e.currentTarget.name == "prev_btn" ){
				if( currentIndex == 0 ) currentIndex = stories.length - 1;
				else currentIndex--;
			} 
			unloadStories();
		}
		
		/**********************************
		 * Getters Setters
		 **********************************/
		public function set stories( value:Array ):void
		{
			_stories = value;	
		}
		
		public function get stories():Array
		{
			return _stories;
		}
		
		public function set currentIndex( value:Number ):void
		{
			_currentIndex = value;
		}
		
		public function get currentIndex():Number
		{
			return _currentIndex;
		}
		
		/**********************************
		 * 
		 **********************************/
		override public function update(e:Event=null):void
		{
			
		}
	}
}