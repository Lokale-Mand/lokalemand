import 'package:lokale_mand/helper/utils/generalImports.dart';

class BrandListScreen extends StatefulWidget {
  const BrandListScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<BrandListScreen> createState() => _BrandListScreenState();
}

class _BrandListScreenState extends State<BrandListScreen> {
  @override
  void initState() {
    super.initState();
    //fetch brand List from api
    Future.delayed(Duration.zero).then((value) {
      context
          .read<BrandListProvider>()
          .getBrandApiProvider(context: context, params: {});
    });
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        context: context,
        title: CustomTextLabel(
          jsonKey: "brands",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: ColorsRes.mainTextColor,
          ),
        ),
        actions: [
          setCartCounter(context: context),
        ],
      ),
      body: setRefreshIndicator(
        refreshCallback: () {
          return context
              .read<BrandListProvider>()
              .getBrandApiProvider(context: context, params: {});
        },
        child: ListView(children: [
          brandWidget(),
        ]),
      ),
    );
  }

//brandList ui
  Widget brandWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Consumer<BrandListProvider>(
          builder: (context, brandListProvider, _) {
            if (brandListProvider.brandState == BrandState.loaded) {
              return Card(
                color: Theme.of(context).cardColor,
                elevation: 0,
                margin: EdgeInsets.symmetric(
                    horizontal: Constant.size10, vertical: Constant.size10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GridView.builder(
                      itemCount: brandListProvider.brands.length,
                      padding: EdgeInsets.symmetric(
                          horizontal: Constant.size10,
                          vertical: Constant.size10),
                      shrinkWrap: true,
                      physics: ScrollPhysics(parent: BouncingScrollPhysics()),
                      itemBuilder: (BuildContext context, int index) {
                        Brand brand = brandListProvider.brands[index];

                        return BrandItemContainer(
                          brand: brand,
                          voidCallBack: () {
                            Navigator.pushNamed(
                              context,
                              productListScreen,
                              arguments: [
                                "brand",
                                brand.id.toString(),
                                brand.name,
                                null,
                              ],
                            );
                          },
                        );
                      },
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 0.8,
                              crossAxisCount: 3,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10),
                    ),
                  ],
                ),
              );
            } else if (brandListProvider.brandState == BrandState.loading) {
              return getBrandShimmer(context: context, count: 9);
            } else {
              return NoInternetConnectionScreen(
                height: MediaQuery.sizeOf(context).height * 0.65,
                message: brandListProvider.message,
                callback: () {
                  context
                      .read<BrandListProvider>()
                      .getBrandApiProvider(context: context, params: {});
                },
              );
            }
          },
        ),
      ],
    );
  }
}
