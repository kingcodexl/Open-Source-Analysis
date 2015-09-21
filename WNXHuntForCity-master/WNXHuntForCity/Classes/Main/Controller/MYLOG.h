//
//  MYLOG.h
//  WNXHuntForCity
//
//  Created by kingcode on 15/8/12.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//

#ifndef WNXHuntForCity_MYLOG_h
#define WNXHuntForCity_MYLOG_h

#ifdef DEBUG
#  define LOG(fmt, ...) do {                                            \
NSString* file = [[NSString alloc] initWithFormat:@"%s", __FILE__]; \
NSLog((@"%@(%d) " fmt), [file lastPathComponent], __LINE__, ##__VA_ARGS__); \
[file release];                                                 \
} while(0)
#  define LOG_METHOD NSLog(@"%s", __func__)
#  define LOG_CMETHOD NSLog(@"%@/%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd))
#  define COUNT(p) NSLog(@"%s(%d): count = %d\n", __func__, __LINE__, [p retainCount]);
#  define LOG_TRACE(x) do {printf x; putchar('\n'); fflush(stdout);} while (0)
#else
#  define LOG(...)
#  define LOG_METHOD
#  define LOG_CMETHOD
#  define COUNT(p)
#  define LOG_TRACE(x)
#endif

#endif
