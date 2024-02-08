
import 'package:flutter/material.dart';
import 'package:lokale_mand/helper/utils/generalImports.dart';
import 'package:lokale_mand/seller/model/sellerCities.dart';
import 'package:lokale_mand/seller/provider/sellerCategoryProvider.dart';
import 'package:lokale_mand/seller/provider/sellerCityProvider.dart';

class CitiesListScreen extends StatefulWidget {
  const CitiesListScreen({super.key});

  @override
  State<CitiesListScreen> createState() => _CitiesListScreenState();
}

class _CitiesListScreenState extends State<CitiesListScreen> {
  // late ScrollController scrollController = ScrollController()
  //   ..addListener(activeOrdersScrollListener);

//   void activeOrdersScrollListener() {
//     // nextPageTrigger will have a value equivalent to 70% of the list size.
//     var nextPageTrigger = 0.7 * scrollController.position.maxScrollExtent;
//
// // _scrollController fetches the next paginated data when the current position of the user on the screen has surpassed
//     if (scrollController.position.pixels >= nextPageTrigger) {
//       if (mounted) {
//         if (context.read<SellerCitiesListProvider>().hasMoreData) {
//           context.read<SellerCitiesListProvider>().getCities(context: context);
//         }
//       }
//     }
//   }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) =>
        context.read<SellerCitiesListProvider>().getCitiesApiProvider(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        context: context,
        title: CustomTextLabel(
          jsonKey: "countries",
        ),
      ),
      body: Consumer<SellerCitiesListProvider>(
        builder: (context, sellerCitiesListProvider, child) {
          if (sellerCitiesListProvider.sellerCitiesState == SellerCitiesState.loading) {
            return ListView(
              children: List.generate(
                20,
                    (index) => CustomShimmer(
                  height: 60,
                  width: MediaQuery.sizeOf(context).width,
                  borderRadius: 10,
                  margin: EdgeInsets.all(10),
                ),
              ),
            );
          } else if (sellerCitiesListProvider.sellerCitiesState ==
              SellerCitiesState.loaded) {
            return ListView(
              // controller: scrollController,
              children: List.generate(
                sellerCitiesListProvider.cities.length,
                    (index) {
                  SellerCitiesData? sellerCitiesData =
                  sellerCitiesListProvider.cities[index];
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context, sellerCitiesData);
                        },
                        child: Container(
                          height: 60,
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.all(10),
                          width: MediaQuery.sizeOf(context).width,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: ColorsRes.appColor,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: CustomTextLabel(
                              text: "${sellerCitiesData.name}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: ColorsRes.mainTextColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
