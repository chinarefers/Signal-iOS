//
//  Copyright (c) 2019 Open Whisper Systems. All rights reserved.
//

#import "OWSSyncConfigurationRequestMessage.h"
#import <SignalServiceKit/SignalServiceKit-Swift.h>

NS_ASSUME_NONNULL_BEGIN

@implementation OWSSyncConfigurationRequestMessage

- (nullable SSKProtoSyncMessageBuilder *)syncMessageBuilderWithTransaction:(SDSAnyReadTransaction *)transaction;
{
    SSKProtoSyncMessageRequestBuilder *requestBuilder = [SSKProtoSyncMessageRequest builder];
    requestBuilder.type = SSKProtoSyncMessageRequestTypeConfiguration;

    NSError *error;
    SSKProtoSyncMessageRequest *_Nullable messageRequest = [requestBuilder buildAndReturnError:&error];
    if (error || !messageRequest) {
        OWSFailDebug(@"could not build protobuf: %@", error);
        return nil;
    }

    SSKProtoSyncMessageBuilder *builder = [SSKProtoSyncMessage builder];
    builder.request = messageRequest;
    return builder;
}

@end

NS_ASSUME_NONNULL_END
