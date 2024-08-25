import 'package:atlantis_di_photos_app/Cart/screens/cart_screen.dart';
import 'package:flutter/material.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
      child: ElevatedButton(
          onPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => CartScreen(),
            //   ),
            // );
          },
          child: Text("ADD TO CART")),
    ));
  }
}
