//
//  main.m
//  HTTP Server
//
//  Created by Keith Duncan on 17/02/2013.
//  Copyright (c) 2013 Keith Duncan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "CoreNetworking/CoreNetworking.h"

@interface HelloWorldRenderer : NSObject

@end

@implementation HelloWorldRenderer

+ (CFHTTPMessageRef)networkServer:(AFHTTPServer *)server renderResourceForRequest:(CFHTTPMessageRef)request
{
	CFHTTPMessageRef response = CFHTTPMessageCreateResponse(kCFAllocatorDefault, AFHTTPStatusCodeOK, NULL, kCFHTTPVersion1_1);
	
	CFHTTPMessageSetHeaderFieldValue(response, (__bridge CFStringRef)AFHTTPMessageContentTypeHeader, (__bridge CFStringRef)@"text/plain; charset=utf-8");
	CFHTTPMessageSetBody(response, (__bridge CFDataRef)[@"Hello, World!" dataUsingEncoding:NSUTF8StringEncoding]);
	
	return (__bridge CFHTTPMessageRef)CFBridgingRelease(response);
}

@end

static AFHTTPServer *StartHTTPServer(AFNetworkSchedule *schedule)
{
	AFHTTPServer *server = [AFHTTPServer server];
	server.schedule = schedule;
	
	server.renderers = @[
		[HelloWorldRenderer class],
	];
	
	BOOL openSockets = [server openInternetSocketsWithSocketSignature:AFNetworkSocketSignatureInternetTCP scope:AFNetworkInternetSocketScopeLocalOnly port:8080 errorHandler:nil];
	NSCParameterAssert(openSockets);
	
	return server;
}

static int server_main(void)
{
	AFNetworkSchedule *schedule = [[AFNetworkSchedule alloc] init];
	[schedule scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
	
	__unused AFNetworkServer *server = StartHTTPServer(schedule);
	
	[[NSRunLoop currentRunLoop] run];
	return -1;
}

int main(int argc, char const **argv)
{
	@autoreleasepool {
		return server_main();
	}
	return 0;
}
