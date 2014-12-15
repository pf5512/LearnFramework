//
//  configure.h
//  iPhoneStreamingPlayer
//
//  Created by chen on 14-12-15.
//
//

/*
 ******************
 使用AudioFileStream首先需要调用AudioFileStreamOpen，需要注意的是尽量提供inFileTypeHint参数帮助AudioFileStream解析数据，调用完成后记录AudioFileStreamID；
 当有数据时调用AudioFileStreamParseBytes进行解析，每一次解析都需要注意返回值，返回值一旦出现noErr以外的值就代表Parse出错，其中kAudioFileStreamError_NotOptimized代表该文件缺少头信息或者其头信息在文件尾部不适合流播放；
 使用AudioFileStreamParseBytes需要注意第四个参数在需要合适的时候传入kAudioFileStreamParseFlag_Discontinuity；
 调用AudioFileStreamParseBytes后会首先同步进入AudioFileStream_PropertyListenerProc回调来解析文件格式信息，如果回调得到kAudioFileStreamProperty_ReadyToProducePackets表示解析格式信息完成；
 解析格式信息完成后继续调用AudioFileStreamParseBytes会进入MyAudioFileStreamPacketsCallBack回调来分离音频帧，在回调中应该将分离出来的帧信息保存到自己的buffer中
 seek时需要先近似的计算seekTime对应的seekByteOffset，然后利用AudioFileStreamSeek计算精确的offset，如果能得到精确的offset就修正一下seektime，如果无法得到精确的offset就用之前的近似结果
 AudioFileStream使用完毕后需要调用AudioFileStreamClose进行关闭；
 *****************
 */


/*
 * 对于网络流播必须有AudioFileStream的支持 
 * 对于本地音乐播放选用AudioFile更为合适
 */
