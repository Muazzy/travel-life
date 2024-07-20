import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:stacked/stacked.dart';
import 'package:starter_app/generated/assets.dart';
import 'package:starter_app/src/base/enums/event_action.dart';
import 'package:starter_app/src/base/utils/constants.dart';
import 'package:starter_app/src/base/utils/utils.dart';
import 'package:starter_app/src/models/event.dart';
import 'package:starter_app/src/models/ors_models/get_geocode_response_model.dart';
import 'package:starter_app/src/models/waypoint.dart';
import 'package:starter_app/src/shared/custom_app_bar.dart';
import 'package:starter_app/src/shared/custom_bottom_navbar.dart';
import 'package:starter_app/src/shared/custom_datepicker_dialog.dart';
import 'package:starter_app/src/shared/loading_indicator.dart';
import 'package:starter_app/src/shared/main_button.dart';
import 'package:starter_app/src/shared/main_floating_action_button.dart';
import 'package:starter_app/src/shared/regular_textfield.dart';
import 'package:starter_app/src/shared/spacing.dart';
import 'package:starter_app/src/shared/vehicle_registration_field.dart';
import 'package:starter_app/src/shared/vehicle_registration_select_widget.dart';
import 'package:starter_app/src/shared/vehicle_registration_textfield.dart';
import 'package:starter_app/src/styles/app_colors.dart';
import 'package:starter_app/src/styles/text_theme.dart';
import 'package:starter_app/src/views/bottomsheets/add_waypoint_bottomsheet/add_waypoint_bottomsheet_view.dart';
import 'package:starter_app/src/views/bottomsheets/places_bottomsheet/places_bottomsheet_view.dart';
import 'package:starter_app/src/views/events/event_detail/event_detail_view_model.dart';

class EventDetailView extends StackedView<EventDetailViewModel> {
  final Event event;
  EventDetailView({
    required this.event,
  });

  final String dummyText = '----';

  @override
  Widget builder(
    BuildContext context,
    EventDetailViewModel model,
    Widget? child,
  ) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        // bottomNavigationBar: Padding(
        //   padding: EdgeInsets.symmetric(
        //     horizontal: 27.w,
        //     vertical: 10.h,
        //   ),
        //   child: MainButton(
        //     buttonText: action == EventAction.add ? 'Create Trip' : 'Save',
        //     onPressed: model.updateOrInsertEvent,
        //     isLoading: model.isBusy,
        //   ),
        // ),

