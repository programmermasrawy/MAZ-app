import 'package:final_project/core/di/dependencey_injection.dart';
import 'package:final_project/core/theming/colors.dart';
import 'package:final_project/core/theming/styles.dart';
import 'package:final_project/features/cities/ui/cities_widget.dart';
import 'package:final_project/features/home_details/data/models/home_properties_response.dart';
import 'package:final_project/features/home_details/logic/home_cubit.dart';
import 'package:final_project/features/home_details/logic/home_state.dart';
import 'package:final_project/features/search/ui/search_posts.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:string_similarity/string_similarity.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeCubit>(),
      child: const _Body(),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body();

  @override
  State<_Body> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<_Body> {
  TextEditingController searchTextController = TextEditingController();
  bool showFilters = false;

  String hintText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 234, 225),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 234, 225),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 18.0.h, right: 18.h),
              child: TextFormField(
                onChanged: (value) {
                  //filter by price and location and and
                  searchTextController.text = value;
                },
                controller: searchTextController,
                decoration: InputDecoration(
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 9.h),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: ColorsManager.green, width: 1.3.w),
                        borderRadius: BorderRadius.circular(45.r)),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: ColorsManager.gray, width: 1.3.w),
                        borderRadius: BorderRadius.circular(35.r)),
                    hintText: "Search...",
                    helperStyle: TextStyles.font25DarkGrayRegular,
                    suffixIcon: searchTextController.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              // searchTextController.clear();
                              for (var city in AppCities) {
                                if (kDebugMode) {
                                  print(city.nameEn!
                                    .similarityTo(searchTextController.text));
                                }
                                if (kDebugMode) {
                                  print(city.nameAr!
                                    .similarityTo(searchTextController.text));
                                }
                                if (city.nameEn!.similarityTo(
                                        searchTextController.text) >=
                                    .3) {
                                  searchTextController.text = city.nameEn!;
                                  context
                                      .read<HomeCubit>()
                                      .getAllPosts(1, cityId: city.id);
                                  hintText = "you mean ${city.nameEn}";
                                  setState(() {});
                                } else if (city.nameAr!.similarityTo(
                                        searchTextController.text) >=
                                    .3) {
                                  searchTextController.text = city.nameAr!;
                                  context
                                      .read<HomeCubit>()
                                      .getAllPosts(1, cityId: city.id);
                                  hintText = "you mean ${city.nameAr}";
                                  setState(() {});
                                }
                              }
                            },
                            icon: const Icon(
                              Icons.search,
                              size: 21,
                              color: ColorsManager.gray,
                            ))
                        : null),
              ),
            ),
            Text(hintText),
            Padding(
              padding: EdgeInsets.only(left: 15.0.h, top: 10.h, right: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Filter By",
                    style: TextStyles.font35BlackBold,
                  ),
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35.r),
                          color: ColorsManager.green.withOpacity(0.5)),
                      child: IconButton(
                          onPressed: () {
                            setState(() {
                              showFilters = !showFilters;
                            });
                          },
                          icon: const Icon(
                            IconlyBold.filter,
                            size: 20,
                          )))
                ],
              ),
            ),
            Visibility(
              visible: showFilters,
              child: CitiesWidget(
                onCitySelected: (cityId) {
                  context.read<HomeCubit>().getAllPosts(1, cityId: cityId);
                },
              ),
            ),
            BlocConsumer<HomeCubit, HomeState>(
                listener: (BuildContext context, state) {},
                builder: (context, state) {
                  return state.when(
                    initial: () => const SizedBox.shrink(),
                    loading: () => const CircularProgressIndicator(),
                    success: (data) {
                      return SearchPosts(
                        properties:
                            (data as HomePropertiesResponse).data!.properties ??
                                [],
                      );
                    },
                    error: (e) => Center(
                      child: Text(e),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
