//
//  HRHTTPConnection.h
//  HostRead
//
//  Created by huangrensheng on 16/9/7.
//  Copyright © 2016年 kawaii. All rights reserved.
//

#import "HTTPConnection.h"
#import "MultipartFormDataParser.h"

@interface HRHTTPConnection : HTTPConnection<MultipartFormDataParserDelegate>{
    BOOL isUploading;                         //Is not being performed Upload
    MultipartFormDataParser *parser;    //
    NSFileHandle *storeFile;                  //Storing uploaded files
    UInt64 uploadFileSize;
}
@end
