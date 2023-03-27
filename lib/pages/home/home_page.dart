import 'package:ecom_firebase/const/enums.dart';
import 'package:ecom_firebase/models/ProductModel.dart';
import 'package:ecom_firebase/pages/home/components/body.dart';
import 'package:ecom_firebase/provider/product_provider.dart';
import 'package:ecom_firebase/widgets/coustom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:ecom_firebase/const/size_config.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

import '../../const/constants.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home_page';


  @override
  State<HomePage> createState() => _HomePageState();
}



class _HomePageState extends State<HomePage> {
  late ProductProvider _productProvider;

  @override
  void didChangeDependencies() {
    _productProvider = Provider.of<ProductProvider>(context, listen: false);
    _productProvider.getAllCategories();
    _productProvider.getAllProducts();
    _productProvider.getAllMacProducts();
    _productProvider.getAllOtherProducts();
    _productProvider.getAlliPhoneProducts();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Body(),
      bottomNavigationBar: const CustomBottomNavBar(selectedMenu: MenuState.home,),
    );
  }
}
