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
		 * 开始录音，传入文件名称
		 */
		public function startRecord(savedName:String):void
		{
			saveName = savedName;
			if (extensionContext)
				extensionContext.call('startRecord', savedName);
		}
		
		private static var stopedCallback:Function;
		
		/**
		 * 停止录音，返回保存音频文件的路径
		 */
		public function stopRecord(callback:Function):void
		{
			if (extensionContext)
			{
				stopedCallback = callback;
				extensionContext.call('stopRecord');	
			}
		}

		public function toMp3():void
		{
			if (extensionContext)
				extensionContext.call('toMp3');	
		}
		
		private static var saveName:String;
		
		protected static function onStatus(event:StatusEvent):void
		{		
			if(event.code == 'stoped' && stopedCallback)
			{
				var url:String = event.level;
				if(url.indexOf('|') != -1)
				{
					trace('url has problem, auto fix');
					var f:File = File.applicationDirectory;
					url = f.nativePath.replace(f.name, '')+'tmp/'+saveName;
				}
				trace('saved url: '+url);
				stopedCallback(url);
			}
				
		}
	}

}