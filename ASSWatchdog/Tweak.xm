#import <arpa/inet.h>
#import <spawn.h>
#define ASSPort 43333
const int one = 1;
int connfd;

%hook SpringBoard

-(id)init {
    id orig = %orig;
    NSLog(@"[ASSWatchdog] checking for ASS");
    bool assPresent = [[NSFileManager defaultManager] fileExistsAtPath: @"/Library/MobileSubstrate/DynamicLibraries/AudioSnapshotServer.dylib"];
    if (assPresent) {
        NSLog(@"[ASSWatchdog] ASS found... checking if msd is hooked");
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            struct sockaddr_in remote;
            remote.sin_family = PF_INET;
            remote.sin_port = htons(ASSPort);
            inet_aton("127.0.0.1", &remote.sin_addr);
            int r = -1;
            int retries = 0;

            while (connfd != -2) {
                NSLog(@"[ASSWatchdog] Connecting to ASS.");
                retries++;
                connfd = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);

                if (connfd == -1) {
                    usleep(1000 * 1000);
                    continue;
                }
                setsockopt(connfd, SOL_SOCKET, SO_NOSIGPIPE, &one, sizeof(one));

                while(r != 0) {
                    if (retries > 3) {
                        connfd = -2;
                        NSLog(@"[ASSWatchdog] ASS not running.");
                        pid_t pid;
                        const char* args[] = {"killall", "mediaserverd", NULL};
                        posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
                        break;
                    }

                    r = connect(connfd, (struct sockaddr *)&remote, sizeof(remote));
                    usleep(200 * 1000);
                    retries++;
                }

                if (connfd > 0) {
                    NSLog(@"[ASSWatchdog] Connected.");
                    close(connfd);
                }
                
                break;
            }
        });

    } else {
        NSLog(@"[ASSWatchdog] abort, there's no ASS");
    }

    return orig;
}

%end