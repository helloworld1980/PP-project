//
//  PhotoObject.h
//  TS_Project
//
//  Created by liman on 16/3/23.
//  Copyright © 2016年 LYC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMPhotoObject : NSObject // 照片对象

@property (strong, nonatomic) NSString *imageUrl; // 远程
@property (strong, nonatomic) UIImage *image; // 本地
@property (assign, nonatomic) BOOL takeCamera;

@end
