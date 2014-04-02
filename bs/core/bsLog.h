//
//  bsLog.h
//  bsIOS
//
//  Created by Keiichi Sato on 2014/04/02.
//  Copyright (c) 2014 ProjectBS. All rights reserved.
//

#ifndef bsIOSDemo_bsLog_h
#define bsIOSDemo_bsLog_h

#define bsLogLevelTrace 1
#define bsLogLevelDebug 2
#define bsLogLevelError 3
#define bsLogLevelInfo  4
#define bsLogLevelNone  5
#define bsLogLevel bsLogLevelTrace

#ifdef DEBUG
#define bsLog(tag, level, ... ) {\
if (level >= bsLogLevel) {\
NSLog(__VA_ARGS__);\
}\
}
#else
#define bsLog(tag, level, ... )
#endif

#endif
