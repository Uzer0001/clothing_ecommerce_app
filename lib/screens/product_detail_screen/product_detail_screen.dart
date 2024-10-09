import 'package:flutter/material.dart';

import '../../widget/support_widget.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFfef5f1),
      body: Container(
        padding: const EdgeInsets.only(top: 50.0,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 20.0),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(30)),
                    child: const Icon(Icons.arrow_back_ios_new_outlined),
                  ),
                ),
                Center(
                  child: Image.asset(
                    "assets/logo/cover_logo.png",
                    height: 400,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 20.0,left: 20.0,right: 20.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
                ),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Tshirt",style: AppWidget.boldTextfieldStyle(),),
                         const Text("Rs. 500",
                        style: TextStyle(
                            color: Color(0xfffd6f3e),
                            fontSize: 23.0,
                            fontWeight: FontWeight.bold))
                      ],
                    ),
                    const SizedBox(height: 20.0,),
                    Text("details",style: AppWidget.semiBoldTextfieldsize(),),
                    const SizedBox(height: 20.0,),
                    const Text("This Tshirt is very good. It has dirt proof meterial. it can be use is the derit."),
                    const SizedBox(height: 90.0,),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      decoration: BoxDecoration(
                        color: const Color(0xfffd6f3e),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: const Center(child: Text("Bye Now", style: TextStyle(color: Colors.white,fontSize: 20.0,fontWeight: FontWeight.bold),)),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
