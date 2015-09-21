//
//  DPAPI.m
//  apidemo
//
//  Created by ZhouHui on 13-1-28.
//  Copyright (c) 2013年 Dianping. All rights reserved.
//

#import "DPAPI.h"
#import "DPConstants.h"


@interface DPAPI ()<DPRequestDelegate>
{
    NSMutableSet *_requests;
}
@property(nonatomic,strong) NSMutableDictionary *successDict;
@property(nonatomic,strong) NSMutableDictionary *failureDict;

@end


@implementation DPAPI

SXSingleton_M
- (NSMutableDictionary *)successDict
{
    if (_successDict == nil) {
        _successDict = [[NSMutableDictionary alloc]init];
    }
    return _successDict;
}

- (NSMutableDictionary *)failureDict
{
    if (_failureDict == nil) {
        _failureDict = [[NSMutableDictionary alloc]init];
    }
    return _failureDict;
}

#pragma mark - /************************* 后添加的 ***************************/

- (DPRequest *)request:(NSString *)url params:(NSDictionary *)parame success:(DPSuccess)success failure:(DPFailure)failure
{
    NSMutableDictionary *mutableParame = [NSMutableDictionary dictionaryWithDictionary:parame];
    DPRequest *request = [self requestWithURL:url params:mutableParame delegate:self];
    
    NSString *key = request.description;
    request.success = success;
    request.failure = failure;
    
    return request;
}



/**
 *  请求失败
 *
 *  @param request 请求
 *  @param error   错误信息
 */
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error
{
    if (request.failure) {
        request.failure(error);
    }
}

/**
 *  请求成功
 *
 *  @param request 请求
 *  @param result  请求结果
 */
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
{
    if (request.success) {
        request.success(result);
    }
}



#pragma mark - /************************* 本来就有的 ***************************/
- (id)init {
	self = [super init];
    if (self) {
        _requests = [[NSMutableSet alloc] init];
    }
    return self;
}

- (DPRequest*)requestWithURL:(NSString *)url
					  params:(NSMutableDictionary *)params
					delegate:(id<DPRequestDelegate>)delegate {
	if (params == nil) {
        params = [NSMutableDictionary dictionary];
    }
    
	NSString *fullURL = [kDPAPIDomain stringByAppendingString:url];
	
	DPRequest *_request = [DPRequest requestWithURL:fullURL
											 params:params
										   delegate:delegate];
	_request.dpapi = self;
	[_requests addObject:_request];
	[_request connect];
	return _request;
}

- (DPRequest *)requestWithURL:(NSString *)url
				 paramsString:(NSString *)paramsString
					 delegate:(id<DPRequestDelegate>)delegate {
	return [self requestWithURL:[NSString stringWithFormat:@"%@?%@", url, paramsString] params:nil delegate:delegate];
}

- (void)requestDidFinish:(DPRequest *)request
{
    [_requests removeObject:request];
    request.dpapi = nil;
}

- (void)dealloc
{
    for (DPRequest* _request in _requests)
    {
        _request.dpapi = nil;
    }
}

@end
