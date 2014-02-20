package
{
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	import flash.filesystem.File;

	public class RecordAudio extends EventDispatcher
	{
		private static var _instance:RecordAudio;
		private static var extensionContext:ExtensionContext;
		private static const EXTENSION_ID:String="com.pamakids.RecordAudio";
		
		public static function get instance():RecordAudio
		{
			if (!_instance)
			{
				_instance=new RecordAudio();
				extensionContext=ExtensionContext.createExtensionContext(EXTENSION_ID, null);
				if (!extensionContext)
					trace("ERROR - Extension context is null. Please check if extension.xml is setup correctly.");
				else
					extensionContext.addEventListener(StatusEvent.STATUS, onStatus);
			}
			return _instance;
		}

		/**
		 * Start Record
		 * 
		 * @savedName file name to save
		 * @formate file formate to use, now only m4a
		 */
		public function startRecord(savedName:String,format:String='.m4a'):void
		{
			saveName = savedName+format;
			if (extensionContext)
				extensionContext.call('startRecord', savedName+format);
		}
		
		private static var stopedCallback:Function;
		
		/**
		 * Stop Record
		 * 
		 * @callback return recorded file's url
		 */
		public function stopRecord(callback:Function):void
		{
			if (extensionContext)
			{
				stopedCallback = callback;
				extensionContext.call('stopRecord');	
			}
		}

		/**
		 * Convert recorded audio to mp3
		 * 
		 * @callback return converted file's url
		 */
		public function toMp3(callback:Function):void
		{
			if (extensionContext)
			{
				stopedCallback = callback;
				extensionContext.call('toMp3');	
			}
		}
		
		private static var saveName:String;
		
		protected static function onStatus(event:StatusEvent):void
		{
			var url:String = event.level;
			if(event.code == 'stoped' && stopedCallback)
			{
				if(url.indexOf('|') != -1)
				{
					trace('url has problem, auto fix');
					var f:File = File.applicationDirectory;
					url = f.nativePath.replace(f.name, '')+'tmp/'+saveName;
				}
				trace('saved url: '+url);
				stopedCallback(url);
				stopedCallback = null;
			}else if(event.code == 'mp3_converted' && stopedCallback)
			{
				var f:File = File.applicationDirectory;
				url = f.nativePath.replace(f.name, '')+'tmp/temp.mp3';
				stopedCallback(url);
				stopedCallback=null;
			}
				
		}
	}

}