//
//  iPhoneStreamingPlayerAppDelegate.h
//  iPhoneStreamingPlayer
//
//  Created by Matt Gallagher on 28/10/08.
//  Copyright Matt Gallagher 2008. All rights reserved.
//
//  This software is provided 'as-is', without any express or implied
//  warranty. In no event will the authors be held liable for any damages
//  arising from the use of this software. Permission is granted to anyone to
//  use this software for any purpose, including commercial applications, and to
//  alter it and redistribute it freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//     claim that you wrote the original software. If you use this software
//     in a product, an acknowledgment in the product documentation would be
//     appreciated but is not required.
//  2. Altered source versions must be plainly marked as such, and must not be
//     misrepresented as being the original software.
//  3. This notice may not be removed or altered from any source
//     distribution.
//


/*
 ***            AudioToolBox.framework         *********
 * AudioConverter.h 音频转换器的API 。定义了用于创建和使用音频转换器的接口
 *
 * AudioFile.h ：定义用于读取和写入文件中的音频数据的接口
 *
 * AudioFileStream.h ：定义解析音频文件流的接口。读取采样率、码率、时长等基本信息以及分离音频帧 (网络流跟本地文件都可以使用)
 *
 * AudioFormat.h ：定义用于在音频文件的分配和读取的音频格式，元数据的接口
 *
 * AudioSession.h 用来管理应用中audio的行为
 *
 * AudioQueue.h ：定义播放和录制音频的接口
 *
 * AudioServices.H :定义三个接口。系统声音服务可以让你玩短的声音和提醒。音频硬件服务提供了一个轻量级的接口与音频硬件进行交互。音频会话服务可以让iPhone和iPod touch的应用程序管理音频会议。
 *
 * AudioToolbox.h ：顶层包含文件的音频工具箱框架
 *
 * AUGraph.h ：定义用于创建和使用音频处理图形界面
 *
 * ExtendedAudioFile.h ：定义用于从文件中的音频数据直接转换为线性PCM接口，反之亦然
 *
 * AUGraph.h 
 *
 * CAFFile.h
 *
 * MusicPlayer.h
 */

#import <UIKit/UIKit.h>

@class iPhoneStreamingPlayerViewController;

@interface iPhoneStreamingPlayerAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    iPhoneStreamingPlayerViewController *viewController;
    
    UIBackgroundTaskIdentifier bgTask;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet iPhoneStreamingPlayerViewController *viewController;

@end

