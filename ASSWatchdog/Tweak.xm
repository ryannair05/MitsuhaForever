#import <arpa/inet.h>
#import <spawn.h>
#define ASSPort 44333
const int one = 1;
int connfd;

%hook SpringBoard

-(id)init {
    id orig = %orig;
    NSLog(@"[ASSWatchdog] checking for ThiccASS");
    bool assPresent = [[NSFileManager defaultManager] fileExistsAtPath: @"/Library/MobileSubstrate/DynamicLibraries/ThiccASS.dylib"];
    if (assPresent) {
        NSLog(@"[ASSWatchdog] ThiccASS found... checking if msd is hooked");
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            struct sockaddr_in remote;
            remote.sin_family = PF_INET;
            remote.sin_port = htons(ASSPort);
            inet_aton("127.0.0.1", &remote.sin_addr);
            int r = -1;
            int retries = 0;

            while (connfd != -2) {
                NSLog(@"[ASSWatchdog] Connecting to ThiccASS.");
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
                        NSLog(@"[ASSWatchdog] ThiccASS not running.");
                        NSLog(@"[ASSWatchdog] abort, there's no ThicASS here...");
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
        NSLog(@"[ASSWatchdog] abort, there's no ThicASS here...");
    }

    return orig;
}

%end