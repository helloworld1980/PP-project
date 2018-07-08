//
//  SandboxTool.m
//  sandbox_demo
//
//  Created by liman on 12/1/15.
//  Copyright © 2015 apple. All rights reserved.
//

#import "SandboxTool.h"

@implementation SandboxTool

+ (SandboxTool *)sharedInstance
{
    static SandboxTool *__singletion = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        __singletion = [[self alloc] init];
    });
    
    return __singletion;
}

/**
 *  保存图片到沙盒
 */
- (BOOL)saveToSandboxWithImage:(UIImage *)image imageName:(NSString *)imageName imageType:(NSString *)imageType ratio:(CGFloat)ratio
{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *imagePath = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, imageType]];
    
    NSData *imageData = UIImageJPEGRepresentation(image, ratio);
    
    return [imageData writeToFile:imagePath atomically:YES];
}

/**
 *  从沙盒中读取图片
 */
- (UIImage *)getFromSandboxWithImageName:(NSString *)imageName imageType:(NSString *)imageType
{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *imagePath = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, imageType]];
    
    return [UIImage imageWithContentsOfFile:imagePath];
    
//     NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
//     return [UIImage imageWithData:imageData];
}

/**
 *  从沙盒中删除图片
 */
- (BOOL)deleteFromSandboxWithImageName:(NSString *)imageName imageType:(NSString *)imageType
{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *imagePath = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, imageType]];
    
    return [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
}

//============================================== 组合 ============================================

/**
 *  保存图片到沙盒 (文件名随机, png格式, 0.5压缩比)
 */
- (BOOL)saveToSandboxWithImage:(UIImage *)image
{
    NSString *imageName = [NSString stringWithFormat:@"%d", arc4random()];
    
    return [self saveToSandboxWithImage:image imageName:imageName imageType:@"png" ratio:0.5];
}

/**
 *  从沙盒中读取图片 (png格式)
 */
- (UIImage *)getFromSandboxWithImageName:(NSString *)imageName
{
    return [self getFromSandboxWithImageName:imageName imageType:@"png"];
}

/**
 *  从沙盒中删除图片 (png格式)
 */
- (BOOL)deleteFromSandboxWithImageName:(NSString *)imageName
{
    return [self deleteFromSandboxWithImageName:imageName imageType:@"png"];
}

@end
