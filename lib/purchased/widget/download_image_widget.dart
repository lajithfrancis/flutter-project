import 'dart:io';
import 'dart:math';
import 'package:atlantis_di_photos_app/model/purchased/purchasedM.dart';
import 'package:atlantis_di_photos_app/previewImage/preview_purchased_image.dart';
import 'package:atlantis_di_photos_app/purchased/widget/image_downloaded_bottom_toast_widget.dart';
import 'package:atlantis_di_photos_app/utils/constants.dart';
import 'package:atlantis_di_photos_app/web_service/get_purchased_details.dart';
import 'package:flutter/material.dart';
import 'package:atlantis_di_photos_app/utils/colors.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class DownloadImageWidget extends StatefulWidget {
  const DownloadImageWidget({super.key});

  @override
  State<DownloadImageWidget> createState() => _DownloadImageWidgetState();
}

class _DownloadImageWidgetState extends State<DownloadImageWidget> {
  late Future<List<PurchasedM>> _purchasedImageFuture;

  @override
  void initState() {
    super.initState();
    _purchasedImageFuture = getPurchasedImages();
  }

  Future<void> _downloadPurchasedImage(
      int sectionIndex, int index, String _url) async {
    String? finalPath;

    try {
      final http.Response response = await http.get(Uri.parse(_url));
      if (response.statusCode == 200) {
        // Get directory based on platform
        final dir = Platform.isAndroid
            ? await getExternalStorageDirectory() // Android
            : await getApplicationDocumentsDirectory(); // iOS
        //time format
        final now = DateTime.now();
        final dateFormat = DateFormat('yyyy MMM dd');
        final timeFormat = DateFormat('h:mm:ss a'); // 12-hour format with AM/PM
        final datePart = dateFormat.format(now);
        final timePart = timeFormat.format(now);
        var filename = '${dir?.path}/DEI_Image_${datePart}_${timePart}.png';

        // var filename = '${dir?.path}/DEI_Image_$filename.png';
        final file = File(filename);
        await file.writeAsBytes(response.bodyBytes);

        final params = SaveFileDialogParams(sourceFilePath: file.path);
       final fileDialogResponse = await FlutterFileDialog.saveFile(params: params);
        finalPath = file.path;

        if (fileDialogResponse != null) {
          setState(() {
            _updateDownloadedStatus(
                context, sectionIndex, index, true, finalPath);
          });
          _showToast(DIConstants.imageSavedMsg);
        } else {
          setState(() {
            _updateDownloadedStatus(context, sectionIndex, index, false, null);
          });
          _showToast(DIConstants.imageSaveCancelledMessage);
        }
      } else {
        setState(() {
          _updateDownloadedStatus(context, sectionIndex, index, false, null);
        });
        _showToast(DIConstants.imageSaveFailedMessage);
      }
    } catch (e) {
      setState(() {
        _updateDownloadedStatus(context, sectionIndex, index, false, null);
      });
      _showToast("Something went wrong");
    }
  }

  void _updateDownloadedStatus(BuildContext context, int sectionIndex,
      int index, bool isDownloaded, String? localPath) {
    setState(() {
      _purchasedImageFuture.then((list) {
        if (list.isNotEmpty) {
          list[sectionIndex].imageDetail[index].isDownloaded = isDownloaded;
          list[sectionIndex].imageDetail[index].localPath = localPath;
        }
      });
    });
  }

  void _showToast(String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: ImageDownloadedBottomToastWidget(
            message: message,
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

  void _navigateToImagePreview(BuildContext context, String finalPath) async {
    if (finalPath != null) {
      File file = File(finalPath);
      if (await file.exists()) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PreviewPurchasedImage(localImagePath: finalPath),
          ),
        );
      } else {
        _showToast('Image not found!');
      }
    } else {
      _showToast('No image selected!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: FutureBuilder<List<PurchasedM>>(
        future: _purchasedImageFuture,
        builder:
            (BuildContext context, AsyncSnapshot<List<PurchasedM>> snapshot) {
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
            final purchasedImageList = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        color: ConstColors.DIGreen,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: purchasedImageList.length,
                    itemBuilder: (context, sectionIndex) {
                      final isFirstItem = sectionIndex == 0;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                10, isFirstItem ? 10 : 30, 10, 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  purchasedImageList[sectionIndex]
                                      .purchasedDate,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: ConstColors.DIGreen,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: DIConstants.AvertaDemoPE,
                                  ),
                                ),
                                Text(
                                  'Download Until ${_calculateDownloadUntilDate(purchasedImageList[sectionIndex].purchasedDate)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: ConstColors.DIGreen,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: DIConstants.AvertaDemoPE,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: purchasedImageList[sectionIndex]
                                .imageDetail
                                .length,
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent:
                                  // Max extent of each cell
                                  screenWidth / 3,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              // Ensure square cells
                              childAspectRatio: 1,
                            ),
                            itemBuilder: (context, index) {
                              final data = purchasedImageList[sectionIndex]
                                  .imageDetail[index];
                              final double imageSize = screenWidth / 3 - 10;
                              return SizedBox(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: data.isDownloaded ?? false
                                          ? () => _navigateToImagePreview(
                                              context, data.localPath ?? '')
                                          : null,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          data.imageUrl,
                                          fit: BoxFit.cover,
                                          width: imageSize,
                                          height: imageSize,
                                        ),
                                      ),
                                    ),
                                    if (data.isDownloaded != null &&
                                        !data.isDownloaded!)
                                      GestureDetector(
                                        onTap: () {
                                          _downloadPurchasedImage(sectionIndex,
                                              index, data.imageUrl);
                                        },
                                        child: Image.asset(
                                          'assets/images/downloadIcon.png',
                                          height: 50,
                                          width: 50,
                                        ),
                                      )
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

String _calculateDownloadUntilDate(String purchasedDate) {
  try {
    // Assuming the purchasedDate is in "dd MMM" format, e.g., "25 Jun"
    final DateFormat dateFormat = DateFormat('dd MMM');
    DateTime purchasedDateParsed = dateFormat.parse(purchasedDate);

    // Add 15 days to the purchased date
    DateTime downloadUntilDate =
        purchasedDateParsed.add(const Duration(days: 15));

    // Format the new date back to "dd MMM"
    return dateFormat.format(downloadUntilDate);
  } catch (e) {
    // If there's an error in parsing the date, fallback to a default message
    return 'Invalid date';
  }
}
