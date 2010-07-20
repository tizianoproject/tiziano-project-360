package org.tizianoproject.model
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import org.tizianoproject.model.vo.Story;
	
	public interface IModel extends IEventDispatcher
	{
		function load( path:String ):void
			
		function getOtherArticlesByArticleID( uniqueID:Number ):Array
		function getArticleByArticleID( uniqueID:Number ):Story
	}
}