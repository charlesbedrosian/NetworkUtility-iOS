//
//  NetworkUtility.m
//  AisleBuyer-iPad
//
//  Created by John Forester on 12/27/11.
//  Copyright (c) 2011 VOKAL. All rights reserved.
//

#import "NetworkUtility.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>

@implementation NetworkUtility

@synthesize delegate;

#pragma mark - 

static NetworkUtility *_instance = nil;

+ (NetworkUtility *)getInstance
{    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
            _instance = [[self alloc] init];
    });
        
    return _instance;
}

- (ResponseData *)get:(NSString *)url withParameters:(NSDictionary *)params authenticate:(BOOL)authenticate error:(NSError *)error
{
    return [self.delegate get:url withParameters:params authenticate:authenticate error:error];
}

- (ResponseData *)postForHttp:(NSString *)url withParameters:(NSDictionary *)params authenticate:(BOOL)authenticate error:(NSError *)error
{
    return [self.delegate postForHttp:url withParameters:params authenticate:authenticate error:error];
}

- (ResponseData *)post:(NSString *)url withParameters:(NSDictionary *)params authenticate:(BOOL)authenticate error:(NSError *)error
{
    return [self.delegate post:url withParameters:params authenticate:authenticate error:error];
}

- (ResponseData *)put:(NSString *)url withParameters:(NSDictionary *)params authenticate:(BOOL)authenticate error:(NSError *)error
{
    return [self.delegate put:url withParameters:params authenticate:authenticate error:error];
}

- (ResponseData *)delete:(NSString *)url withParameters:(NSDictionary *)params authenticate:(BOOL)authenticate error:(NSError *)error
{
    return [self.delegate delete:url withParameters:params authenticate:authenticate error:error];
}

- (ResponseData *)post:(NSString *)url withParameters:(NSDictionary *)params filePath:(NSString *)filePath authenticate:(BOOL)authenticate error:(NSError *)error
{
    return [self.delegate post:url withParameters:params filePath:filePath authenticate:authenticate error:error];
}

- (ResponseData *)post:(NSString *)url withParameters:(NSDictionary *)params image:(UIImage *)image withName:(NSString*)name authenticate:(BOOL)authenticate error:(NSError *)error
{
    return [self.delegate post:url withParameters:params image:image withName:name authenticate:authenticate error:error];
}

- (ResponseData *)postMultiPartFormData:(NSString *)url withParameters:(NSDictionary *)params authenticate:(BOOL)authenticate error:(NSError *)error
{
    return [self.delegate postMultiPartFormData:url withParameters:params  authenticate:authenticate error:error];
}

- (BOOL)hasConnectivity
{
    if ([(id)self.delegate respondsToSelector:@selector(hasConncetivity)]) {
        return [self.delegate hasConnectivity];
    }else{
        struct sockaddr_in zeroAddress;
        bzero(&zeroAddress, sizeof(zeroAddress));
        zeroAddress.sin_len = sizeof(zeroAddress);
        zeroAddress.sin_family = AF_INET;
        
        SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&zeroAddress);
        if(reachability != NULL) {
            //NetworkStatus retVal = NotReachable;
            SCNetworkReachabilityFlags flags;
            if (SCNetworkReachabilityGetFlags(reachability, &flags)) {
                if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
                {
                    // if target host is not reachable
                    return NO;
                }
                
                if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
                {
                    // if target host is reachable and no connection is required
                    //  then we'll assume (for now) that your on Wi-Fi
                    return YES;
                }
                
                
                if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
                     (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
                {
                    // ... and the connection is on-demand (or on-traffic) if the
                    //     calling application is using the CFSocketStream or higher APIs
                    
                    if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
                    {
                        // ... and no [user] intervention is needed
                        return YES;
                    }
                }
                
                if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
                {
                    // ... but WWAN connections are OK if the calling application
                    //     is using the CFNetwork (CFSocketStream?) APIs.
                    return YES;
                }
            }
        }
        
        return NO;
    }
}

@end

@implementation ResponseData

@synthesize data;
@synthesize response;

@end