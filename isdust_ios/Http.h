//
//  Http.h
//  isdust
//
//  Created by wzq on 7/23/16.
//  Copyright © 2016 isdust. All rights reserved.
//

#ifndef Http_h
#define Http_h


#endif /* Http_h */
#include <UIKit/UIKit.h>

@interface Http:NSObject{
@private
    NSURLSession *session;
    int data_encoding;
    /*
     0为unicode
     1为gb2312
     2为ascii
     */
}
-(void)setencoding:(int)e;
-(NSString*)get:(NSString*)url;
-(UIImage*)get_picture:(NSString*)url;
-(NSString*)post:(NSString*)url:(NSString*)data;
-(NSString*)GetMiddleText:(NSString*)text:(NSString*)start:(NSString*)end;
-(NSString *)urlencode:(NSString*)encoding;
-(NSString *)postencode:(NSString*)encoding;
@end
