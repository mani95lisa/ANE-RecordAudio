package
{
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;

	public class RecordAudio extends EventDispatcher
	{
		private static var _instance:RecordAudio;
		private static const EXTENSION_ID:String="com.pamakids.RecordAudio";

		public static function get instance():RecordAudio
		{
			if (!_instance)
			{
				_instance=new RecordAudio();
			}
			return _instance;
		}

		/**
		* 开始录音，传入文件名称
		*/
		public function startRecord(saveName:String):void
		{
		}

		/**
		 * 停止录音，返回保存音频文件的路径
		 */
		public function stopRecord(callback:Function):void
		{
		}

		public function toMp3():void
		{
		}

	}

}