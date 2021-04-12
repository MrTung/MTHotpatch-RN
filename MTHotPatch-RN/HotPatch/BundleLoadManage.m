//
//  BundleLoadManage.m
//  AwesomeProject
//
//  Created by 董徐维 on 2021/1/31.
//

#import "BundleLoadManage.h"
#import "SSZipArchive.h"
#import "AFNetworking.h"

@implementation BundleLoadManage

+(BundleLoadManage *)defaultManager
{
  static BundleLoadManage *instance;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    instance = [[BundleLoadManage alloc] init];
  });
  return instance;
}

-(void)downloadBundleWithUrl:(NSString*)urlStr version:(NSString*)version completeBlock:(void(^)(BOOL success,NSString* bundlePath)) completeBlock{
  
  bool update = NO;
  if ([_delegate respondsToSelector:@selector(checkUpdate)]) {
    update = [_delegate checkUpdate];
  }
  if (!update) {
    return completeBlock(NO,nil);
  }
  
  NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
  NSString *destinationPath = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"rn/%@",version]];
  
  if (self.isUseCache) {
    if ([[NSFileManager defaultManager] fileExistsAtPath:destinationPath]) {
      NSLog(@"已存在,直接返回");
      if (completeBlock) {
        return completeBlock(YES,destinationPath);
      }
    }
  }
  
  AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
  NSURL *url = [NSURL URLWithString:urlStr];
  NSURLRequest *req = [NSURLRequest requestWithURL:url];
  NSDate *datenow = [NSDate date];
  NSTimeInterval interval = [datenow timeIntervalSince1970] *1000;
  NSString * p = [NSString stringWithFormat:@"/Documents/%f",interval];
  NSString *path=[NSHomeDirectory() stringByAppendingString:p];
  {
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
  }
  NSString *filePath = [path stringByAppendingPathComponent:url.lastPathComponent];
  NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:req progress:^(NSProgress * _Nonnull downloadProgress) {
    NSLog(@"%.2f",downloadProgress.fractionCompleted * 100);
  } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
    return [NSURL fileURLWithPath:filePath];
  } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
    NSLog(@"下载完成");
    NSString *path = [self unzipFileWithPath:filePath.path version:version];
    if (completeBlock) {
      completeBlock(YES,path);
    }
  }];
  [task resume];
}

- (NSString*)unzipFileWithPath:(NSString *)filePath version:(NSString*)version {
  __block NSString *unzipPath;
  NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
  __block NSString *destinationPath = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"rn/%@",version]];
  if ([[NSFileManager defaultManager] fileExistsAtPath:destinationPath]) {
    [[NSFileManager defaultManager] removeItemAtPath:destinationPath error:nil];
  }
  [SSZipArchive unzipFileAtPath:filePath toDestination:destinationPath progressHandler:^(NSString * _Nonnull entry, unz_file_info zipInfo, long entryNumber, long total) {
  } completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nullable error) {
    NSLog(@"解压完成");
    unzipPath = destinationPath;
  }];
  return  unzipPath;
}



@end
