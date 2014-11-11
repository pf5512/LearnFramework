//
//  CommDefine.h
//  PhotoTest
//
//  Created by chen on 14-11-5.
//  Copyright (c) 2014年 zichen0422. All rights reserved.
//

#ifndef PhotoTest_CommDefine_h
#define PhotoTest_CommDefine_h

#ifdef DEBUG
#define DLog(...) NSLog(__VA_ARGS__)
#else
#define DLog(...) /**/
#endif

#endif
