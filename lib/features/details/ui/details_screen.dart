import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_project/core/helpers/communication_service.dart';
import 'package:final_project/core/helpers/extensions.dart';
import 'package:final_project/core/theming/colors.dart';
import 'package:final_project/core/theming/font_weight_helper.dart';
import 'package:final_project/core/theming/styles.dart';
import 'package:final_project/features/details/logic/details_cubit.dart';
import 'package:final_project/features/home_details/data/models/home_properties_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DetailsScreen extends StatefulWidget {
  Property property;

  DetailsScreen({super.key, required this.property});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 234, 225),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Gap(20),
            SizedBox(
                height: .4.sh,
                child: Stack(
                  children: [
                    PageView.builder(
                      itemCount: widget.property.images!.length,
                      itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.h, horizontal: 16.w),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.r),
                          child: CachedNetworkImage(
                            imageUrl: widget.property.images![index]
                                    .startsWith("http")
                                ? widget.property.images![index]
                                : "https://mazrealty.onrender.com/img/properties/${widget.property.images![index]}",
                            height: .4.sh,
                            width: .9.sw,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      left: 20.w,
                      right: 20.w,
                      top: 16.h,
                      child: Align(
                        alignment: AlignmentDirectional.topCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 36.w,
                              height: 36.h,
                              alignment: Alignment.center,
                              decoration: AppStyles.circleDecoration(
                                  color: Colors.black12),
                              child: IconButton(
                                  onPressed: () {
                                    context.pop();
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back_ios_new_outlined,
                                    color: Colors.white,
                                    size: 14,
                                  )),
                            ),
                            Container(
                                width: 36.w,
                                height: 36.h,
                                alignment: Alignment.center,
                                decoration: AppStyles.circleDecoration(
                                    color: Colors.black12),
                                child: IconButton(
                                    onPressed: () {
                                      if (widget.property.isFavorite!) {
                                        widget.property = widget.property
                                            .copyWith(isFavorite: false);

                                        setState(() {});
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content:
                                              Text("Removed From Favorites"),
                                          backgroundColor: Colors.red,
                                        ));
                                        context
                                            .read<DetailsCubit>()
                                            .makeFavorite(
                                                widget.property.id!, false);
                                      } else {
                                        widget.property = widget.property
                                            .copyWith(isFavorite: true);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text("Added To Favorites"),
                                          backgroundColor: Colors.green,
                                        ));
                                        setState(() {});
                                        context
                                            .read<DetailsCubit>()
                                            .makeFavorite(
                                                widget.property.id!, true);
                                      }
                                    },
                                    icon: Icon(
                                      Icons.bookmark_add_outlined,
                                      color: widget.property.isFavorite ?? false
                                          ? Colors.red
                                          : Colors.white,
                                      size: 14,
                                    ))),
                          ],
                        ),
                      ),
                    ),
                    Positioned.fill(
                      bottom: 80.h,
                      left: 26.w,
                      right: 26.w,
                      child: Align(
                        alignment: AlignmentDirectional.bottomStart,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "${widget.property.name}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17.sp,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              widget.property.address!,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13.sp,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
            Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 16.h, left: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 8.h,
                                width: 8.w,
                                margin: EdgeInsets.symmetric(horizontal: 8.h),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ColorsManager.lightBrown,
                                ),
                              ),
                              SizedBox(width: 20.w),
                              Padding(
                                padding: EdgeInsets.only(bottom: 5.0.h),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.property.owner!.name!,
                                      style: TextStyles.font35BlackBold
                                          .copyWith(
                                              fontWeight:
                                                  FontWeightHelper.medium),
                                    ),
                                    SizedBox(
                                      height: .2.h,
                                    ),
                                    Text("Owner",
                                        style: TextStyles.font29GrayRegular),
                                    SizedBox(height: 8.h),
                                    RatingBar.builder(
                                      initialRating: 3,
                                      minRating: 1,
                                      itemSize: 25,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: ColorsManager.darkBrown,
                                      ),
                                      onRatingUpdate: (rating) {
                                        print(rating);
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                  width: 55.w,
                                  decoration: BoxDecoration(
                                      color: ColorsManager.lighterBlue,
                                      borderRadius:
                                          BorderRadius.circular(10.r)),
                                  child: Center(
                                      child: IconButton(
                                          onPressed: () {
                                            CommunicationService.makePhoneCall(
                                                "+20${widget.property.owner!.phone!}");
                                          },
                                          icon: const Icon(
                                            Icons.phone,
                                            color: Colors.white,
                                          )))),
                              Gap(8.w),
                              Container(
                                  width: 55.w,
                                  decoration: BoxDecoration(
                                      color: ColorsManager.lighterBlue,
                                      borderRadius:
                                          BorderRadius.circular(10.r)),
                                  child: Center(
                                      child: IconButton(
                                          onPressed: () {
                                            CommunicationService.openWhatsAppChat(
                                                "+20${widget.property.owner!.phone!}",
                                                "");
                                          },
                                          icon: const Icon(
                                            Icons.message,
                                            color: Colors.white,
                                          )))),
                              Gap(16.w),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Text(
                        "Description",
                        style: TextStyles.font35BlackBold
                            .copyWith(fontSize: 17.sp),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Text(
                        widget.property.description!,
                        style: TextStyles.font29GrayRegular
                            .copyWith(fontSize: 16.sp),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
