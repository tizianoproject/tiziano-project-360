package org.adm.runtime
{
	import flash.system.Capabilities;
 
	public class ModeCheck
	{
		/**
		 * Returns true if the user is running the app on a Debug Flash Player.
		 * Uses the Capabilities class
		 **/
		public static function isDebugPlayer() : Boolean
		{
			return Capabilities.isDebugger;
		}
 
		/**
		 * Returns true if the swf is built in debug mode
		 **/
		public static function isDebugBuild() : Boolean
		{
			return new Error().getStackTrace().search(/:[0-9]+]$/m) > -1;
		}
 
		/**
		 * Returns true if the swf is built in release mode
		 **/
		public static function isReleaseBuild() : Boolean
		{
			return !isDebugBuild();
		}
	}
}