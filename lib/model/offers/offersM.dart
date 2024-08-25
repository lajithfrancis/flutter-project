class OfferDetailM {
  bool? isSelected;
  final String imageUrl;
  final double price;
  final String currency;
  final String? videoThumbnail;
  final String? videoUrl;
  final bool isVideo;

  OfferDetailM({
    required this.isSelected,
    required this.imageUrl,
    required this.price,
    required this.currency,
    this.videoThumbnail,
    this.videoUrl,
    required this.isVideo,
  });

  factory OfferDetailM.fromJson(Map<String, dynamic> json) {
    return OfferDetailM(
      imageUrl: json['imageUrl'],
      isSelected: json['isSelected'],
      price: json['price'],
      currency: json['currency'],
      videoThumbnail: json['videoThumbnail'],
      videoUrl: json['videoUrl'],
      isVideo: json['isVideo'],
    );
  }
}

class OfferPriceDetail {
  final String? offerDetail;
  final int imageCount;
  final String amount;
  final String currency;

  OfferPriceDetail({
    this.offerDetail,
    required this.imageCount,
    required this.amount,
    required this.currency,
  });

  factory OfferPriceDetail.fromJson(Map<String, dynamic> json) {
    return OfferPriceDetail(
      offerDetail: json['offerDetail'] ?? "",
      imageCount: json['imageCount'] ?? 0,
      amount: json['amount'] ?? "0",
      currency: json['currency'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "offerDetail": offerDetail,
        "imageCount": imageCount,
        "amount": amount,
        "currency": currency,
      };
}
