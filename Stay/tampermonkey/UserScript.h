//
//  UserScript.h
//  Stay
//
//  Created by ris on 2021/11/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
//https://www.tampermonkey.net/documentation.php
@interface UserScript : NSObject

@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *namespace;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *version;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *homepage;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSArray<NSString *> *includes;
@property (nonatomic, copy) NSArray<NSString *> *mathes;
@property (nonatomic, copy) NSArray<NSString *> *excludes;
@property (nonatomic, copy) NSString *runAt;
@property (nonatomic, copy) NSArray<NSString *> *grants;
@property (nonatomic, assign) BOOL noFrames;
@property (nonatomic, assign) BOOL pass;
@property (nonatomic, copy) NSString *errorMessage;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *parsedContent;
@property (nonatomic, copy) NSString *sourcePage;
@property (nonatomic, copy) NSString *updateUrl;
@property (nonatomic, copy) NSString *downloadUrl;

@property (nonatomic, copy) NSDate *updateTime;
@property (nonatomic, assign) BOOL active;
@property (nonatomic, assign) BOOL updateSwitch;


@property (nonatomic, copy) NSArray<NSString *> *requireUrls;

+ (instancetype)ofDictionary:(NSDictionary *)dict;
- (NSDictionary *)toDictionary;
@end

NS_ASSUME_NONNULL_END
