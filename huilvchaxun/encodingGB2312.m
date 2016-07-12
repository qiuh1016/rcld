//
//  function.m
//  EncDemo
//
//  Created by qiuhong on 3/22/16.
//  Copyright © 2016 CETCME. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "encodingGB2312.h"
#import "CommonCrypto/CommonDigest.h"

NSString* converTo (NSString *ScanResultString) {
    
    NSString *result= ScanResultString;//返回的扫描结果
    NSData *data=[ScanResultString dataUsingEncoding:NSUTF8StringEncoding];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *retStr = [[NSString alloc] initWithData:data encoding:enc];//如果中文是utf-8编码转gbk结果为空(还没搞明白)
    if (retStr)//如果扫描中文乱码则需要处理，否则不处理
    {
        NSInteger max = [ScanResultString length];
        char *nbytes = malloc(max + 1);
        for (int i = 0; i < max; i++)
        {
            unichar ch = [ScanResultString  characterAtIndex: i];
            nbytes[i] = (char) ch;
        }
        nbytes[max] = '\0';
        result=[NSString stringWithCString: nbytes  encoding: enc];
    }
    return result;
    
}

NSString * md5  (NSString * inPutText)
{
    const char *cStr = [inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}
