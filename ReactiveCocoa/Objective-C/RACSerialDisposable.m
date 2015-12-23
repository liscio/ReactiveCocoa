//
//  RACSerialDisposable.m
//  ReactiveCocoa
//
//  Created by Justin Spahr-Summers on 2013-07-22.
//  Copyright (c) 2013 GitHub, Inc. All rights reserved.
//

#import "RACSerialDisposable.h"
#import <pthread.h>

@interface RACSerialDisposable () {
	// The receiver's `disposable`. This variable must only be referenced while
	// _spinLock is held.
	RACDisposable * _disposable;

	// YES if the receiver has been disposed. This variable must only be modified
	// while _spinLock is held.
	BOOL _disposed;

	// A mutex to protect access to _disposable and _disposed.
	//
	// It must be used when _disposable is mutated or retained and when _disposed
	// is mutated.
	NSRecursiveLock *_lock;
}

@end

@implementation RACSerialDisposable

#pragma mark Properties

- (BOOL)isDisposed {
	return _disposed;
}

- (RACDisposable *)disposable {
	RACDisposable *result;

	[_lock lock];
	result = _disposable;
	[_lock unlock];

	return result;
}

- (void)setDisposable:(RACDisposable *)disposable {
	[self swapInDisposable:disposable];
}

#pragma mark Lifecycle

+ (instancetype)serialDisposableWithDisposable:(RACDisposable *)disposable {
	RACSerialDisposable *serialDisposable = [[self alloc] init];
	serialDisposable.disposable = disposable;
	return serialDisposable;
}

- (id)initWithBlock:(void (^)(void))block {
	self = [self init];
	if (self == nil) return nil;

	_lock = [[NSRecursiveLock alloc] init];
	self.disposable = [RACDisposable disposableWithBlock:block];

	return self;
}

#pragma mark Inner Disposable

- (RACDisposable *)swapInDisposable:(RACDisposable *)newDisposable {
	RACDisposable *existingDisposable;
	BOOL alreadyDisposed;

	[_lock lock];
	alreadyDisposed = _disposed;
	if (!alreadyDisposed) {
		existingDisposable = _disposable;
		_disposable = newDisposable;
	}
	[_lock unlock];

	if (alreadyDisposed) {
		[newDisposable dispose];
		return nil;
	}

	return existingDisposable;
}

#pragma mark Disposal

- (void)dispose {
	RACDisposable *existingDisposable;

	[_lock lock];
	if (!_disposed) {
		existingDisposable = _disposable;
		_disposed = YES;
		_disposable = nil;
	}
	[_lock unlock];
	
	[existingDisposable dispose];
}

@end
