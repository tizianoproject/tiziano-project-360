package org.tizianoproject.model
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import org.tizianoproject.model.vo.Author;
	import org.tizianoproject.model.vo.Story;
	
	public interface IModel extends IEventDispatcher
	{
		function load( path:String ):void
			
		//StudentView + MentorView
		function getAuthorsByType( authorType:String, authorName:String=null, isRandom:Boolean=false ):Array
			
		//Author
		function getAuthorByName( authorName:String, callerName:String="" ):Author
		function getAuthorTypeByName( authorName:String, callerName:String="" ):String
			
		//Articles
		function getOtherArticlesByAuthorName( authorName:String, storyID:Number, callerName:String="" ):Array
		function getAllArticlesByAuthorName( authorName:String, callerName:String="" ):Array			
			
		function findArticle( uniqueID:Number ):Boolean;
		function getArticleByArticleID( uniqueID:Number, callerName:String="" ):Story
		//Gets all author articles with the uniqueID story having priority
		function getAllAuthorArticlesByID( uniqueID:Number, callerName:String="" ):Array
			
		function isLoaded():Boolean
	}
}