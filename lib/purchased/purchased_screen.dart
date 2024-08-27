import 'package:atlantis_di_photos_app/Cart/screens/cart_screen.dart';
import 'package:atlantis_di_photos_app/purchased/widget/download_image_widget.dart';
import 'package:atlantis_di_photos_app/store/screens/store.dart';
import 'package:atlantis_di_photos_app/utils/colors.dart';
import 'package:atlantis_di_photos_app/utils/constants.dart';
import 'package:flutter/material.dart';

class PhotoBooth extends StatefulWidget {
  const PhotoBooth({super.key});

  @override
  State<PhotoBooth> createState() => _PhotoBoothState();
}

class _PhotoBoothState extends State<PhotoBooth>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  // Use ValueNotifier to manage the selected photo state
  ValueNotifier<bool> isAnyPhotoSelected = ValueNotifier<bool>(false);

  final ValueNotifier<int> countOfCheckboxes = ValueNotifier<int>(0);

  @override
  void dispose() {
    isAnyPhotoSelected.dispose();
    _tabController.dispose();
    super.dispose();
  }

  // Update AppBar Icon
  Widget _buildAppBarIcon() {
    return ValueListenableBuilder<int>(
      valueListenable: countOfCheckboxes,
      builder: (context, checkbox, _) {
        return InkWell(
          onTap: () {
            if (checkbox > 0) {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return CartScreen(parkDataList: [], isSelectedImageFromStore: false,);
              }));
            }
          },
          child: Stack(
            children: [
              Image.asset(
                'assets/images/cart.png',
                width: 24,
              ),
              if (checkbox > 0)
                Positioned(
                  right: 0,
                  // left: 5,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF5959),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void navigateToPurchasedTab() {
    _tabController.animateTo(1); // Index of the Purchased tab
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width and calculate the number of columns
    // final double screenWidth = MediaQuery.of(context).size.width;
    // final int columns = (screenWidth / 120).floor(); // Adjust 120 for desired item width

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          // elevation: 0,
          leading: IconButton(
            icon: Image.asset(
              'assets/images/backButton.png',
              height: 19,
              width: 10.24,
            ),
            onPressed: () {},
          ),
          title: const Center(
            child: Text(
              'Photo Booth',
              style: TextStyle(
                fontFamily: DIConstants.SkiaFont,
                color: ConstColors.DIGreen,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 25),
              child: SizedBox(
                width: 24,
                child: _buildAppBarIcon(),
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: IntrinsicWidth(
                child: TabBar(
                  tabAlignment: TabAlignment.start,
                  controller: _tabController,
                  isScrollable: true,
                  labelPadding: const EdgeInsets.only(
                    left: 25.0,
                  ), // Reduce horizontal padding
                  indicatorPadding:
                      const EdgeInsetsDirectional.only(bottom: 10),
                  splashFactory:
                      NoSplash.splashFactory, //remove splash when tab changed
                  labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ConstColors.DIGreen,
                      fontFamily: DIConstants.AvertaDemoPE),
                  unselectedLabelStyle: const TextStyle(
                      color: Color(0xff70828B),
                      fontWeight: FontWeight.w500,
                      fontFamily: DIConstants.AvertaDemoPE),
                  dividerColor: Colors.transparent,
                  indicatorColor: ConstColors.DIGreen,
                  tabs: const [
                    Tab(
                      child: Text(
                        'Store',
                      ),
                    ),
                    // Tab(
                    //   child: Text('Offers'),
                    // ),
                    Tab(
                      child: Text(
                        'Purchased',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            StoreTab(countOfCheckboxes: countOfCheckboxes),
            const DownloadImageWidget()
          ],
        ),
      ),
    );
  }
}
