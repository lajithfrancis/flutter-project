import 'dart:io';

import 'package:adyen_checkout/adyen_checkout.dart';
import 'package:atlantis_di_photos_app/config.dart';
import 'package:atlantis_di_photos_app/network/models/line_item.dart';
import 'package:atlantis_di_photos_app/network/service.dart';
import 'package:atlantis_di_photos_app/utils/payment_event_handler.dart';

class AdyenBaseRepository {
  AdyenBaseRepository({
    required this.service,
  });

  final Service service;
  final PaymentEventHandler paymentEventHandler = PaymentEventHandler();

  Future<String> determineBaseReturnUrl() async {
    if (Platform.isAndroid) {
      return await AdyenCheckout.instance.getReturnUrl();
    } else if (Platform.isIOS) {
      return Config.iOSReturnUrl;
    } else {
      throw Exception("Unsupported platform");
    }
  }

  String determineChannel() {
    if (Platform.isAndroid) {
      return "Android";
    }

    if (Platform.isIOS) {
      return "iOS";
    }

    throw Exception("Unsupported platform");
  }

  List<LineItem> createLineItems() {
    return [
      LineItem(
        quantity: 1,
        amountExcludingTax: 331,
        taxPercentage: 2100,
        description: "Shoes",
        id: "Item #1",
        taxAmount: 69,
        amountIncludingTax: 400,
        productUrl: "URL_TO_PURCHASED_ITEM",
        imageUrl: "URL_TO_PICTURE_OF_PURCHASED_ITEM",
      )
    ];
  }
}
