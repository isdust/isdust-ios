//
//  Http.m
//  isdust
//
//  Created by wzq on 7/23/16.
//  Copyright © 2016 isdust. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Http.h"
@implementation Http
-(id)init{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    session= [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    data_encoding=0;
    return self;
}
-(void)setencoding:(int)e{
    data_encoding=e;
}
-(NSString*)get:(NSString*)url{
    NSURL *murl = [NSURL URLWithString:url];
    dispatch_semaphore_t    sem;
    sem = dispatch_semaphore_create(0);
    __block NSData * result;
    NSURLSessionDataTask *task = [session dataTaskWithURL:murl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        result=data;
        dispatch_semaphore_signal(sem);
    }];
    [task resume];
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    NSStringEncoding enc2;
    switch (data_encoding) {
        case 0:
            enc2 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
            break;
        case 1:
            enc2 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            break;
        case 2:
            enc2 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingASCII);
            break;
        default:
            break;
    }
    NSString *str = [[NSString alloc]initWithData:result encoding:enc2];
    return str;
}
-(NSString*)post:(NSString*)url:(NSString*)data{
    NSStringEncoding enc2;
    switch (data_encoding) {
        case 0:
            enc2 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
            break;
        case 1:
            enc2 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            break;
        case 2:
            enc2 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingASCII);
            break;
        default:
            break;
    }
    __block NSData * result;
    NSURL *murl = [NSURL URLWithString:url];
    dispatch_semaphore_t    sem;
    sem = dispatch_semaphore_create(0);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:murl];
    NSLog(data);
    request.HTTPBody = [data dataUsingEncoding:enc2];
    
    request.HTTPMethod = @"POST";
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        // 默认是子线程.
        result=data;
        dispatch_semaphore_signal(sem);
        
    }];
    [task resume];
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    
    
    NSString *str = [[NSString alloc]initWithData:result encoding:enc2];
    return str;
}
-(NSString*)GetMiddleText:(NSString*)text:(NSString*)start:(NSString*)end{
    NSRange range_start=[text rangeOfString:start];
    // NSRange range_end=[text rangeOfString:end];
    NSRange range_end=[[text substringFromIndex:range_start.length+range_start.location] rangeOfString:end];
    NSRange range_result=NSMakeRange(range_start.location+range_start.length, range_end.location);
    //NSLog([text substringWithRange:range_result]);
    return [text substringWithRange:range_result];
    
    
}


-(NSString *)urlencode:(NSString*)encoding {
    NSStringEncoding enc2;
    switch (data_encoding) {
        case 0:
            enc2 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
            break;
        case 1:
            enc2 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            break;
        case 2:
            enc2 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingASCII);
            break;
        default:
            break;
    }


    return [encoding stringByAddingPercentEscapesUsingEncoding:enc2 ];
    // return encodedString;
    
}
-(NSString *)postencode:(NSString*)encoding {
    NSStringEncoding enc2;
    switch (data_encoding) {
        case 0:
            enc2 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
            break;
        case 1:
            enc2 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            break;
        case 2:
            enc2 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingASCII);
            break;
        default:
            break;
    }
    // NSCharacterSet *URLCombinedCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@" \"#%/:<>?@[\\]^`{|}"] invertedSet];
    NSCharacterSet *URLBase64CharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"/+\n \"#%/:<>?@[\\]^`{|}"] invertedSet];
    
    return [encoding stringByAddingPercentEncodingWithAllowedCharacters:URLBase64CharacterSet];
    // return encodedString;
    
}
-(UIImage*)get_picture:(NSString*)url{
    NSURL *murl = [NSURL URLWithString:url];
    dispatch_semaphore_t    sem;
    sem = dispatch_semaphore_create(0);
    __block NSData * result;
    NSURLSessionDataTask *task = [session dataTaskWithURL:murl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        result=data;
        dispatch_semaphore_signal(sem);
    }];
    [task resume];
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);

    UIImage *image = [[UIImage alloc]initWithData:result];
    return image;
}
@end