        bottomNavigationBar: CustomBottomNavbar(
          onChange: (value) {
            model.onChangeBottomNavIndex(value);
          },
          selectedIndex: model.selectedBottomNavIndex,
          vehicleRegistrationNav: false,
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // floatingActionButton: MainFloatingActionButton(
        //   onTap: () {},
        //   heightAndWidth: 65.w,
        // ),
        backgroundColor: model.selectedBottomNavIndex == 2
            ? Colors.amber.shade50
            : AppColors.appFaddedBlue,
        body: Container(
          width: context.screenSize().width,
          height: context.screenSize().height,
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     image: Image.asset(
          //       AssetImages.vehicleRegistrationBg,
          //       height: context.screenSize().height,
          //       width: context.screenSize().width,
          //     ).image,
          //     fit: BoxFit.cover,
          //     opacity: 0.7,
          //   ),
          // ),
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          child: Stack(
            children: [
              if (model.selectedBottomNavIndex != 2) ...[
                SizedBox(
                  height: context.screenSize().height * 0.4,
                  child: FlutterMap(
                    mapController: model.mapController,
                    options: MapOptions(
                      zoom: 12,
                      center: model.destination,
                      onTap: (tapPosition, latLng) {
                        model.onTapMap(latLng);
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return AddWaypointDialog(model: model);
                          },
                        );
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                        userAgentPackageName:
                            'dev.fleaflet.flutter_map.example',
                      ),
                      MarkerLayer(
                        markers: model.markers,
                      ),
                      PolylineLayer(
                        polylineCulling: false,
                        polylines: [
                          Polyline(
                            points: [
                              model.destination,
                              ...model.waypoints
                                  .map((e) => LatLng(e.lat, e.long))
                                  .toList(),
                            ],
                            color: AppColors.appSkyBlue,
                            strokeWidth: 2,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    height: context.screenSize().height * 0.65,
                    width: context.screenSize().width,
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.appFaddedBlue,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.r),
                        topRight: Radius.circular(30.r),
                      ),
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned.fill(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              VerticalSpacing(
                                context.screenSize().height * 0.14,
                              ),
                              Expanded(
                                child: ListView.separated(
                                  itemBuilder: (context, index) {
                                    final wp = model.waypoints[index];
                                    return WaypointInfoCard(
                                      waypoint: wp,
                                      dummyText: dummyText,
                                    );
                                  },
                                  padding: EdgeInsets.symmetric(vertical: 20.h),
                                  shrinkWrap: true,
                                  itemCount: model.waypoints.length,
                                  separatorBuilder: (context, index) {
                                    print(
                                        'seprator builder index is: ${index}');
                                    return WayPointSeprator(
                                      distance: '2403 M',
                                    );
                                  },
                                ),
                              ),
                              VerticalSpacing(5.h),
                              Align(
                                alignment: Alignment.centerRight,
                                child: MainFloatingActionButton(
                                  onTap: () async {
                                    final Waypoint? _data =
                                        await showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return AddWaypointBottomSheetView();
                                      },
                                    );

                                    print('data iss ijj : ${_data}');
                                    if (_data != null) {
                                      print('hello adding waypoint');
                                      final point = _data.copyWith(
                                        addedBy: model.supabaseAuthService.user,
                                        event: model.event.id,
                                      );
                                      final bool added =
                                          await model.addWaypoint(point);
                                      print('did add waypoint : ${added}');

                                      if (!added) {
                                        print('did not add waypoint');
                                        Constants.customWarningSnack(
                                            'could not add waypoint');
                                      }
                                    }
                                  },
                                  heightAndWidth: 35.w,
                                  iconSize: 25.w,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: -context.screenSize().height * 0.05,
                          // height: 100.h,
                          width: context.screenSize().width,
                          left: -8.w, //TODO: maybe remove this.
                          child:
                              EventInfoCard(event: event, dummyText: dummyText),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              if (model.selectedBottomNavIndex == 2) ...[
                // EventDetailMap(event: event),
                Stack(
                  children: [
                    Positioned.fill(
                      child: FlutterMap(
                        mapController: model.mapController,
                        options: MapOptions(
                          zoom: 15,
                          center: model.destination,
                          onTap: (tapPosition, latLng) {
                            model.onTapMap(latLng);
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return AddWaypointDialog(model: model);
                              },
                            );
                          },
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                            userAgentPackageName:
                                'dev.fleaflet.flutter_map.example',
                          ),
                          MarkerLayer(
                            markers: model.markers,
                          ),
                          PolylineLayer(
                            polylineCulling: true,
                            polylines: [
                              Polyline(
                                points: [
                                  model.destination,
                                  ...model.waypoints
                                      .map((e) => LatLng(e.lat, e.long))
                                      .toList(),
                                ],
                                color: AppColors.appSkyBlue,
                                strokeWidth: 2,
                              ),
                              if (model.selectedRoute != -1)
                                Polyline(
                                  points: model.polypoints,
                                  color: AppColors.purple,
                                  strokeWidth: 5.w,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 100.h,
                      right: 24.w,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.appFaddedBlue,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 5.h,
                        ),
                        child: Text(
                          'Total routes found: ${model.routeResponse?.routes?.length ?? 0}',
                          style: TextStyling.semiBold.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 100.h,
                      left: 24.w,
                      child: GestureDetector(
                        onTap: model.changeRoute,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.appFaddedBlue,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 5.h,
                          ),
                          child: Text(
                            'Change route',
                            style: TextStyling.semiBold.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              //AppBar
              Positioned(
                top: 0,
                width: context.screenSize().width,
                child: Container(
                  child: CustomAppBar(
                    padding: EdgeInsets.only(
                      top: 50.h,
                      left: 27.w,
                      right: 27.w,
                      bottom: 0.h,
                    ),
                    titleText: 'Event Detail',
                    titleTextStyle: TextStyling.semiBold.copyWith(
                      color: AppColors.appFaddedBlue,
                      fontSize: 17.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  EventDetailViewModel viewModelBuilder(BuildContext context) =>
      EventDetailViewModel();

  @override
  void onViewModelReady(EventDetailViewModel model) => model.init(event);
}

class WayPointSeprator extends StatelessWidget {
  const WayPointSeprator({
    Key? key,
    required this.distance,
  }) : super(key: key);

  final String distance;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VerticalSpacing(10.h),
        Row(
          children: [
            Expanded(
              child: Divider(
                height: 0,
                color: AppColors.appSkyBlue,
                thickness: 1,
              ),
            ),
            Row(
              children: [
                HorizontalSpacing(5.w),
                SvgPicture.asset(
                  AssetIcons.distanceIcon,
                  height: 25.w,
                ),
                HorizontalSpacing(5.w),
                Text(
                  distance,
                  style: TextStyling.thin.copyWith(
                    color: AppColors.white,
                    fontSize: 13.sp,
                  ),
                ),
                HorizontalSpacing(5.w),
              ],
            ),
            Expanded(
              child: Divider(
                height: 0,
                color: AppColors.appSkyBlue,
                thickness: 1,
              ),
            ),
          ],
        ),
        VerticalSpacing(10.h),
      ],
    );
  }
}

class EventInfoCard extends StatelessWidget {
  const EventInfoCard({
    Key? key,
    required this.event,
    required this.dummyText,
  }) : super(key: key);

  final Event event;
  final String dummyText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 27.w,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: AppColors.eventDetailCardGradient,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 8.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            event.name ?? '',
            style: TextStyling.bold.copyWith(
              fontSize: 16.sp,
            ),
          ),
          VerticalSpacing(10.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  event.destination ?? '',
                  style: TextStyling.thin.copyWith(
                    fontSize: 13.sp,
                  ),
                  // overflow: TextOverflow.ellipsis,
                ),
              ),
              HorizontalSpacing(10.w),
              Text(
                '${event.startTime != null ? DateFormat('dd MMM').format(event.startTime!) : dummyText} - ${event.endTime != null ? DateFormat('dd MMM').format(event.endTime!) : dummyText} (${event.noOfDays ?? dummyText} days)',
                style: TextStyling.bold.copyWith(fontSize: 13.sp),
              ),
            ],
          ),
          VerticalSpacing(5.h),
          Divider(
            // height: 1,
            color: AppColors.black,
            thickness: 0.5,
          ),
          VerticalSpacing(5.h),
          Text(
            'Total Days Planned:',
            style: TextStyling.bold.copyWith(
              fontSize: 13.sp,
            ),
          ),
          VerticalSpacing(10.h),
          LinearProgressIndicator(
            borderRadius: BorderRadius.circular(30.r),
            value: 0.5,
            minHeight: 10.h,
            backgroundColor: AppColors.appTextfieldBorderColor,
            valueColor: AlwaysStoppedAnimation<Color>(
              AppColors.appSkyBlue,
            ),
          ),
          VerticalSpacing(0.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '0',
                style: TextStyling.thin.copyWith(
                  fontSize: 13.sp,
                ),
              ),
              Text(
                '${event.noOfDays ?? 0}',
                style: TextStyling.thin.copyWith(
                  fontSize: 13.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WaypointInfoCard extends StatelessWidget {
  const WaypointInfoCard({
    Key? key,
    required this.waypoint,
    required this.dummyText,
  }) : super(key: key);

  final Waypoint waypoint;
  final String dummyText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 27.w,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: AppColors.eventDetailCardGradient,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 8.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 5.h,
            ),
            decoration: BoxDecoration(
              gradient: AppColors.mainButtonGradient,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Text(
              waypoint.label ?? '',
              style: TextStyling.bold.copyWith(
                fontSize: 16.sp,
              ),
            ),
          ),
          VerticalSpacing(10.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Expanded(
              //   child: Text(
              //     waypoint.label ?? '',
              //     style: TextStyling.thin.copyWith(
              //       fontSize: 13.sp,
              //     ),
              //     // overflow: TextOverflow.ellipsis,
              //   ),
              // ),
              // HorizontalSpacing(10.w),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Text(
                    '${waypoint.startTime != null ? DateFormat('dd MMM').format(waypoint.startTime!) : dummyText} - ${waypoint.endTime != null ? DateFormat('dd MMM').format(waypoint.endTime!) : dummyText} (${waypoint.noOfDays ?? dummyText} days)',
                    style: TextStyling.thin.copyWith(fontSize: 13.sp),
                  ),
                ),
              ),
            ],
          ),
          // VerticalSpacing(5.h),
          // Divider(
          //   // height: 1,
          //   color: AppColors.black,
          //   thickness: 0.5,
          // ),
          // VerticalSpacing(5.h),
          // Text(
          //   'Total Days Planned:',
          //   style: TextStyling.bold.copyWith(
          //     fontSize: 13.sp,
          //   ),
          // ),
          // VerticalSpacing(10.h),
          // LinearProgressIndicator(
          //   borderRadius: BorderRadius.circular(30.r),
          //   value: 0.5,
          //   minHeight: 10.h,
          //   backgroundColor: AppColors.appTextfieldBorderColor,
          //   valueColor: AlwaysStoppedAnimation<Color>(
          //     AppColors.appSkyBlue,
          //   ),
          // ),
          // VerticalSpacing(0.h),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       '0',
          //       style: TextStyling.thin.copyWith(
          //         fontSize: 13.sp,
          //       ),
          //     ),
          //     Text(
          //       '${waypoint.noOfDays ?? 0}',
          //       style: TextStyling.thin.copyWith(
          //         fontSize: 13.sp,
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}

class AddWaypointDialog extends StatelessWidget {
  const AddWaypointDialog({
    Key? key,
    required this.model,
  }) : super(key: key);

  final EventDetailViewModel model;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Features?>(
      valueListenable: model.selectedPlace,
      builder: (context, value, _) {
        return AlertDialog(
          backgroundColor: AppColors.appDarkBlue,
          insetPadding: EdgeInsets.only(left: 10.0, right: 10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0.r),
          ),
          title: Text(
            'Add Waypoint',
            textAlign: TextAlign.center,
            style: TextStyling.medium.copyWith(
              fontSize: 16.sp,
            ),
          ),
          content: Text(
            'Add ${value?.properties?.label ?? '----'} as waypoint?',
            style: TextStyling.thin.copyWith(fontSize: 12.sp),
            textAlign: TextAlign.center,
          ),
          actions: [
            ValueListenableBuilder<bool>(
                valueListenable: model.placeLoading,
                builder: (context, isLoading, _) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: isLoading
                        ? [
                            Center(
                              child: LoadingIndicator(),
                            ),
                          ]
                        : [
                            Container(
                              height: 40.0.h,
                              width: 70.0.w,
                              child: MainButton(
                                isLoading: model.isBusy,
                                buttonText: 'Yes',
                                onPressed: () async {
                                  if (model.placeLoading.value) {
                                    return;
                                  }
                                  final shouldPop =
                                      await model.addWaypoint(Waypoint(
                                    addedBy: model.supabaseAuthService.user,
                                    noOfDays: 1,
                                    startTime: DateTime.now(),
                                    endTime: DateTime.now()
                                        .add(const Duration(days: 1)),
                                    event: model.event.id,
                                    lat: model.selectedPlace.value?.geometry
                                            ?.coordinates?.last ??
                                        0,
                                    long: model.selectedPlace.value?.geometry
                                            ?.coordinates?.first ??
                                        0,
                                    label: model.selectedPlace.value?.properties
                                            ?.label ??
                                        '',
                                  ));
                                  if (shouldPop) {
                                    print(shouldPop);
                                    Navigator.pop(context);
                                  }
                                },
                                padding: EdgeInsets.zero,
                              ),
                            ),
                            HorizontalSpacing(15.w),
                            GestureDetector(
                              onTap: () {
                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                              },
                              child: Container(
                                height: 40.0.h,
                                width: 70.0.w,
                                decoration: BoxDecoration(
                                  color: AppColors.appFaddedBlue,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Center(
                                  child: Text(
                                    "No",
                                    style: TextStyling.regular.copyWith(
                                      fontSize: 12.sp,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                  );
                }),
            VerticalSpacing(10),
          ],
        );
      },
    );
  }
}
