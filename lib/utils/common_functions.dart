import 'dart:io';
import 'dart:typed_data';
import 'package:atlantis_di_photos_app/model/image.dart';
import 'package:atlantis_di_photos_app/model/offers/offersM.dart';
import 'package:atlantis_di_photos_app/model/store/parkM.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Future<void> shareImageFromAssets({
  required String assetPath,
  required String fileName,
  String? text,
}) async {
  try {
    final ByteData bytes = await rootBundle.load(assetPath);
    final Uint8List list = bytes.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/$fileName').create();

    await file.writeAsBytes(list);

    await Share.shareXFiles(
      [XFile(file.path)],
    );
  } catch (e) {
    print('Error sharing image: $e');
  }
}

Future<void> printSavedImagePath() async {
  final dir = await getApplicationDocumentsDirectory();
  final folder = Directory('${dir.path}/MyDownloadedImages');
  print('Images are saved in: ${folder.path}');
}

var dataArray = [
  ParkM(
    parkId: "kjwjfljwlef",
    parkName: "AquaVenture",
    selectedImageCount: 3,
    images: [
      ImageM(
          isDownloaded: false,
          imageUrl: "https://picsum.photos/id/237/200/300",
          id: "kjfw",
          parkId: "kjwjfljwlef",
          price: '10',
          currency: "AED",
          isSelected: true,
          dateAndTime: "2024-05-10 | 01:40 PM"),
      ImageM(
          isDownloaded: false,
          imageUrl: "https://picsum.photos/id/238/200/300",
          id: "rhkwejkr",
          parkId: "kjwjfljwlef",
          price: '10',
          currency: "AED",
          isSelected: true,
          dateAndTime: "2024-06-28 | 12:30 PM"),
      ImageM(
          isDownloaded: false,
          imageUrl: "https://picsum.photos/id/239/200/300",
          id: "mfkhjfhrk",
          parkId: "kjwjfljwlef",
          price: '10',
          currency: "AED",
          isSelected: true,
          dateAndTime: "2024-02-8 | 1:39 PM"),
    ],
    offers: [
      OfferPriceDetail(
        offerDetail: "",
        imageCount: 3,
        amount: "20",
        currency: "AED",
      ),
       OfferPriceDetail(
        offerDetail: "",
        imageCount: 6,
        amount: "40",
        currency: "AED",
      ),
       OfferPriceDetail(
        offerDetail: "",
        imageCount: 10,
        amount: "90",
        currency: "AED",
      ),
    ],
  ),
  ParkM(
    parkId: "jsdkhdncvsdv",
    parkName: "Dolphin Bay",
    selectedImageCount: 2,
    images: [
      ImageM(
          isDownloaded: false,
          imageUrl: "https://picsum.photos/id/234/200/300",
          id: "jhdsjhjfd",
          parkId: "jsdkhdncvsdv",
          price: '10',
          currency: "AED",
          isSelected: true,
          dateAndTime: "2024-04-10 | 11:05 PM"),
      ImageM(
          isDownloaded: false,
          imageUrl: "https://picsum.photos/id/239/200/300",
          id: "mnbcjdhfjsdf",
          parkId: "jsdkhdncvsdv",
          price: '10',
          currency: "AED",
          isSelected: true,
          dateAndTime: "2024-06-23 | 8:04 PM"),
             ImageM(
          isDownloaded: false,
          imageUrl: "https://picsum.photos/id/239/200/300",
          id: "bvjjwehjdwef",
          parkId: "jsdkhdncvsdv",
          price: '18',
          currency: "AED",
          isSelected: false,
          dateAndTime: "2024-06-23 | 8:04 PM")
    ],
    offers: [
      OfferPriceDetail(
        offerDetail: "",
        imageCount: 2,
        amount: "12",
        currency: "AED",
      ),
      OfferPriceDetail(
        offerDetail: "",
        imageCount: 10,
        amount: "60",
        currency: "AED",
      ),
       OfferPriceDetail(
        offerDetail: "",
        imageCount: 8,
        amount: "50",
        currency: "AED",
      ),
    ],
  )
];