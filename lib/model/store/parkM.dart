import 'package:atlantis_di_photos_app/model/image.dart';
import 'package:atlantis_di_photos_app/model/offers/offersM.dart';

// List<ParkM> parkFromJson(String str) =>
//     List<ParkM>.from(json.decode(str).map((x) => ParkM.fromJson(x)));

// String parkToJson(List<ParkM> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ParkM {
  String parkId;
  String parkName;
  int? selectedImageCount;
  List<ImageM> images;
  List<OfferPriceDetail> offers;

  ParkM({
    required this.parkId,
    required this.parkName,
    this.selectedImageCount,
    required this.images,
    required this.offers,
  });

  factory ParkM.fromJson(Map<String, dynamic> json) {
    var list1 = json['images'] as List;
    List<ImageM> imagesList = list1.map((i) => ImageM.fromJson(i)).toList();

    var list2 = json['offers'] as List;
    List<OfferPriceDetail> offersList =
        list2.map((i) => OfferPriceDetail.fromJson(i)).toList();

    return ParkM(
        parkId: json['parkId'],
        parkName: json['parkName'],
        selectedImageCount: json['selectedImageCount'],
        images: imagesList,
        offers: offersList);
  }

  Map<String, dynamic> toJson() {
    return {
      'parkId': parkId,
      'parkName': parkName,
      'selectedImageCount': selectedImageCount,
      'images': images.map((image) => image.toJson()).toList(),
      'offers': offers.map((offer) => offer.toJson()).toList(),

    };
  }
}
