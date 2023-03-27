import 'package:ecom_firebase/const/constants.dart';
import 'package:ecom_firebase/pages/home/components/section_title.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../const/size_config.dart';
import '../../../provider/product_provider.dart';

class PoshProducts extends StatefulWidget {
  const PoshProducts({Key? key}) : super(key: key);

  @override
  State<PoshProducts> createState() => _PoshProductsState();
}

class _PoshProductsState extends State<PoshProducts> {
  late ProductProvider _productProvider;

  @override
  void didChangeDependencies() {
    _productProvider = Provider.of<ProductProvider>(context);
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
            child: SectionTitle(
              title: "Only for posh people",
              press: () {},
            ),
          ),
          SizedBox(height: getProportionateScreenWidth(20)),
          Container(
            height: getProportionateScreenWidth(450),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: _productProvider.alliPhoneProductList.length,
                itemBuilder: (context, index){
                  final product = _productProvider.alliPhoneProductList[index];
                  return Padding(
                    padding: EdgeInsets.only(
                        left: getProportionateScreenWidth(20),
                        right: getProportionateScreenWidth(20),
                        top: getProportionateScreenWidth(20),
                    ),
                    child: GestureDetector(
                      onTap: (){},
                      child: SizedBox(
                        //width: getProportionateScreenWidth(242),
                        height: getProportionateScreenWidth(120),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              fadedImageWidget(product.imageUrl!),
                              SizedBox(width: getProportionateScreenWidth(10),),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('${product.name}',
                                          style: TextStyle(color: kPrimaryColor,
                                              fontSize: getProportionateScreenWidth(15),
                                              fontWeight: FontWeight.w600),),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 20),
                                          child: Icon(Icons.more_horiz_outlined),
                                        )
                                      ],
                                    ),
                                    Container(
                                      width: getProportionateScreenWidth(190),
                                      height: getProportionateScreenHeight(70),
                                      child: Text('${product.description}',
                                        style: TextStyle(color: Colors.grey,
                                            fontSize: getProportionateScreenWidth(12),
                                            fontWeight: FontWeight.w400),
                                      maxLines: 3,),
                                    ),
                                    Padding(
                                      padding:  EdgeInsets.only(
                                        bottom: getProportionateScreenHeight(4),
                                        right: getProportionateScreenWidth(20)
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('\$${product.price}',
                                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15 ),),
                                          Text('ADD',
                                            style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),)
                                        ],
                                      ),
                                    )
                                  ]
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
            ),
          ),
        ],
      ),
    );
  }
  Widget fadedImageWidget(String url){
    return FadeInImage.assetNetwork(
        fadeInDuration: const Duration(seconds: 3),
        fadeInCurve: Curves.bounceInOut,
        fit: BoxFit.cover,
        placeholder: 'assets/images/Image Popular Product 1.png',
        image: url);
  }
}
