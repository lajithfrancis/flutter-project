import 'package:atlantis_di_photos_app/Cart/widget/cartAppBar.dart';
import 'package:atlantis_di_photos_app/Cart/widget/payment_methods_widget.dart';
import 'package:atlantis_di_photos_app/model/image.dart';
import 'package:atlantis_di_photos_app/model/offers/offersM.dart';
import 'package:atlantis_di_photos_app/model/store/parkM.dart';
import 'package:atlantis_di_photos_app/utils/colors.dart';
import 'package:atlantis_di_photos_app/utils/constants.dart';
import 'package:atlantis_di_photos_app/web_service/get_cart_details.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  List<ParkM> parkDataList = [];
  bool isSelectedImageFromStore = false;
  CartScreen(
      {super.key,
      required this.parkDataList,
      required this.isSelectedImageFromStore});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<ImageM>? cartItems;
  List<ParkM> dataFromStore = [];
  List<ParkM> initialParkData = [];

  double imageSize = 0.0;
  double fontSizeTitle = 0.0;
  double fontSizeSubtitle = 0.0;
  int cartItemsCount = 0;
  // Variables for subtotal, discount, and total
  double subtotal = 0.0;
  double total = 0.0;
  double discount = 0.0;
  late Future<List<ParkM>> _cartDataFuture;

  @override
  void initState() {
    super.initState();
    _cartDataFuture = getCartDetails();
    print("isSelectedImageFromStore: ${widget.isSelectedImageFromStore}");

    if (widget.isSelectedImageFromStore) {
      setState(() {
        cartItems = filterSelectedImages(widget.parkDataList);
        calculateSubtotalTotalAndDiscount();
      });
    } else {
      _cartDataFuture.then((parkDataList) {
        setState(() {
          cartItems = filterSelectedImages(parkDataList);
          calculateSubtotalTotalAndDiscount(futureData: parkDataList);
        });
      });
    }
   
   mapInitialData();
  }

 //copy of parkDataList to store the initial state
  void mapInitialData() {
     initialParkData = widget.parkDataList.map((park) {
      return ParkM(
        parkId: park.parkId,
        parkName: park.parkName,
        selectedImageCount: park.selectedImageCount,
        images: park.images.map((image) {
          return ImageM(id: image.id, isSelected: image.isSelected, imageUrl: image.imageUrl, parkId: image.parkId);
        }).toList(),
        offers: park.offers.map((offer) {
          return OfferPriceDetail(imageCount: offer.imageCount, amount: offer.amount, currency: offer.currency);
        }).toList(),
      );
    }).toList();

  }

//while popping to store screen reset the data to initial data
  void resetToOriginalInitialData(){
    if (initialParkData != null){
        for(var data = 0; data < widget.parkDataList.length ; data ++ ){
          var initialPark = initialParkData[data];
          var currentPark = widget.parkDataList[data];
          // Reset selectedImageCount
          currentPark.selectedImageCount = initialPark.selectedImageCount;
            for (var j = 0; j < currentPark.images.length; j++) {
            currentPark.images[j].isSelected = initialPark.images[j].isSelected;
          }
        }
    }
  }

  @override
  void dispose() {
    widget.isSelectedImageFromStore = false;
    resetToOriginalInitialData();
    super.dispose();
  }

  List<ImageM> filterSelectedImages(List<ParkM> parkDataList) {
    return parkDataList
        .expand((park) => park.images)
        .where((image) => image.isSelected ?? false)
        .toSet()
        .toList();
  }

  void _removeCartItem(String id, {List<ParkM>? futureData}) {
    List<ParkM> parkData = widget.isSelectedImageFromStore
        ? widget.parkDataList
        : futureData ?? [];

    setState(() {
      for (var park in parkData) {
        for (var image in park.images) {
          if (image.id == id && image.isSelected == true) {
            image.isSelected = false;

            // Decrement the selectedImageCount for the park, ensuring it's not null
            if (park.selectedImageCount != null &&
                park.selectedImageCount! > 0) {
              park.selectedImageCount = park.selectedImageCount! - 1;
            }
          }
        }
      }
      // Remove the item from the cart items list, ensuring cartItems is not null
      if (cartItems != null) {
        cartItems = cartItems?.where((item) => item.id != id).toList() ?? [];
      }
      widget.isSelectedImageFromStore
          ? calculateSubtotalTotalAndDiscount()
          : calculateSubtotalTotalAndDiscount(futureData: futureData);
    });
  }

  void dynamicScreenSizeFunction() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if (screenHeight > 900) {
// For large screens
//13 pro max
      imageSize = screenWidth * 0.26;
      fontSizeTitle = screenWidth * 0.045;
      fontSizeSubtitle = screenWidth * 0.03;
      print("> 850");
    } else if (screenHeight > 860) {
//11 pro max
      imageSize = screenWidth * 0.25;
      fontSizeTitle = screenWidth * 0.045;
      fontSizeSubtitle = screenWidth * 0.03;
      print("> 850");
    }
    //iphone 15 | 15 Pro
    else if (screenHeight > 800) {
// For medium screens
      imageSize = screenWidth * 0.24;
      fontSizeTitle = screenWidth * 0.046;
      fontSizeSubtitle = screenWidth * 0.026;
      print("> 800");
    }
    //iphone 6s
    else if (screenHeight > 400) {
      imageSize = screenWidth * 0.225;
      fontSizeTitle = screenWidth * 0.047;
      fontSizeSubtitle = screenWidth * 0.028;
      print("> 400");
    } else {
// For smaller screens
      imageSize = screenWidth * 0.20;
      fontSizeTitle = screenWidth * 0.04;
      fontSizeSubtitle = screenWidth * 0.02;
      print("others");
    }
  }

