import 'dart:convert';
import 'package:atlantis_di_photos_app/Cart/screens/cart_screen.dart';
import 'package:atlantis_di_photos_app/model/store/parkM.dart';
import 'package:atlantis_di_photos_app/utils/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StoreTab extends StatefulWidget {
  final ValueNotifier<int> countOfCheckboxes;

  const StoreTab({Key? key, required this.countOfCheckboxes}) : super(key: key);

  @override
  State<StoreTab> createState() => _StoreTabState();
}

class _StoreTabState extends State<StoreTab> {
  List<dynamic> imagePaths = [];
  List<String> aquaventureImages = [];
  List<String> lostChambersImages = [];
  List<String> dolphinBayImages = [];
  List<String> aquaventureImagesPaths = [];
  List<String> dolphinBayImagesPaths = [];
  List<String> lostChambersImagesPaths = [];

  List<String> aquaventureImagesTotal = [];
  List<String> lostChambersImagesTotal = [];
  List<String> dolphinBayImagesTotal = [];
  List<String> aquaventureImagesPathsTotal = [];
  List<String> dolphinBayImagesPathsTotal = [];
  List<String> lostChambersImagesPathsTotal = [];

  // late String aquaventureHeading;
  // late String dolphinBayHeading;
  // late String lostChambersHeading;

  // Initializing checkedStatus with all false values
  List<bool> checkedStatusAquaventurePhotos = [];
  List<bool> checkedStatusDolphinBayPhotos = [];
  List<bool> checkedStatusLostChambersPhotos = [];

  List<bool> checkedStatusAquaventurePhotosTotal = [];
  List<bool> checkedStatusDolphinBayPhotosTotal = [];
  List<bool> checkedStatusLostChambersPhotosTotal = [];

  int checkBox = 0;

  // State to control the visibility of the bottom popup bar
  bool isBottomBarVisible = false;

  @override
  void initState() {
    super.initState();
    _loadImagesFromJson();
  }

  bool get isAnyCheckboxSelected {
    return checkedStatusAquaventurePhotos.contains(true) ||
        checkedStatusDolphinBayPhotos.contains(true) ||
        checkedStatusLostChambersPhotos.contains(true) ||
        checkedStatusAquaventurePhotosTotal.contains(true) ||
        checkedStatusDolphinBayPhotosTotal.contains(true) ||
        checkedStatusLostChambersPhotosTotal.contains(true);
  }

