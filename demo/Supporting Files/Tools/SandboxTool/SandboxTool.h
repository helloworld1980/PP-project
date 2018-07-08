//
//  SandboxTool.h
//  sandbox_demo
//
//  Created by liman on 12/1/15.
//  Copyright © 2015 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SandboxTool : NSObject

+ (SandboxTool *)sharedInstance;

/**
 *  保存图片到沙盒
 */
- (BOOL)saveToSandboxWithImage:(UIImage *)image imageName:(NSString *)imageName imageType:(NSString *)imageType ratio:(CGFloat)ratio;

/**
 *  从沙盒中读取图片
 */
- (UIImage *)getFromSandboxWithImageName:(NSString *)imageName imageType:(NSString *)imageType;

/**
 *  从沙盒中删除图片
 */
- (BOOL)deleteFromSandboxWithImageName:(NSString *)imageName imageType:(NSString *)imageType;

//============================================== 组合 ============================================

/**
 *  保存图片到沙盒 (文件名随机, png格式, 0.5压缩比)
 */
- (BOOL)saveToSandboxWithImage:(UIImage *)image;

/**
 *  从沙盒中读取图片 (png格式)
 */
- (UIImage *)getFromSandboxWithImageName:(NSString *)imageName;

/**
 *  从沙盒中删除图片 (png格式)
 */
- (BOOL)deleteFromSandboxWithImageName:(NSString *)imageName;

@end