//subtotal, discount and total calculation logic
  void calculateSubtotalTotalAndDiscount({List<ParkM>? futureData}) {
    double subtotal = 0.0;
    double totalDiscount = 0.0;

    List<ParkM> parkData = widget.isSelectedImageFromStore
        ? widget.parkDataList
        : futureData ?? [];

    for (var park in parkData) {
      double totalCost = 0.0;
      double discount = 0.0;
      // Calculate the subtotal cost for selected images
      for (var image in park.images) {
        if (image.isSelected == true) {
          totalCost += double.parse(image.price ?? '');
        }
      }

         // Check for matching offers
    for (var offer in park.offers) {
      if (offer.imageCount == park.selectedImageCount) {
        double offerAmount = double.parse(offer.amount);
        discount = totalCost - offerAmount;
        print(
            "Park: ${park.parkName}, Selected Images: ${park.selectedImageCount}, Original Cost: $subtotal, Offer Price: ${offerAmount}, Discount: $discount");
      }
    }
    subtotal += totalCost;
    totalDiscount += discount;

    

      // Check for matching offers
      // OfferPriceDetail? applicableOffer;
      // for (var offer in park.offers) {
      //   if (offer.imageCount == park.selectedImageCount) {
      //     applicableOffer = offer;
      //     break;
      //   }
      // }

      // if (applicableOffer != null) {
      //   // If an offer is applicable, add its value to the discount
      //   double offerAmount = double.parse(applicableOffer.amount);
      //   discount += (offerAmount);
      //   // total += offerAmount; // Add the offer amount to the total
      // }

      // print(
      //   "Park: ${park.parkName}, Selected Images: ${park.selectedImageCount}, Original Cost: $subtotal, Discount: $discount, Total: $total",
      // );
    }
    // Set the final subtotal, discount, and total
    setState(() {
      this.subtotal = subtotal;
      this.discount = totalDiscount;
      this.total = subtotal - totalDiscount;
    });
    print(
        "Final Subtotal: $subtotal, Final Discount: $discount, Final Total: $total");
  }

  @override
  Widget build(BuildContext context) {
    dynamicScreenSizeFunction();
    cartItemsCount = cartItems?.length ?? 0;
    return Scaffold(
        appBar: const CartAppBar(),
        body: FutureBuilder<List<ParkM>>(
            future: _cartDataFuture,
            builder:
                (BuildContext context, AsyncSnapshot<List<ParkM>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                final heightOfScreen = MediaQuery.of(context).size.height;
                //no purchased photo message
                return Center(
                  child: SizedBox(
                    height: heightOfScreen * 0.3,
                    child: const Text(
                      DIConstants.NoPurchasedPhotosText,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontFamily: DIConstants.AvertaDemoPE,
                          color: ConstColors.DIGreen),
                    ),
                  ),
                );
              } else {
                if (widget.isSelectedImageFromStore == true) {
                  cartItems = filterSelectedImages(widget.parkDataList);
                } else {
                  print("else case from api");
                  dataFromStore = snapshot.data ?? [];
                  cartItems = filterSelectedImages(snapshot.data ?? []);
                }

                return Column(
                  children: [
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          DIConstants.PurchasedValidity,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            fontFamily: DIConstants.AvertaDemoPE,
                            color: Color(0xFF0D7B8A),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartItems?.length,
                        itemBuilder: (context, index) {
                          final item = cartItems?[index];
                          return Column(
                            children: [
                              if (index == 0)
                                const Divider(
                                  thickness: 1,
                                  color: Color(0xFFECECEC),
                                ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 12.0, top: 5, bottom: 5, right: 18),
                                child: Flex(
                                  direction: Axis.horizontal,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    //image
                                    Container(
                                      width: imageSize,
                                      height: imageSize,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          image: NetworkImage(item?.imageUrl ?? ''),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    // Column for price and date
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          //price
                                          Text(
                                            "${item?.price} ${item?.currency}",
                                            style: TextStyle(
                                              fontSize: fontSizeTitle,
                                              fontWeight: FontWeight.w700,
                                              fontFamily:
                                                  DIConstants.AvertaDemoPE,
                                              color: ConstColors.DIGreen,
                                            ),
                                          ),
                                          // const SizedBox(height: 8),
                                          //date and time
                                          Text(
                                            item?.dateAndTime ?? "",
                                            style: TextStyle(
                                              fontSize: fontSizeSubtitle,
                                              fontFamily:
                                                  DIConstants.AvertaDemoPE,
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xFF757575),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Center(
                                      child: GestureDetector(
                                        onTap: () {
                                          print(item?.id);
                                          widget.isSelectedImageFromStore
                                              ? _removeCartItem(item?.id ?? '')
                                              : _removeCartItem(item?.id ?? '',
                                                  futureData: dataFromStore);
                                        },
                                        child: Image.asset(
                                          'assets/images/delete.png',
                                          width: 19.2,
                                          height: 28,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Divider for each row
                              const Divider(
                                thickness: 1,
                                color: Color(0xFFECECEC),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    if (cartItems?.isNotEmpty ?? false)
                      Column(children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Container(
                            // height: 140,
                            color: const Color(0xFFE0F5FA),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(DIConstants.SubTotalText,
                                          style: TextStyle(
                                              fontSize: fontSizeTitle,
                                              fontFamily:
                                                  DIConstants.AvertaDemoPE,
                                              fontWeight: FontWeight.w700,
                                              color: ConstColors.DIBGrey)),
                                      Text('$subtotal AED',
                                          style: TextStyle(
                                              fontSize: fontSizeTitle,
                                              fontFamily:
                                                  DIConstants.AvertaDemoPE,
                                              fontWeight: FontWeight.w700,
                                              color: ConstColors.DIGreen)),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(DIConstants.DiscountText,
                                          style: TextStyle(
                                              fontSize: fontSizeTitle,
                                              fontFamily:
                                                  DIConstants.AvertaDemoPE,
                                              fontWeight: FontWeight.w700,
                                              color: ConstColors.DIBGrey)),
                                      Text("$discount AED",
                                          style: TextStyle(
                                              fontSize: fontSizeTitle,
                                              fontFamily:
                                                  DIConstants.AvertaDemoPE,
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xFFFF5959))),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(DIConstants.TotalText,
                                          style: TextStyle(
                                              fontSize: fontSizeTitle,
                                              fontFamily:
                                                  DIConstants.AvertaDemoPE,
                                              fontWeight: FontWeight.w700,
                                              color: ConstColors.DIBGrey)),
                                      Text("$total AED",
                                          style: TextStyle(
                                              fontSize: fontSizeTitle,
                                              fontFamily:
                                                  DIConstants.AvertaDemoPE,
                                              fontWeight: FontWeight.w700,
                                              color: ConstColors.DIGreen)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 20),
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0D7B8A),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
                              onPressed: () {
                                PaymentMethodsOverlay.show(context);
                              },
                              child: const Text(DIConstants.purchaseAll,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Color(0xFFFFFFFF),
                                      fontFamily: DIConstants.AvertaDemoPE,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ),
                      ])
                  ],
                );
              }
            }));
  }
}
