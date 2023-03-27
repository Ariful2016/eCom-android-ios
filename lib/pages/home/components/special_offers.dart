import 'package:ecom_firebase/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../const/size_config.dart';
import 'section_title.dart';

class SpecialOffers extends StatefulWidget {
  const SpecialOffers({Key? key}) : super(key: key);

  @override
  State<SpecialOffers> createState() => _SpecialOffersState();
}

class _SpecialOffersState extends State<SpecialOffers> {
  late ProductProvider _productProvider;

  @override
  void didChangeDependencies() {
    _productProvider = Provider.of<ProductProvider>(context);
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SectionTitle(
            title: "Special for you",
            press: () {},
          ),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        Container(
          height: getProportionateScreenWidth(100),
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: _productProvider.allProductList.length,
              itemBuilder: (context, index){
                final product = _productProvider.allProductList[index];
                return Padding(
                  padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
                  child: GestureDetector(
                    onTap: (){},
                    child: SizedBox(
                      width: getProportionateScreenWidth(242),
                      height: getProportionateScreenWidth(100),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          children: [
                            fadedImageWidget(product.imageUrl!),
                            Container(
                              width: getProportionateScreenWidth(242),
                              height: getProportionateScreenWidth(100),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xFF343434).withOpacity(0.4),
                                    Color(0xFF343434).withOpacity(0.15),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: getProportionateScreenWidth(15.0),
                                vertical: getProportionateScreenWidth(10),
                              ),
                              child: Text.rich(
                                TextSpan(
                                  style: TextStyle(color: Colors.white),
                                  children: [
                                    TextSpan(
                                      text: "${product.category}",
                                      style: TextStyle(
                                        fontSize: getProportionateScreenWidth(18),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(text: "15 Brands")
                                  ],
                                ),
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





