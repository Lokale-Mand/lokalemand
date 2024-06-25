import 'package:lokale_mand/customer/models/sellerRating.dart';
import 'package:lokale_mand/customer/screen/ratingAndReviewScreen/widget/expandableText.dart';
import 'package:lokale_mand/helper/utils/generalImports.dart';
import 'package:lokale_mand/seller/model/customerRating.dart';
import 'package:lokale_mand/seller/provider/sellerRatingProvider.dart';
import 'package:lokale_mand/seller/screen/sellerRatingAndReviewScreen/widget/sellerSubmitRatingWidget.dart';

class SellerRatingAndReviewScreen extends StatefulWidget {
  var ratings;
  final String customerId;
  final bool eligibleForRating;

  SellerRatingAndReviewScreen({
    Key? key,
    required this.ratings,
    required this.customerId,
    required this.eligibleForRating,
  }) : super(key: key);

  @override
  State<SellerRatingAndReviewScreen> createState() =>
      _RatingAndReviewScreenState();
}

class _RatingAndReviewScreenState extends State<SellerRatingAndReviewScreen> {
  ScrollController scrollController = ScrollController();

  scrollListener() {
    // nextPageTrigger will have a value equivalent to 70% of the list size.
    var nextPageTrigger = 0.7 * scrollController.position.maxScrollExtent;

// _scrollController fetches the next paginated data when the current position of the user on the screen has surpassed
    if (scrollController.position.pixels > nextPageTrigger) {
      if (mounted) {
        if (context.read<SellerRatingListProvider>().hasMoreData) {
          callApi(true);
        }
      }
    }
  }

