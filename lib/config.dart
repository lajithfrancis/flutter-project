import 'package:adyen_checkout/adyen_checkout.dart';

class Config {
  /*
  Your `CLIENT_KEY` and `X_API_KEY` are sensitive credentials that must be secure.

  Do not provide them in your live environment through constants, because this is not secure. Instead, provide them dynamically from your server-side.

  For testing the example app, create a `secrets.json` file that contains the following properties:
  {
    "CLIENT_KEY" : "YOUR_CLIENT_KEY",
    "X_API_KEY" : "YOUR X_API_KEY"
    "APPLE_PAY_MERCHANT_ID_KEY": "YOUR_APPLE_PAY_MERCHANT_ID_KEY"
  }
  */
  // static const String credential_id = 'CRED42CN4223227M5L86N4RDX42TD7';
  static const String clientKey = 'test_ZSLMMZYW7JA5DK5OJCICNVP37EYWREKA';
  static const String xApiKey =
      'AQEvhmfxLorOYhZGw0m/n3Q5qf3Vfbh5LJBJV3BY0i38xoEuH0HubKIU29aC3HyLiUAQwV1bDb7kfNy1WIxIIkxgBw==-SQhK6h/aSZHDBiWkJu3Eo8iVwxDr1Ho0H5IXu86npvI=-i1iD{CTCn[m:E97{=qk';

  // static const String clientKey = 'test_CSPZSLVVXFDFFIRZH3HOLYUPZAJFM5YW';
  // static const String xApiKey =
  //     'AQEvhmfxLYzKbxBKw0m/n3Q5qf3Vfbh5LJBJV3BY0i38xol3BCpbofRHpPlVMLrPBukQwV1bDb7kfNy1WIxIIkxgBw==-iFLYqhJhbqnO7IJSt9Uzwjf8PKHmqPZCApU2pL+hS3k=-i1i#7zU[B2zNsSf.ztX';
  static const String merchantId = 'USTAccount578_Test12_TEST';
  static const String publicKey =
      '10001|CD43CEB9990E04E07BF512030FD57F67EF75F07C5440A72F0E88F2605A314A19326A2080C26AB6D99DFB0C9A8C08573C140F200AB3D0989F1921731CD19EB238D87273D128778B2C1F48E463751EAEA4A6E0E347ADF9D63B1B5708FFF582D7F5694B70A395173A8D4B5B3EC04FE69CFD3E23317AAE10DE3A06ED0C9EBEE9817251A40887E18DD15A9C535B15FD4957EE8D252CA08503D5A7ABEBE079790B49D79355D7D4FE6C5637CCE6DBCE288A0DE006500F89D75870B7B9C7B54206BE7FE43624BD28B708F1298DD46562996D3147D290336205EE2843E5A3B3EC32F370E19A95B408910656A6B33AD40C5D1EC5F8C65E3602C2C415D18EBCBA02A39B30D9';

  //Environment constants
  static const String merchantAccount = "USTAccount578_Test12_TEST";
  static const String merchantName = "Test Merchant";
  static const String countryCode = "NL";
  static const String shopperLocale = "en-US";
  static const String shopperReference = "Test reference";
  static const Environment environment = Environment.test;
  static const String baseUrl = "checkout-test.adyen.com";
  static const String apiVersion = "v71";
  static const String iOSReturnUrl = "flutter-ui-host://payments";
  static const GooglePayEnvironment googlePayEnvironment =
      GooglePayEnvironment.test;

  //Example data
  static Amount amount = Amount(currency: "EUR", value: 11295);
}
