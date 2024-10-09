//
//  MCOIMAPBaseOperation.m
//  mailcore2
//
//  Created by DINH Viêt Hoà on 3/26/13.
//  Copyright (c) 2013 MailCore. All rights reserved.
//

#import "MCOIMAPBaseOperation.h"
#import "MCOIMAPBaseOperation+Private.h"

#import "MCOOperation+Private.h"

#import "MCAsyncIMAP.h"
#import "MCOIMAPSession.h"
#import "NSObject+MCO.h"

class MCOIMAPBaseOperationIMAPCallback : public mailcore::IMAPOperationCallback {
public:
    MCOIMAPBaseOperationIMAPCallback(MCOIMAPBaseOperation * op)
    {
        mOperation = op;
    }
    
    virtual ~MCOIMAPBaseOperationIMAPCallback()
    {
    }
    
    virtual void bodyProgress(mailcore::IMAPOperation * session, unsigned int current, unsigned int maximum) {
        [mOperation bodyProgress:current maximum:maximum];
    }
    
    virtual void itemProgress(mailcore::IMAPOperation * session, unsigned int current, unsigned int maximum) {
        [mOperation itemProgress:current maximum:maximum];
    }
    
private:
    MCOIMAPBaseOperation * mOperation;
};

@implementation MCOIMAPBaseOperation {
    MCOIMAPBaseOperationIMAPCallback * _imapCallback;
    MCOIMAPSession * _session;
    
    dispatch_source_t _timeoutTimer;
}

#define nativeType mailcore::IMAPOperation

MCO_OBJC_SYNTHESIZE_SCALAR(BOOL, bool, setUrgent, isUrgent)

- (instancetype) initWithMCOperation:(mailcore::Operation *)op
{
    self = [super initWithMCOperation:op];
    
    _imapCallback = new MCOIMAPBaseOperationIMAPCallback(self);
    ((mailcore::IMAPOperation *) op)->setImapCallback(_imapCallback);
    
    _operationTimeout = 20; // 默认20秒

    return self;
}

- (void)cancel {
    // 取消超时计时器
    [self _cancelTimeoutTimer];
    
    [super cancel];
}

- (void) start
{
    if (self.operationTimeout > 0) {
        [self _startTimeoutTimer];
    }
    
    [super start];
}

- (void) dealloc
{
    [_session release];
    delete _imapCallback;
    [super dealloc];
}

- (void) setSession:(MCOIMAPSession *)session
{
    [_session release];
    _session = [session retain];
}

- (MCOIMAPSession *) session
{
    return _session;
}

- (void) bodyProgress:(unsigned int)current maximum:(unsigned int)maximum
{
}

- (void) itemProgress:(unsigned int)current maximum:(unsigned int)maximum
{
}

- (void) _startTimeoutTimer
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timeoutTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t startTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.operationTimeout * NSEC_PER_SEC));
    dispatch_source_set_timer(_timeoutTimer, startTime, DISPATCH_TIME_FOREVER, 0);
    
    // 使用 __unsafe_unretained 避免循环引用
//    __unsafe_unretained MCOOperation *weakSelf = self;
    dispatch_source_set_event_handler(_timeoutTimer, ^{
        [self _operationDidTimeout];
    });
    dispatch_resume(_timeoutTimer);
}

- (void) _operationDidTimeout
{
    NSError *timeoutError = [NSError errorWithDomain:MCOErrorDomain
                                                code:MCOErrorConnection
                                            userInfo:@{NSLocalizedDescriptionKey: @"操作已超时"}];

    dispatch_async(self.callbackDispatchQueue ?: dispatch_get_main_queue(), ^{
        [self operationFailedWithError:timeoutError];
    });
}

- (void) _cancelTimeoutTimer
{
    if (_timeoutTimer) {
        dispatch_source_cancel(_timeoutTimer);
        _timeoutTimer = NULL;
    }
}

- (void) operationFailedWithError:(NSError *)error
{
    nativeType *op = MCO_NATIVE_INSTANCE;
    op->setError(mailcore::ErrorConnection);
    
    [self operationCompleted];
    
    [self cancel];
}


@end
