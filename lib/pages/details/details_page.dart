import 'package:ecom_firebase/const/constants.dart';
import 'package:ecom_firebase/const/size_config.dart';
import 'package:ecom_firebase/models/ProductModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../models/Product.dart';
import '../../widgets/default_button.dart';


class DetailsPage extends StatefulWidget {
  static const String routeName = "/details_page";


  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    final product =
    ModalRoute.of(context)!.settings.arguments as ProductModel;
    return Scaffold(
      appBar: AppBar(title: Text('Products Details'),),
      body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: double.maxFinite,
                height: getProportionateScreenHeight(300),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Hero(
                    tag: '',
                    child: Image.network('${product.imageUrl}'),
                  ),
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(20),),
              Container(
                width: double.maxFinite,
                height: getProportionateScreenHeight(580),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30.0),
                      topLeft: Radius.circular(30.0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: getProportionateScreenHeight(10), left: getProportionateScreenWidth(20)),
                      child: Text('${product.name}',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text('${product.description}'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: getProportionateScreenHeight(10), left: getProportionateScreenWidth(20),right: getProportionateScreenWidth(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "\$${product.price}",
                            style: TextStyle(
                              fontSize: getProportionateScreenWidth(25),
                              fontWeight: FontWeight.w600,
                              color: kPrimaryColor,
                            ),
                          ),
                          InkWell(
                            borderRadius: BorderRadius.circular(70),
                            onTap: () {},
                            child: Container(
                              padding: EdgeInsets.all(getProportionateScreenWidth(8)),
                              height: getProportionateScreenWidth(38),
                              width: getProportionateScreenWidth(38),
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
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(
                            getProportionateScreenWidth(80),
                            getProportionateScreenHeight(80),
                            getProportionateScreenWidth(80),
                            getProportionateScreenHeight(20)),
                      child: DefaultButton(
                        text: "Add to Cart",
                        press: () {

                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      //),
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


/*class DetailsPage extends StatefulWidget {
  static const String routeName = "/details_page";

  @override
  Widget build(BuildContext context) {
    final ProductDetailsArguments agrs =
        ModalRoute.of(context)!.settings.arguments as ProductDetailsArguments;
    return Scaffold(
      backgroundColor: Color(0xFFF5F6F9),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppBar().preferredSize.height),
        child: CustomAppBar(rating: agrs.product.rating),
      ),
      body: Body(product: agrs.product),
    );
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}*/

class ProductDetailsArguments {
  final Product product;
  ProductDetailsArguments({required this.product});
}
