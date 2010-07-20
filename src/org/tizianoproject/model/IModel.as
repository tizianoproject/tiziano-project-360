package org.tizianoproject.model
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import org.tizianoproject.model.vo.Story;
	
	public interface IModel extends IEventDispatcher
	{
		function load( path:String ):void
		//Author
		function getAuthorsByType( authorType:String ):Array
		function getArticlesByAuthorID(  uniqueID:Number ):Array
			
		//Articles
		function getOtherArticlesByArticleID( uniqueID:Number ):Array
		function getArticleByArticleID( uniqueID:Number ):Story
	}
}