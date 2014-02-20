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
		 * Start Record
		 * 
		 * @savedName file name to save
		 * @formate file formate to use, now only m4a
		 */
		public function startRecord(saveName:String,format:String='m4a'):void
		{
		}

		/**
		 * Stop Record
		 * 
		 * @callback return recorded file's url
		 */
		public function stopRecord(callback:Function):void
		{
		}

		/**
		 * Convert recorded audio to mp3
		 * 
		 * @callback return converted file's url
		 */
		public function toMp3(callback:Function):void
		{
		}

	}

}