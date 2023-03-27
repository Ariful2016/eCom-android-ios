import 'package:ecom_firebase/const/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../const/enums.dart';
import '../../const/size_config.dart';
import '../../provider/product_provider.dart';
import '../../widgets/coustom_bottom_nav_bar.dart';
import '../home/components/popular_product.dart';
import '../home/components/posh_products.dart';

class NotificationPage extends StatefulWidget {
  static const String routeName = 'notification_page';

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> with TickerProviderStateMixin{

  late ProductProvider _productProvider;

  @override
  void didChangeDependencies() {
    _productProvider = Provider.of<ProductProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    TabController _tabController =
    TabController(length: 2, vsync: this);
    return Scaffold(
      appBar: AppBar(title: Text('Notifications'),),
      body: Column(
          children: [
            Container(
              child: TabBar(
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                controller: _tabController,
                indicatorColor: kPrimaryColor,
                tabs: [
                  Tab(text: 'Popular Products',),
                  Tab(text: 'Recommanded',),
                  //Tab(icon: SvgPicture.asset('assets/icons/Call.svg'),)
                ],
              ),
            ),
            Container(
              width: double.maxFinite,
              height: getProportionateScreenHeight(650),
              child: TabBarView(
                controller: _tabController,
                children: [
                  SafeArea(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: getProportionateScreenWidth(30)),
                            PopularProducts(),
                            SizedBox(height: getProportionateScreenWidth(30)),
                            PoshProducts(),
                            SizedBox(height: getProportionateScreenWidth(30)),
                          ],
                        ),
                      )),
                  Text('card'),
                ],
              ),
            )

          ],

      ),
      bottomNavigationBar: const CustomBottomNavBar(selectedMenu: MenuState.home,),
    );
  }
}