  void _toggleBottomBar() {
    setState(() {
      isBottomBarVisible = true; // Show the bottom bar
    });

    // Automatically hide the bar after a few seconds
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isBottomBarVisible = false; // Hide the bottom bar
      });
    });
  }

  Widget buildImageGrid({
    required BuildContext context,
    required List<String> imagePaths,
    required List<bool> checkedStatus,
    required int columns,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1,
        ),
        itemCount: imagePaths.length,
        padding: const EdgeInsets.only(left: 25, right: 25),
        itemBuilder: (context, index) {
          final imageUrl = imagePaths[index];

          return Stack(
            alignment: AlignmentDirectional.bottomEnd,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              Theme(
                data: Theme.of(context).copyWith(
                  checkboxTheme: CheckboxThemeData(
                    side: MaterialStateBorderSide.resolveWith(
                      (states) => const BorderSide(
                        width: 2.0,
                        color: Colors.white,
                      ),
                    ),
                    fillColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected)) {
                          return Colors.white;
                        }
                        return Colors.transparent;
                      },
                    ),
                    checkColor: MaterialStateProperty.all<Color>(Colors.orange),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.03,
                    color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: '10.00',
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: ' AED',
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Transform.scale(
                            scale: 0.8,
                            child: Checkbox(
                              value: checkedStatus[index],
                              onChanged: (bool? value) {
                                setState(() {
                                  checkedStatus[index] = value!;
                                  if (value) {
                                    checkBox++;
                                    _toggleBottomBar();
                                  } else {
                                    checkBox--;
                                    // _updatePhotoSelection();
                                  }
                                  _updatePhotoSelection();
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _displayOffers() {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 25),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: const Color(0xffD9D9D9))),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "OFFERS:",
                style: TextStyle(
                    color: Color(0xff0D7B8A),
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Image.asset('assets/images/Vector_(3).png'),
                        const Padding(
                          padding: EdgeInsets.only(left: 3),
                          child: Text(
                            '3 Photos 20 AED',
                            style: TextStyle(
                                color: Color(0xff0D7B8A),
                                fontSize: 10,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Row(
                      children: [
                        Image.asset('assets/images/Vector_(3).png'),
                        const Padding(
                          padding: EdgeInsets.only(left: 3),
                          child: Text(
                            '5 Photos 30 AED',
                            style: TextStyle(
                                color: Color(0xff0D7B8A),
                                fontSize: 10,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Row(
                      children: [
                        Image.asset('assets/images/Vector_(3).png'),
                        const Padding(
                          padding: EdgeInsets.only(left: 3),
                          child: Text(
                            '20 Photos 40 AED',
                            style: TextStyle(
                                color: Color(0xff0D7B8A),
                                fontSize: 10,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  final List<String> _savedTitles = [];

  void _saveTitle(String title) {
    setState(() {
      if (!_savedTitles.contains(title)) {
        _savedTitles.add(title);
      }
    });
  }

  Widget buildCustomHeader({
    required String title,
    required String buttonText,
    required List<String> imagePaths,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xff0D7B8A),
              ),
            ),
            Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    disabledBackgroundColor: Colors.transparent,
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.white,
                    elevation: 0,
                    side: BorderSide(
                      color: imagePaths.isEmpty
                          ? const Color(0xffC6CDD1)
                          : const Color(0xff0D7B8A),
                      width: 1,
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ),
                  ),
                  onPressed: imagePaths.isNotEmpty
                      ? () {
                          _saveTitle(title);
                          _changeStack(title);
                        }
                      : null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        buttonText,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: imagePaths.isEmpty
                              ? const Color(0xffC6CDD1)
                              : const Color(0xff0D7B8A),
                        ),
                      ),
                      Icon(
                        color: imagePaths.isEmpty
                            ? const Color(0xffC6CDD1)
                            : const Color(0xff0D7B8A),
                        const IconData(
                          0xee8c,
                          fontFamily: 'MaterialIcons',
                          matchTextDirection: true,
                        ),
                        size: 12,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCustomHeader2({
    required String title,
    required List<String> imagePaths,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xff0D7B8A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _displayNoPhotos() {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: const Color(0xffD9D9D9))),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              "No photos available",
              style: TextStyle(
                  color: Color(0xff0D7B8A),
                  fontWeight: FontWeight.w400,
                  fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }

  void _updatePhotoSelection() {
    widget.countOfCheckboxes.value = checkBox;
  }

  Widget _buildFirstWidget() {
    final double screenWidth = MediaQuery.of(context).size.width;
    final int columns = (screenWidth / 120).floor();

    return Stack(children: [
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildCustomHeader(
                title: 'Aquaventure',
                buttonText: 'View More',
                imagePaths: aquaventureImagesPaths),
            _displayOffers(),
            aquaventureImagesPaths.isEmpty
                ? _displayNoPhotos()
                : buildImageGrid(
                    context: context,
                    imagePaths: aquaventureImagesPaths,
                    checkedStatus: checkedStatusAquaventurePhotos,
                    columns: columns,
                  ),
            buildCustomHeader(
                title: 'Lost Chambers',
                buttonText: 'View More',
                imagePaths: lostChambersImagesPaths),
            _displayOffers(),
            lostChambersImagesPaths.isEmpty
                ? _displayNoPhotos()
                : buildImageGrid(
                    context: context,
                    imagePaths: lostChambersImagesPaths,
                    checkedStatus: checkedStatusLostChambersPhotos,
                    columns: columns,
                  ),
            buildCustomHeader(
                title: 'Dolphin Bay',
                buttonText: 'View More',
                imagePaths: dolphinBayImagesPaths),
            _displayOffers(),
            dolphinBayImagesPaths.isEmpty
                ? _displayNoPhotos()
                : Padding(
                    padding: const EdgeInsets.only(bottom: 150),
                    child: buildImageGrid(
                        context: context,
                        imagePaths: dolphinBayImagesPaths,
                        checkedStatus: checkedStatusDolphinBayPhotos,
                        columns: columns),
                  ),
          ],
        ),
      ),

      Positioned(
        bottom: 10,
        left: 0,
        right: 0,
        child: SizedBox(
          child: Column(
            children: [
              const Text(
                "Discounts will be applied at checkout",
                style: TextStyle(
                    color: Color(0xff0D7B8A),
                    fontWeight: FontWeight.w400,
                    fontSize: 16),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30, left: 25, right: 25),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  // color: const Color(0xff0D7B8A),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      disabledBackgroundColor: const Color(0xffC6CDD1),
                      backgroundColor: const Color(0xff0D7B8A),
                      elevation: 0,
                      shape: const BeveledRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.zero)),
                    ),
                    onPressed: isAnyCheckboxSelected
                        ? () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              // Sample park data, need to populate this with actual data
                              List<ParkM> parkDataList = dataArray;
                              return CartScreen(parkDataList: parkDataList, isSelectedImageFromStore: true,);
                            }));
                          }
                        : null,
                    child: const Text(
                      'PROCEED TO CART',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // Toggle Bottom Bar (overlaps the Proceed to Cart button)
      if (isBottomBarVisible)
        Positioned(
          bottom: 0, // Adjust this value to be the height of the button
          left: 0,
          right: 0,
          child: Container(
            height: 56.5,
            decoration: const BoxDecoration(
                color: Color(0xffFFB600),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8), topRight: Radius.circular(8))),
            child: Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Image.asset('assets/images/Vector_(2).png'),
                      ),
                      const Center(
                        child: Text(
                          "Photos added to cart",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
    ]);
  }

  Widget _buildAquaventureWidget() {
    final double screenWidth = MediaQuery.of(context).size.width;
    final int columns = (screenWidth / 120).floor();

    return Column(
      children: [
        Expanded(
          child: Stack(children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildCustomHeader2(
                      title: 'Aquaventure',
                      imagePaths: aquaventureImagesPathsTotal),
                  _displayOffers(),
                  buildImageGrid(
                    context: context,
                    imagePaths: aquaventureImagesPathsTotal,
                    checkedStatus: checkedStatusAquaventurePhotosTotal,
                    columns: columns,
                  ),
                ],
              ),
            ),

            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: SizedBox(
                child: Column(
                  children: [
                    const Text(
                      "Discounts will be applied at checkout",
                      style: TextStyle(
                          color: Color(0xff0D7B8A),
                          fontWeight: FontWeight.w400,
                          fontSize: 16),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30, left: 25, right: 25),
                      child: SizedBox(
                        width: double.infinity,
                        height: 55,
                        // color: const Color(0xff0D7B8A),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            disabledBackgroundColor: const Color(0xffC6CDD1),
                            backgroundColor: const Color(0xff0D7B8A),
                            elevation: 0,
                            shape: const BeveledRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.zero)),
                          ),
                          onPressed: isAnyCheckboxSelected
                              ? () {
                                  // Your cart action here
                                }
                              : null,
                          child: const Text(
                            'PROCEED TO CART',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Toggle Bottom Bar (overlaps the Proceed to Cart button)
            if (isBottomBarVisible)
              Positioned(
                bottom: 0, // Adjust this value to be the height of the button
                left: 0,
                right: 0,
                child: Container(
                  height: 56.5,
                  decoration: const BoxDecoration(
                      color: Color(0xffFFB600),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8))),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Image.asset('assets/images/Vector_(2).png'),
                            ),
                            const Center(
                              child: Text(
                                "Photos added to cart",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ]),
        ),
      ],
    );
  }

  Widget _buildLostChamberWidget() {
    final double screenWidth = MediaQuery.of(context).size.width;
    final int columns = (screenWidth / 120).floor();

    return Stack(children: [
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildCustomHeader2(
                title: 'Lost Chambers',
                imagePaths: lostChambersImagesPathsTotal),
            _displayOffers(),
            buildImageGrid(
              context: context,
              imagePaths: lostChambersImagesPathsTotal,
              checkedStatus: checkedStatusLostChambersPhotosTotal,
              columns: columns,
            ),
          ],
        ),
      ),

      Positioned(
        bottom: 10,
        left: 0,
        right: 0,
        child: SizedBox(
          child: Column(
            children: [
              const Text(
                "Discounts will be applied at checkout",
                style: TextStyle(
                    color: Color(0xff0D7B8A),
                    fontWeight: FontWeight.w400,
                    fontSize: 16),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30, left: 25, right: 25),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  // color: const Color(0xff0D7B8A),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      disabledBackgroundColor: const Color(0xffC6CDD1),
                      backgroundColor: const Color(0xff0D7B8A),
                      elevation: 0,
                      shape: const BeveledRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.zero)),
                    ),
                    onPressed: isAnyCheckboxSelected
                        ? () {
                            // Your cart action here
                          }
                        : null,
                    child: const Text(
                      'PROCEED TO CART',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // Toggle Bottom Bar (overlaps the Proceed to Cart button)
      if (isBottomBarVisible)
        Positioned(
          bottom: 0, // Adjust this value to be the height of the button
          left: 0,
          right: 0,
          child: Container(
            height: 56.5,
            decoration: const BoxDecoration(
                color: Color(0xffFFB600),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8), topRight: Radius.circular(8))),
            child: Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Image.asset('assets/images/Vector_(2).png'),
                      ),
                      const Center(
                        child: Text(
                          "Photos added to cart",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
    ]);
  }

  Widget _buildDolphinBayWidget() {
    final double screenWidth = MediaQuery.of(context).size.width;
    final int columns = (screenWidth / 120).floor();

    return Column(
      children: [
        Expanded(
          child: Stack(children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildCustomHeader2(
                      title: 'Dolphin Bay',
                      imagePaths: dolphinBayImagesPathsTotal),
                  _displayOffers(),
                  buildImageGrid(
                    context: context,
                    imagePaths: dolphinBayImagesPathsTotal,
                    checkedStatus: checkedStatusDolphinBayPhotosTotal,
                    columns: columns,
                  ),
                ],
              ),
            ),

            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: SizedBox(
                child: Column(
                  children: [
                    const Text(
                      "Discounts will be applied at checkout",
                      style: TextStyle(
                          color: Color(0xff0D7B8A),
                          fontWeight: FontWeight.w400,
                          fontSize: 16),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30, left: 25, right: 25),
                      child: SizedBox(
                        width: double.infinity,
                        height: 55,
                        // color: const Color(0xff0D7B8A),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            disabledBackgroundColor: const Color(0xffC6CDD1),
                            backgroundColor: const Color(0xff0D7B8A),
                            elevation: 0,
                            shape: const BeveledRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.zero)),
                          ),
                          onPressed: isAnyCheckboxSelected
                              ? () {
                                  // Your cart action here
                                }
                              : null,
                          child: const Text(
                            'PROCEED TO CART',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Toggle Bottom Bar (overlaps the Proceed to Cart button)
            if (isBottomBarVisible)
              Positioned(
                bottom: 0, // Adjust this value to be the height of the button
                left: 0,
                right: 0,
                child: Container(
                  height: 56.5,
                  decoration: const BoxDecoration(
                      color: Color(0xffFFB600),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8))),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child:
                                  Image.asset('assets/images/Vector_(2).png'),
                            ),
                            const Center(
                              child: Text(
                                "Photos added to cart",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ]),
        ),
      ],
    );
  }

  int _currentIndex = 0;

  void _changeStack(String category) {
    setState(() {
      if (category == 'Aquaventure') {
        _currentIndex = 1;
      } else if (category == 'Lost Chambers') {
        _currentIndex = 2;
      } else if (category == 'Dolphin Bay') {
        _currentIndex = 3;
      } else {
        _currentIndex = 0; // Default to first widget if needed
      }
    });
  }

  Future<void> _loadImagesFromJson() async {
    // Load the JSON file
    final String response = await rootBundle.loadString('assets/images.json');
    final data = json.decode(response);

    // Extract the image paths
    List<dynamic> loadedImagePaths = data['images'];

    //   aquaventureHeading = data['images'].keys.first;
    //   dolphinBayHeading = data['images'].keys.second;
    //   lostChambersHeading = data['iamges'].keys.third;

    for (var image in loadedImagePaths) {
      if (image['id'] == "Aquaventure" && aquaventureImages.length < 6) {
        aquaventureImages.add(image['url']);
      } else if (image['id'] == 'Lost Chambers' && lostChambersImages.length < 6) {
        lostChambersImages.add(image['url']);
      } else if (image['id'] == 'Dolphin Bay' && dolphinBayImages.length < 6) {
        dolphinBayImages.add(image['url']);
      }
    }

    for (var image in loadedImagePaths) {
      if (image['id'] == "Aquaventure" ) {
        aquaventureImagesTotal.add(image['url']);
      } else if (image['id'] == 'Lost Chambers') {
        lostChambersImagesTotal.add(image['url']);
      } else if (image['id'] == 'Dolphin Bay') {
        dolphinBayImagesTotal.add(image['url']);
      }
    }

    // for (var image in loadedImagePaths) {
    //   if (image['id'] == "Aquaventure") {
    //     aquaventureImages.add(image['url']);
    //   } else if (image['id'] == 'Lost Chambers') {
    //     lostChambersImages.add(image['url']);
    //   } else if (image['id'] == 'Dolphin Bay') {
    //     dolphinBayImages.add(image['url']);
    //   }
    // }

    setState(() {
      imagePaths = loadedImagePaths;
      aquaventureImagesPaths = aquaventureImages;
      lostChambersImagesPaths = lostChambersImages;
      dolphinBayImagesPaths = dolphinBayImages;
      aquaventureImagesPathsTotal = aquaventureImagesTotal;
      dolphinBayImagesPathsTotal = dolphinBayImagesTotal;
      lostChambersImagesPathsTotal = lostChambersImagesTotal;
      checkedStatusAquaventurePhotos =
          List<bool>.filled(aquaventureImagesPaths.length, false);
      checkedStatusLostChambersPhotos =
          List<bool>.filled(lostChambersImagesPaths.length, false);
      checkedStatusDolphinBayPhotos =
          List<bool>.filled(dolphinBayImagesPaths.length, false);
      checkedStatusAquaventurePhotosTotal =
          List<bool>.filled(aquaventureImagesPathsTotal.length, false);
      checkedStatusDolphinBayPhotosTotal =
          List<bool>.filled(dolphinBayImagesPathsTotal.length, false);
      checkedStatusLostChambersPhotosTotal =
          List<bool>.filled(lostChambersImagesPathsTotal.length, false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_currentIndex == 0) _buildFirstWidget(),
        if (_currentIndex == 1) _buildAquaventureWidget(),
        if (_currentIndex == 2) _buildLostChamberWidget(),
        if (_currentIndex == 3) _buildDolphinBayWidget()
      ],
    );
  }
}
