//
//  DPAPI.h
//  apidemo
//
//  Created by ZhouHui on 13-1-28.
//  Copyright (c) 2013年 Dianping. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPRequest.h"

typedef void (^DPSuccess)(id json);
typedef void (^DPFailure)(NSError *error);

@interface DPAPI : NSObject

- (DPRequest*)requestWithURL:(NSString *)url
					  params:(NSMutableDictionary *)params
					delegate:(id<DPRequestDelegate>)delegate;

- (DPRequest *)requestWithURL:(NSString *)url
				 paramsString:(NSString *)paramsString
					 delegate:(id<DPRequestDelegate>)delegate;

//- (DPRequest *)request:(NSString *)url params:(NSDictionary *)parame success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
- (DPRequest *)request:(NSString *)url params:(NSDictionary *)parame success:(DPSuccess)success failure:(DPFailure)failure;

SXSingleton_H

@end
