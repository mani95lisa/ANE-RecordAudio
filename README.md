ANE-RecordAudio
===============

ANE Record and Convert Audio in many formates

var ff:File = File.applicationDirectory;
			trace(ff.nativePath.replace(ff.name, ''));

			setTimeout(function():void{
				trace('1');
				RecordAudio.instance.startRecord('test1');
			},
			3000);
			setTimeout(function():void{
				RecordAudio.instance.stopRecord(function(url:String):void{
				
					var f:File = new File(url);
					
					trace(f.exists, url);
					
					
				});
				
				trace('2');
			}, 6000);
			setTimeout(function():void{
				RecordAudio.instance.toMp3(function(url):void{
					var f:File = new File(url);
					
					trace(f.exists, url);
					
					
				});
			}, 8000);
		}
