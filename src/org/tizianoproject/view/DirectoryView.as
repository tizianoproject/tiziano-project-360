﻿package org.tizianoproject.view{	import com.chrisaiv.utils.ShowHideManager;	import com.tis.utils.components.Scrollbar;		import flash.display.MovieClip;	import flash.display.Sprite;	import flash.events.Event;	import flash.events.MouseEvent;	import flash.geom.Point;	import flash.text.TextField;		import org.tizianoproject.events.BaseViewEvent;	import org.tizianoproject.model.IModel;	import org.tizianoproject.view.components.article.Scroller;	import org.tizianoproject.view.components.directory.Author;
	public class DirectoryView extends CompositeView	{		private static const DEFAULT_POS:Point = new Point( 65, 71 );		private static const DEFAULT_COLUMNS:Number = 3;		private static const DEFAULT_AUTHOR_POS:Point = new Point( 40, 97 );		private static const MARGIN_BOTTOM:Number = 10;		private static const MARGIN_RIGHT:Number = 10;		private static const TABLE_MAX:Number = 12;		private var iModel:IModel;		private var author:Author;		public var title_txt:TextField;		public var baseView_mc:BaseView;				private var directoryHolder:MovieClip;		private var scrollBar:Scroller;				private var _query:String;		private var _title:String;				public function DirectoryView( m:IModel, q:String="Reporter" )		{			x = DEFAULT_POS.x;			y = DEFAULT_POS.y;						iModel = m;			query = q;		}				override protected function init():void		{			initDirectoryHolder();			createTable();			baseView_mc.addEventListener( BaseViewEvent.CLOSE, onBaseCloseHandler, false, 0, true );		}				override protected function unload():void		{			//Delete Everything except baseView_mc;			ShowHideManager.unloadContent( (this as DirectoryView), 1 );		}				public function createTable(  ):void		{			var authors:Array = iModel.getAuthorsByType( query );						var columns:Number = DEFAULT_COLUMNS;			for( var i:Number = 0; i < authors.length; i++ ){				var xx:Number = i%columns;				var yy:Number = Math.floor( i/columns );								author = new Author( );				author.name = "author" + i;				author.loadImage( authors[i].avatar );				author.id = authors[i].id;				author.authorName = authors[i].name;				author.writeName( authors[i].fullName );				author.writeGrade( authors[i].age );				author.x = xx * (author.width  + MARGIN_RIGHT );				author.y = yy * (author.height + MARGIN_BOTTOM );				author.addEventListener( MouseEvent.CLICK, onAuthorClickHandler, false, 0, true );				ShowHideManager.addContent( directoryHolder, author );			}						//If there are more than 5 features, add a Scroll Bar			if( directoryHolder.numChildren > TABLE_MAX ) initFeatureScrollBar();		}				private function initDirectoryHolder():void		{			directoryHolder = new MovieClip();			directoryHolder.name = "directoryHolder";			directoryHolder.x = DEFAULT_AUTHOR_POS.x;			directoryHolder.y = DEFAULT_AUTHOR_POS.y;			ShowHideManager.addContent( (this as DirectoryView ), directoryHolder );		}				private function initFeatureScrollBar():void		{			trace( "DirectoryView::initFeatureScrollBar:" );			//Create the Features Holder			scrollBar = new Scroller( directoryHolder );			scrollBar.name = "scrollBar";			ShowHideManager.addContent( (this as DirectoryView), scrollBar );		}		/**********************************		 * Event Handlers		 **********************************/		private function onAuthorClickHandler( e:MouseEvent ):void		{			trace( "DirectoryView::onAuthorClickHandler:", Author(e.currentTarget).authorName );		}				private function onBaseCloseHandler( e:BaseViewEvent ):void		{			dispatchEvent( e );		}					/**********************************		 * Read Write Accessors		 **********************************/		public function set title( value:String ):void		{			_title = title_txt.text = value			}				public function get title():String		{			return _title;		}				public function set query( value:String ):void		{			_query = value;		}				public function get query():String		{			return _query;		}	}}