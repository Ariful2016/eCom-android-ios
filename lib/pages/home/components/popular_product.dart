import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../const/constants.dart';
import '../../../const/size_config.dart';
import '../../../models/Product.dart';
import '../../../provider/product_provider.dart';
import '../../../widgets/product_card.dart';
import '../../details/details_page.dart';
import 'section_title.dart';

class PopularProducts extends StatefulWidget {
  const PopularProducts({Key? key}) : super(key: key);

  @override
  State<PopularProducts> createState() => _PopularProductsState();
}

class _PopularProductsState extends State<PopularProducts> {
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
            title: "Popular products",
            press: () {},
          ),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        Container(
          height: getProportionateScreenWidth(200),
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: _productProvider.allOthersProductList.length,
              itemBuilder: (context, index){
                final product = _productProvider.allOthersProductList[index];
                return Padding(
                  padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
                  child: SizedBox(
                    width: getProportionateScreenWidth(140),
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsPage(),
                          settings: RouteSettings(arguments: product,),)
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AspectRatio(
                            aspectRatio: 1.02,
                            child: Container(
                              padding: EdgeInsets.all(getProportionateScreenWidth(20)),
                              decoration: BoxDecoration(
                                color: kSecondaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Hero(
                                tag: product.id.toString(),
                                child: fadedImageWidget(product.imageUrl!),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            product.name!,
                            style: TextStyle(color: Colors.black),
                            maxLines: 2,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "\$${product.price}",
                                style: TextStyle(
                                  fontSize: getProportionateScreenWidth(18),
                                  fontWeight: FontWeight.w600,
                                  color: kPrimaryColor,
                                ),
                              ),
                              InkWell(
                                borderRadius: BorderRadius.circular(50),
                                onTap: () {},
                                child: Container(
                                  padding: EdgeInsets.all(getProportionateScreenWidth(8)),
                                  height: getProportionateScreenWidth(28),
                                  width: getProportionateScreenWidth(28),
                                  decoration: BoxDecoration(
                                    color: product.isAvailable
                                        ? kPrimaryColor.withOpacity(0.15)
                                        : kSecondaryColor.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: SvgPicture.asset(
                                    "assets/icons/Heart Icon_2.svg",
                                    color: product.isAvailable
                                        ? Color(0xFFFF4848)
                                        : Color(0xFFDBDEE4),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
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



