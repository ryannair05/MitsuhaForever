#import <AudioUnit/AudioUnit.h>
#import <arpa/inet.h>
#include <os/log.h>
#include <substrate.h>

#define ASSPort 44333

bool hasConnected = false;
const int one = 1;
int connfd;

OSStatus (*_origAudioUnitInitialize)(AudioUnit inUnit); 
OSStatus _functionAudioUnitInitialize(AudioUnit inUnit) {

    os_log(OS_LOG_DEFAULT, "[ASSWatchdog] checking for ASS");
    if (!hasConnected) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            struct sockaddr_in remote;
            remote.sin_family = PF_INET;
            remote.sin_port = htons(ASSPort);
            inet_aton("127.0.0.1", &remote.sin_addr);
            int retries = 0;

            while (connfd != -2) {
                os_log(OS_LOG_DEFAULT, "[ASSWatchdog] Connecting to ASS");
                retries++;
                connfd = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);

                if (connfd == -1) {
                    usleep(1000 * 1000);
                    continue;
                }
                setsockopt(connfd, SOL_SOCKET, SO_NOSIGPIPE, &one, sizeof(one));

                int const r = connect(connfd, (struct sockaddr *)&remote, sizeof(remote));

                if (r != 0) {
                    connfd = -2;
                    os_log(OS_LOG_DEFAULT, "[ASSWatchdog] ASS not running.");
                    os_log(OS_LOG_DEFAULT, "[ASSWatchdog] abort, there's no ASS here...");
                    break;
                }

                if (connfd > 0) {
                    os_log(OS_LOG_DEFAULT, "[ASSWatchdog] Connected.");
                    hasConnected = true;
                    close(connfd);
                }
                
                break;
            }
        });
    } else {
        os_log(OS_LOG_DEFAULT, "[ASSWatchdog] abort, there's no ASS here...");
    }

    return _origAudioUnitInitialize(inUnit);
}

static __attribute__((constructor)) void Init() {
    {
        MSHookFunction((void *)AudioUnitInitialize, (void *)&_functionAudioUnitInitialize, (void **)&_origAudioUnitInitialize);
    }
}