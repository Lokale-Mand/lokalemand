import 'package:lokale_mand/helper/utils/generalImports.dart';

getAddressWidget(BuildContext context) {
  return Container(
    decoration: DesignConfig.boxDecoration(Theme.of(context).cardColor, 10),
    padding: const EdgeInsets.all(10),
    margin: EdgeInsetsDirectional.all(
      10,
    ),
    child: Padding(
      padding: EdgeInsets.all(Constant.size10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextLabel(
            jsonKey: "address_detail",
            softWrap: true,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: ColorsRes.mainTextColor,
            ),
          ),
          Widgets.getSizedBox(
            height: Constant.size10,
          ),
          (context.read<CheckoutProvider>().checkoutAddressState ==
                      CheckoutAddressState.addressLoaded &&
                  context.read<CheckoutProvider>().selectedAddress?.id != null)
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          context
                                  .read<CheckoutProvider>()
                                  .selectedAddress
                                  ?.name ??
                              "",
                          softWrap: true,
                          style: TextStyle(
                              color: ColorsRes.mainTextColor,
                              fontWeight: FontWeight.w500),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, addressListScreen,
                                    arguments: "checkout")
                                .then((value) {
                              if (value is AddressData) {
                                AddressData selectedAddress = value;
                                context
                                    .read<CheckoutProvider>()
                                    .setSelectedAddress(
                                        context, selectedAddress);
                              }
                            });
                          },
                          child: Container(
                            height: 25,
                            width: 25,
                            decoration: DesignConfig.boxGradient(5),
                            padding: const EdgeInsets.all(5),
                            margin: EdgeInsets.zero,
                            child: Widgets.defaultImg(
                                image: "edit_icon",
                                iconColor: ColorsRes.mainIconColor,
                                height: 20,
                                width: 20),
                          ),
                        )
                      ],
                    ),
                    Text(
                      "${context.read<CheckoutProvider>().selectedAddress!.area},${context.read<CheckoutProvider>().selectedAddress!.landmark}, ${context.read<CheckoutProvider>().selectedAddress!.address}, ${context.read<CheckoutProvider>().selectedAddress!.state}, ${context.read<CheckoutProvider>().selectedAddress!.city}, ${context.read<CheckoutProvider>().selectedAddress!.country} - ${context.read<CheckoutProvider>().selectedAddress!.pincode} ",
                      softWrap: true,
                      style: TextStyle(color: ColorsRes.subTitleMainTextColor),
                    ),
                    Widgets.getSizedBox(
                      height: Constant.size5,
                    ),
                    Text(
                      context
                              .read<CheckoutProvider>()
                              .selectedAddress
                              ?.mobile ??
                          "",
                      softWrap: true,
                      style: TextStyle(color: ColorsRes.subTitleMainTextColor),
                    ),
                  ],
                )
              : GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, addressListScreen,
                            arguments: "checkout")
                        .then((value) {
                      context
                          .read<CheckoutProvider>()
                          .setSelectedAddress(context, value as AddressData);
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: Constant.size10),
                    child: CustomTextLabel(
                        jsonKey: "add_new_address",
                        softWrap: true,
                        style: TextStyle(
                          color: ColorsRes.appColorRed,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        )),
                  ),
                ),
        ],
      ),
    ),
  );
}
