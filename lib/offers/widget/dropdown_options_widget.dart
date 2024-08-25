import 'package:atlantis_di_photos_app/model/offers/offersM.dart';
import 'package:atlantis_di_photos_app/utils/colors.dart';
import 'package:atlantis_di_photos_app/utils/constants.dart';
import 'package:atlantis_di_photos_app/web_service/get_offers_dropdown.dart';
import 'package:flutter/material.dart';

class DropdownOptionsWidget extends StatefulWidget {
  final Function(String, int, String) onOptionSelected;
  final String selectedOption;
  final String selectedOfferAmount;
  const DropdownOptionsWidget(
      {super.key,
      required this.onOptionSelected,
      required this.selectedOption,
      required this.selectedOfferAmount});

  @override
  State<DropdownOptionsWidget> createState() => _DropdownOptionsWidgetState();
}

class _DropdownOptionsWidgetState extends State<DropdownOptionsWidget> {
  int? selectedDropdownOptionIndex;
  late Future<OfferDetailM> offerDetailData;
  late Future<List<OfferPriceDetail>> _offerDropdownFuture;

  @override
  void initState() {
    super.initState();

    _offerDropdownFuture = getOffersDropdown();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: ConstColors.DIOfferDropdownBorderGrey,
            width: 1,
          ),
        ),
        width: DIConstants.getScreenWidth(context) - 38,
        child: FutureBuilder<List<OfferPriceDetail>>(
            future: _offerDropdownFuture,
            builder: (BuildContext context,
                AsyncSnapshot<List<OfferPriceDetail>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data?.isEmpty == true) {
                return const Center(child: Text('No data available'));
              } else {
                final offerDropdownList = snapshot.data!;
                selectedDropdownOptionIndex = offerDropdownList.indexWhere(
                  (offer) =>
                      'Choose ${offer.imageCount} image for ${offer.amount} ${offer.currency} ' ==
                      widget.selectedOption,
                );

                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: offerDropdownList.length,
                  itemBuilder: (context, dropdownIndex) {
                    bool isFirst = dropdownIndex == 0;
                    bool isLast = dropdownIndex == offerDropdownList.length - 1;
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft:
                              isFirst ? const Radius.circular(8) : Radius.zero,
                          topRight:
                              isFirst ? const Radius.circular(8) : Radius.zero,
                          bottomLeft:
                              isLast ? const Radius.circular(8) : Radius.zero,
                          bottomRight:
                              isLast ? const Radius.circular(8) : Radius.zero,
                        ),
                        color: selectedDropdownOptionIndex == dropdownIndex
                            ? ConstColors.DIGreenOffersTabWithOpacity
                            : Colors.white,
                      ),
                      child: ListTile(
                        title: Text(
                          // offerDropdownList[dropdownIndex].offerDetail,
                          'Choose ${offerDropdownList[dropdownIndex].imageCount} image for ${offerDropdownList[dropdownIndex].amount} ${offerDropdownList[dropdownIndex].currency} ',
                          style: TextStyle(
                              fontFamily: DIConstants.AvertaDemoPE,
                              fontWeight:
                                  selectedDropdownOptionIndex == dropdownIndex
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                              fontSize: 12,
                              color: ConstColors.DIOfferDropdownTextColor),
                        ),
                        onTap: () {
                          final selectedDpOption =
                              'Choose ${offerDropdownList[dropdownIndex].imageCount} image for ${offerDropdownList[dropdownIndex].amount} ${offerDropdownList[dropdownIndex].currency} ';

                          setState(() {
                            selectedDropdownOptionIndex = dropdownIndex;
                            // offerDropdownList[dropdownIndex]
                                // .selectedDropdownOption = selectedDpOption;
                          });
                          // Future.delayed(const Duration(milliseconds: 300), () {
                          //   widget.onOptionSelected(
                          //     offerDropdownList[dropdownIndex]
                          //         .selectedDropdownOption = selectedDpOption,
                          //     offerDropdownList[dropdownIndex].imageCount,
                          //     offerDropdownList[dropdownIndex].amount +
                          //         '.00' +
                          //         " " +
                          //         offerDropdownList[dropdownIndex].currency,
                          //   );
                          // }
                          // );
                        },
                      ),
                    );
                  },
                );
              }
            }));
  }
}
