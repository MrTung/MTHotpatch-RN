//
//  BundleLoadManage.h
//  AwesomeProject
//
//  Created by 董徐维 on 2021/1/31.
//

#import <Foundation/Foundation.h>

@protocol BundleLoadManageDelegate <NSObject>

// 是否需要更新
- (BOOL)checkUpdate;

@end

NS_ASSUME_NONNULL_BEGIN

@interface BundleLoadManage : NSObject

+(BundleLoadManage *)defaultManager;

/**
 *  是否优先使用缓存数据
 *  @param useCache YES代表使用，No代表不使用，每次都下载压缩包
 */
@property (nonatomic,assign,getter=isUseCache)BOOL useCache;

@property (nonatomic,weak) id<BundleLoadManageDelegate> delegate;

-(void)downloadBundleWithUrl:(NSString *)urlStr version:(NSString *)version completeBlock:(void(^)(BOOL success,NSString* bundlePath)) completeBlock;

@end

NS_ASSUME_NONNULL_END
