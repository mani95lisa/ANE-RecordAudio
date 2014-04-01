ANE-RecordAudio
===============

ANE Record and Convert Audio in many formates
```
//Demo
setTimeout(function():void{
	trace('Begin');
	RecordAudio.instance.startRecord('test1');
},
3000);

setTimeout(function():void{
	RecordAudio.instance.stopRecord(function(url:String):void{
		var f:File = new File(url);
		trace(f.exists, url);
	});
	trace('Stoped');
}, 6000);
setTimeout(function():void{
	//You can convert to MP3
	RecordAudio.instance.toMp3(function(url):void{
		var f:File = new File(url);
		trace(f.exists, url);
	});
	//AMR is the smallest record format
	RecordAudio.instance.toAMR(function(url):void{
		var f:File = new File(url);
		trace(f.exists, url);
	});
}, 8000);
```
