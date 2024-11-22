import 'package:googleapis_auth/auth_io.dart';

const serviceAccount = {
  "type": "service_account",
  "project_id": "wordpress-3d152",
  "private_key_id": "db6ded3d31bf5e01e6f1e994d7012f61db9d15e0",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDX9FUixyX8VxNX\n+Z1Zn/IPmSqRT27Zqf2wSwXw77K2mgrzmqBQoZJJVHjqKT4/Gbj03XCD3ULoxl9w\ntwIkVY28aheF25jOvAqe+8SRkuhrG4SXPEkngi87ZLwomASqo5gWRab+oXQJKDZG\notc4oykiBTIrdODzuLX1UStUdwSr0b4WihqhxjmfPQnqxKLSoOcU8E4mC99CvQSm\nIOKO92Arzmdxe0tpNW4nxG3qFrbsC3UFX88SP6Mnf9OZQm7AuTpKjwJ5h6DTjYXW\nIZh8AH8Mx6BNvXS04K3etnPOb3FIoXCCxwgb3CGetWmJQ3GYw5XOOY4FWtKeJ15r\nje3XDhLRAgMBAAECggEAHD25Jn+psYrHnlEn6TEYDD8pCHC9W9y1rujYwY3vLp8N\ngJb/kRvYEBvqZiD3oXPhMrCExtHYLq3GjGx6bLr9ep7bLaeun5aKwwjEx47RMzSZ\njdeV74NAXwGI87wRnCkhugPo11LQ5GOsWWdxQthfiDHqwjEaO/UzYn33byfTZg6d\nxzcJw9E64kZ1pD1h02+cRbVYnilg1d+L5qM29xlaKt+nETmBCNoQiSxTXWkPKow5\nbVs6COJjuCQhkY0Yv2AYifgobHssez9cqzlihaz2X0MWC6oYH6VfEOxbs18gy77e\ndVU043DMu6JMFAz7Qn+Ub4BmepP39GSxIJe436vx+wKBgQDzS3EAlyGDG6Qytbiu\nA8rUBpaAGUKIhRWIIt/CjrrP63ZwbPLihpChFqW/rrCGTATJV2nOFbOEhyGMJNx9\nV6kuiG0IOfpJd1eqWTFmiCI0/BQB95J3cBI784/jQvuL20YFOnNX31wD+ARqZrNY\nTCCnAPNZsZqX+DakBzAtj50ZDwKBgQDjO2Ju1OSGI7v4W1qpWNodlzI7ggp4Ybuv\nZ9DAWR6zV3u0vXSNrKakMp+CIxKJeE1nPsQBQITA7HOOHxW37TY448pMMTJb0CuG\nXwWekpzErKsn+DkQe54rPNE1KnSQMnqFwZQvlQ8gsylC7eaEozB1WTCURRntbHdd\ntlGcJ5NWHwKBgQCtIqzCDMrucEdDRwqr20sF48JKWq98U6jk/lxaKhRLTnc0vnOC\nPNzDpkhBxmEc0RA+8BP9cngUAc4f20OFd1KQKMneptO0YFdkhKChJJOjPRhH5hS3\nJmvzefqVcd9swZhstBHNIMhskp0h0wAh/9rkvcpvs/Id36eSxwLECYV0hQKBgCLv\nkmav3KKzA8dfZET9ICvEfzie+bUgcZa6Q2IPUaUJIj/bkPvnO4erMNL1SXhRQrVI\n9SGsJbzznaCQLuqkUd3VR9kHB1MOYmK6YUbMC8ZBNd9jToK2Ps8u/otKB7nTyPqf\nlITsSfMhGIrtwK9L17tzBwEEzsOuFXwW990mSITJAoGBAOEV3n1VwDWYdm/OC1te\ny8ATavseYhyu/AESROXB1f3LrglfC5mWtkpcY3ozx4xGdTGHzY2YPBI8Q1Bm16g5\nIcIloFJjhyhx44OM5xaM+n6RjTILYoE7CeStBF0SZRg7LK/3zUBSkj4wDFSnB5Sv\nkGkWpqmzbWNUd2ktwbKjXwe6\n-----END PRIVATE KEY-----\n",
  "client_email": "firebase-adminsdk-ipey2@wordpress-3d152.iam.gserviceaccount.com",
  "client_id": "113495083134513733133",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-ipey2%40wordpress-3d152.iam.gserviceaccount.com",
};

Future<String> getAccessToken() async {
  final accountCredentials = ServiceAccountCredentials.fromJson(serviceAccount);
  final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

  final AuthClient authClient = await clientViaServiceAccount(accountCredentials, scopes);
  final accessToken = authClient.credentials.accessToken.data;

  authClient.close();
  return accessToken;
}