  Future callApi(bool? resetData) async {
    if (resetData == true) {
      context.read<SellerRatingListProvider>().offset = 0;
      context.read<SellerRatingListProvider>().customerRatingData = [];
    }
    return context.read<SellerRatingListProvider>().getSellerRatingApiProvider(
        params: {ApiAndParams.customerId: widget.customerId}, context: context);
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
        child: Column(
          children: [
            Expanded(
              child: Consumer<SellerRatingListProvider>(
                builder: (context, ratingListProvider, child) {
                  if (ratingListProvider.sellerRatingState ==
                      SellerRatingState.loading) {
                    return ListView(
                      children: [
                        CustomShimmer(
                          width: context.width,
                          height: 180,
                          margin: EdgeInsetsDirectional.only(
                              top: 10, end: 10, start: 10),
                          borderRadius: 10,
                        ),
                        CustomShimmer(
                          width: context.width,
                          height: 120,
                          margin: EdgeInsetsDirectional.only(
                              top: 10, end: 10, start: 10),
                          borderRadius: 10,
                        ),
                        CustomShimmer(
                          width: context.width,
                          height: 120,
                          margin: EdgeInsetsDirectional.only(
                              top: 10, end: 10, start: 10),
                          borderRadius: 10,
                        ),
                        CustomShimmer(
                          width: context.width,
                          height: 120,
                          margin: EdgeInsetsDirectional.only(
                              top: 10, end: 10, start: 10),
                          borderRadius: 10,
                        ),
                        CustomShimmer(
                          width: context.width,
                          height: 120,
                          margin: EdgeInsetsDirectional.only(
                              top: 10, end: 10, start: 10),
                          borderRadius: 10,
                        ),
                        CustomShimmer(
                          width: context.width,
                          height: 120,
                          margin: EdgeInsetsDirectional.only(
                              top: 10, end: 10, start: 10),
                          borderRadius: 10,
                        ),
                        CustomShimmer(
                          width: context.width,
                          height: 120,
                          margin: EdgeInsetsDirectional.only(
                              top: 10, end: 10, start: 10),
                          borderRadius: 10,
                        ),
                        CustomShimmer(
                          width: context.width,
                          height: 120,
                          margin: EdgeInsetsDirectional.only(
                              top: 10, end: 10, start: 10),
                          borderRadius: 10,
                        )
                      ],
                    );
                  } else if (ratingListProvider.sellerRatingState ==
                      SellerRatingState.loaded) {
                    return ListView(
                      shrinkWrap: true,
                      controller: scrollController,
                      children: List.generate(
                          ratingListProvider.customerRatingData.length,
                          (index) {
                        CustomerRatingData rating =
                            ratingListProvider.customerRatingData[index];
                        return Card(
                          color: Theme.of(context).cardColor,
                          surfaceTintColor: Theme.of(context).cardColor,
                          margin: EdgeInsetsDirectional.only(
                              top: 10, end: 10, start: 10),
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
                                        borderRadius:
                                            BorderRadiusDirectional.all(
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
                                      text: rating.user?.name?.toString() ?? "",
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
                                if (rating.images != null &&
                                    rating.images!.length > 0)
                                  LayoutBuilder(
                                    builder: (context, constraints) => Wrap(
                                      runSpacing: 10,
                                      spacing: constraints.maxWidth * 0.017,
                                      children: List.generate(
                                        rating.images!.length,
                                        (index) {
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(context,
                                                  fullScreenProductImageScreen,
                                                  arguments: [
                                                    index,
                                                    rating.images
                                                        ?.map((e) => e.imageUrl
                                                            .toString())
                                                        .toList()
                                                  ]);
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              clipBehavior:
                                                  Clip.antiAliasWithSaveLayer,
                                              child: Widgets.setNetworkImg(
                                                image: rating.images?[index]
                                                        .imageUrl ??
                                                    "",
                                                width: 50,
                                                height: 50,
                                                boxFit: BoxFit.cover,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                SizedBox(height: 10),
                                CustomTextLabel(
                                  text:
                                      rating.updatedAt.toString().formatDate(),
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
                    return DefaultBlankItemMessageScreen(
                      title: "empty_rating_list_message",
                      description: "empty_rating_list_description",
                      image: "empty_ratings",
                    );
                  }
                },
              ),
            ),
            if (widget.eligibleForRating == true)
              Padding(
                padding:
                    EdgeInsetsDirectional.only(start: 10, end: 10, bottom: 20),
                child: Widgets.gradientBtnWidget(
                  context,
                  10,
                  callback: () {
                    return showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      constraints:
                          BoxConstraints(maxHeight: context.height * 0.7),
                      shape: DesignConfig.setRoundedBorderSpecific(20,
                          istop: true),
                      backgroundColor: Theme.of(context).cardColor,
                      builder: (BuildContext context) {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: Container(
                            constraints: BoxConstraints(
                              minHeight: context.height * 0.5,
                            ),
                            padding: EdgeInsetsDirectional.only(
                                start: Constant.size15,
                                end: Constant.size15,
                                top: Constant.size15,
                                bottom: Constant.size15),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () => Navigator.pop(context),
                                        child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Widgets.defaultImg(
                                            image: "ic_arrow_back",
                                            iconColor: ColorsRes.mainTextColor,
                                            height: 15,
                                            width: 15,
                                          ),
                                        ),
                                      ),
                                      CustomTextLabel(
                                        jsonKey: "ratings",
                                        softWrap: true,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .merge(
                                              TextStyle(
                                                letterSpacing: 0.5,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400,
                                                color: ColorsRes.mainTextColor,
                                              ),
                                            ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(10),
                                        child: SizedBox(
                                          height: 15,
                                          width: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: MultiProvider(
                                    providers: [
                                      ChangeNotifierProvider<
                                          SellerRatingListProvider>(
                                        create: (BuildContext context) {
                                          return SellerRatingListProvider();
                                        },
                                      )
                                    ],
                                    child: SellerSubmitRatingWidget(
                                      size: 100,
                                      ratings: widget.ratings,
                                      customerId: widget.customerId,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ).then((value) {
                      if (value != null) {
                        callApi(true);
                      }
                    });
                  },
                  height: 45,
                  title: (widget.ratings is SellerRatingData)
                      ? getTranslatedValue(
                          context,
                          "update_seller_rating",
                        )
                      : getTranslatedValue(
                          context,
                          "add_seller_rating",
                        ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
