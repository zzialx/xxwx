//
//  PathMacros.h
//  OASystem
//
//  Created by candy.chen on 2019/3/4.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#ifndef PathMacros_h
#define PathMacros_h

#define kPath               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define kPathDocument               [kPath stringByAppendingPathComponent:@"document"]

#define kPathDownloaded         [kPathDocument stringByAppendingPathComponent:@"DownloadedMgz.plist"]


#endif /* PathMacros_h */
