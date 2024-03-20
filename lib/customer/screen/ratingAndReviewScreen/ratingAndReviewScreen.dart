import 'package:lokale_mand/customer/models/sellerRating.dart';
import 'package:lokale_mand/customer/provider/ratingProvider.dart';
import 'package:lokale_mand/customer/screen/ratingAndReviewScreen/widget/expandableText.dart';
import 'package:lokale_mand/helper/utils/generalImports.dart';

class RatingAndReviewScreen extends StatefulWidget {
  RatingAndReviewScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<RatingAndReviewScreen> createState() => _RatingAndReviewScreenState();
}

class _RatingAndReviewScreenState extends State<RatingAndReviewScreen> {
  ScrollController scrollController = ScrollController();

  scrollListener() {
    // nextPageTrigger will have a value equivalent to 70% of the list size.
    var nextPageTrigger = 0.7 * scrollController.position.maxScrollExtent;

// _scrollController fetches the next paginated data when the current position of the user on the screen has surpassed
    if (scrollController.position.pixels > nextPageTrigger) {
      if (mounted) {
        if (context.read<RatingListProvider>().hasMoreData) {
          callApi(true);
        }
      }
    }
  }

  Future callApi(bool? resetData) async {
    if (resetData == true) {
      context.read<RatingListProvider>().offset = 0;
      context.read<RatingListProvider>().sellerRatingData = [];
    }
    return context
        .read<RatingListProvider>()
        .getRatingApiProvider(params: {}, context: context);
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      callApi(true);
    });

    scrollController.addListener(scrollListener);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        context: context,
        title: CustomTextLabel(
          jsonKey: "ratings_and_reviews",
          style: TextStyle(
            color: ColorsRes.mainTextColor,
          ),
        ),
        actions: [
          // setCartCounter(context: context),
        ],
      ),
      body: setRefreshIndicator(
        refreshCallback: () {
          return callApi(true);
        },
        child: Consumer<RatingListProvider>(
          builder: (context, ratingListProvider, child) {
            if (ratingListProvider.ratingState == RatingState.loading) {
              return ListView(
                children: [
                  CustomShimmer(
                    width: context.width,
                    height: 180,
                    margin:
                        EdgeInsetsDirectional.only(top: 10, end: 10, start: 10),
                    borderRadius: 10,
                  ),
                  CustomShimmer(
                    width: context.width,
                    height: 120,
                    margin:
                        EdgeInsetsDirectional.only(top: 10, end: 10, start: 10),
                    borderRadius: 10,
                  ),
                  CustomShimmer(
                    width: context.width,
                    height: 120,
                    margin:
                        EdgeInsetsDirectional.only(top: 10, end: 10, start: 10),
                    borderRadius: 10,
                  ),
                  CustomShimmer(
                    width: context.width,
                    height: 120,
                    margin:
                        EdgeInsetsDirectional.only(top: 10, end: 10, start: 10),
                    borderRadius: 10,
                  ),
                  CustomShimmer(
                    width: context.width,
                    height: 120,
                    margin:
                        EdgeInsetsDirectional.only(top: 10, end: 10, start: 10),
                    borderRadius: 10,
                  ),
                  CustomShimmer(
                    width: context.width,
                    height: 120,
                    margin:
                        EdgeInsetsDirectional.only(top: 10, end: 10, start: 10),
                    borderRadius: 10,
                  ),
                  CustomShimmer(
                    width: context.width,
                    height: 120,
                    margin:
                        EdgeInsetsDirectional.only(top: 10, end: 10, start: 10),
                    borderRadius: 10,
                  ),
                  CustomShimmer(
                    width: context.width,
                    height: 120,
                    margin:
                        EdgeInsetsDirectional.only(top: 10, end: 10, start: 10),
                    borderRadius: 10,
                  )
                ],
              );
            } else if (ratingListProvider.ratingState == RatingState.loaded) {
              return ListView(
                shrinkWrap: true,
                controller: scrollController,
                children: List.generate(
                    ratingListProvider.sellerRatingData.length, (index) {
                  SellerRatingData rating =
                      ratingListProvider.sellerRatingData[index];
                  return Card(
                    color: Theme.of(context).cardColor,
                    surfaceTintColor: Theme.of(context).cardColor,
                    margin:
                        EdgeInsetsDirectional.only(top: 10, end: 10, start: 10),
                    child: Padding(
                      padding: EdgeInsetsDirectional.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsetsDirectional.only(
                                  start: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: ColorsRes.appColor,
                                  borderRadius: BorderRadiusDirectional.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    CustomTextLabel(
                                      text: rating.rate,
                                      style: TextStyle(
                                        color: ColorsRes.appColorWhite,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Icon(
                                      Icons.star_rate_rounded,
                                      color: Colors.amber,
                                      size: 20,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(width: 7),
                              CustomTextLabel(
                                text: "rating.?.name.toString()" ?? "",
                                style: TextStyle(
                                    color: ColorsRes.mainTextColor,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15),
                                softWrap: true,
                              )
                            ],
                          ),
                          SizedBox(height: 10),
                          if (rating.review.toString().length > 100)
                            ExpandableText(
                              text: rating.review.toString(),
                              max: 0.2,
                              color: ColorsRes.subTitleMainTextColor,
                            ),
                          if (rating.review.toString().length <= 100)
                            CustomTextLabel(
                              text: rating.review.toString(),
                              style: TextStyle(
                                color: ColorsRes.subTitleMainTextColor,
                              ),
                            ),
                          SizedBox(height: 10),
                          // if (rating.images != null &&
                          //     rating.images!.length > 0)
                          //   LayoutBuilder(
                          //     builder: (context, constraints) => Wrap(
                          //       runSpacing: 10,
                          //       spacing: constraints.maxWidth * 0.017,
                          //       children: List.generate(
                          //         rating.images!.length,
                          //         (index) {
                          //           return GestureDetector(
                          //             onTap: () {
                          //               Navigator.pushNamed(context,
                          //                   fullScreenProductImageScreen,
                          //                   arguments: [
                          //                     index,
                          //                     rating.images
                          //                         ?.map((e) =>
                          //                             e.imageUrl.toString())
                          //                         .toList()
                          //                   ]);
                          //             },
                          //             child: ClipRRect(
                          //               borderRadius: Constant.borderRadius2,
                          //               clipBehavior:
                          //                   Clip.antiAliasWithSaveLayer,
                          //               child: setNetworkImg(
                          //                 image:
                          //                     rating.images?[index].imageUrl ??
                          //                         "",
                          //                 width: 50,
                          //                 height: 50,
                          //                 boxFit: BoxFit.cover,
                          //               ),
                          //             ),
                          //           );
                          //         },
                          //       ),
                          //     ),
                          //   ),
                          SizedBox(height: 10),
                          CustomTextLabel(
                            text: rating.updatedAt.toString().formatDate(),
                            style: TextStyle(
                              color: ColorsRes.subTitleMainTextColor,
                            ),
                            maxLines: 2,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
