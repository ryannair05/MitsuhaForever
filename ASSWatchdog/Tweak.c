#import <AudioToolbox/AudioQueue.h>
#import <arpa/inet.h>
#include <os/log.h>
#include <substrate.h>
#include "libhooker.h"

#define ASSPort 44333

bool hasConnected;
const int one = 1;
int connfd;

OSStatus (*_origAudioQueueStart)(AudioQueueRef inAQ, const AudioTimeStamp *inStartTime); 
OSStatus _functionAudioQueueStart(AudioQueueRef inAQ, const AudioTimeStamp *inStartTime) {

    os_log(OS_LOG_DEFAULT, "[ASSWatchdog] checking for ASS");
    if (!hasConnected) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            struct sockaddr_in remote;
            memset(&remote, 0, sizeof(struct sockaddr_in));
            remote.sin_family = PF_INET;
            remote.sin_port = htons(ASSPort);
            inet_aton("127.0.0.1", &remote.sin_addr);

            os_log(OS_LOG_DEFAULT, "[ASSWatchdog] Connecting to ASS");
            connfd = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);

            setsockopt(connfd, SOL_SOCKET, SO_NOSIGPIPE, &one, sizeof(one));

            if (connfd <= 0) {
                os_log(OS_LOG_DEFAULT, "[ASSWatchdog] ASS not running.");
            }
            else {
                os_log(OS_LOG_DEFAULT, "[ASSWatchdog] Connected.");
                hasConnected = true;
                close(connfd);
            }
        });
    } else {
        os_log(OS_LOG_DEFAULT, "[ASSWatchdog] already has connected...");
    }

    return _origAudioQueueStart(inAQ, inStartTime);
}

static __attribute__((constructor)) void Init() {

    hasConnected = false;

    if (access("/usr/lib/libhooker.dylib", F_OK) == 0) {
        const struct LHFunctionHook hook[1] = {{(void *)AudioQueueStart, (void **)&_functionAudioQueueStart, (void **)&_origAudioQueueStart}};
        LHHookFunctions(hook, 1);
    }
    else {
        MSHookFunction((void *)AudioQueueStart, (void *)&_functionAudioQueueStart, (void **)&_origAudioQueueStart);
    }
}