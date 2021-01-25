const amplifyconfig = ''' {
    "UserAgent": "aws-amplify-cli/2.0",
    "Version": "1.0",
    "auth": {
        "plugins": {
            "awsCognitoAuthPlugin": {
                "UserAgent": "aws-amplify-cli/0.1.0",
                "Version": "0.1.0",
                "IdentityManager": {
                    "Default": {}
                },
                "CognitoUserPool": {
                    "Default": {
                        "PoolId": "ap-northeast-1_oS6Gjckyt",
                        "AppClientId": "4qld7vt53iacu88dakooke0qn8",
                        "AppClientSecret": "4agum0fsmjjlc0r0mih0n37hq1bh5vdluuc58fane9duo3tkk0p",
                        "Region": "ap-northeast-1"
                    }
                },
                "Auth": {
                    "Default": {
                        "authenticationFlowType": "USER_SRP_AUTH"
                    }
                },
                "S3TransferUtility": {
                    "Default": {
                        "Bucket": "skilltrain-bucket164607-dev",
                        "Region": "ap-northeast-1"
                    }
                },
                "DynamoDBObjectMapper": {
                    "Default": {
                        "Region": "ap-northeast-1"
                    }
                },
                "PinpointAnalytics": {
                    "Default": {
                        "AppId": "b89a274921c844998f3a6b6ca843a493",
                        "Region": "us-west-2"
                    }
                },
                "PinpointTargeting": {
                    "Default": {
                        "Region": "us-west-2"
                    }
                }
            }
        }
    },
    "analytics": {
        "plugins": {
            "awsPinpointAnalyticsPlugin": {
                "pinpointAnalytics": {
                    "appId": "b89a274921c844998f3a6b6ca843a493",
                    "region": "us-west-2"
                },
                "pinpointTargeting": {
                    "region": "us-west-2"
                }
            }
        }
    },
    "storage": {
        "plugins": {
            "awsS3StoragePlugin": {
                "bucket": "skilltrain-bucket164607-dev",
                "region": "ap-northeast-1",
                "defaultAccessLevel": "guest"
            },
            "awsDynamoDbStoragePlugin": {
                "partitionKeyName": "username",
                "region": "ap-northeast-1",
                "arn": "arn:aws:dynamodb:ap-northeast-1:958561750757:table/trainers-dev",
                "streamArn": "arn:aws:dynamodb:ap-northeast-1:958561750757:table/trainers-dev/stream/2021-01-13T04:51:46.175",
                "partitionKeyType": "S",
                "name": "trainers-dev"
            }
        }
    }
}''';