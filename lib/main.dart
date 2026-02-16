import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quickseatreservation/app/constants/AppTexts.dart';
import 'package:quickseatreservation/app/theme/themController.dart';
import 'package:quickseatreservation/app/theme/theme.dart';
import 'package:quickseatreservation/bootstrap.dart';
import 'package:quickseatreservation/core/controllers/ImageCotroller.dart';
import 'package:quickseatreservation/features/mainHome/viewModel/mainHomeViewModel.dart';
import 'package:quickseatreservation/features/auth/data/datasources/auth_remote_data_source.dart';

import 'package:quickseatreservation/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:quickseatreservation/features/auth/domain/usecases/login_usecase.dart';
import 'package:quickseatreservation/features/auth/viewModel/auth_view_model.dart';
import 'package:quickseatreservation/features/layouts/data/datasources/layout_remote_data_source.dart';
import 'package:quickseatreservation/features/layouts/data/repositories/layout_repository_impl.dart';
import 'package:quickseatreservation/features/layouts/domain/usecases/create_table_usecase.dart';
import 'package:quickseatreservation/features/layouts/domain/usecases/create_time_slot_usecase.dart';
import 'package:quickseatreservation/features/layouts/domain/usecases/get_tables_usecase.dart';
import 'package:quickseatreservation/features/layouts/domain/usecases/get_time_slots_usecase.dart';
import 'package:quickseatreservation/features/layouts/domain/usecases/update_time_slot_usecase.dart';
import 'package:quickseatreservation/features/layouts/viewModels/layout_view_model.dart';
import 'package:quickseatreservation/features/bookTable/data/datasources/booking_remote_data_source_impl.dart';
import 'package:quickseatreservation/features/bookTable/data/repositories/booking_repository_impl.dart';
import 'package:quickseatreservation/features/bookTable/domain/repositories/booking_repository.dart';
import 'package:quickseatreservation/features/bookTable/domain/usecases/create_booking_usecase.dart';
import 'package:quickseatreservation/features/bookTable/domain/usecases/get_all_bookings_usecase.dart';
import 'package:quickseatreservation/features/bookTable/domain/usecases/get_available_tables_usecase.dart';
import 'package:quickseatreservation/features/bookTable/domain/usecases/update_booking_status_usecase.dart';
import 'package:quickseatreservation/features/bookTable/viewModels/booking_view_model.dart';

import 'app/routes/AppGoRouter.dart';

void main() async {
  await bootstrap();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ImageController>(
          create: (_) => ImageController(),
        ),
        ChangeNotifierProvider<ThemeController>(
          create: (_) => ThemeController(),
        ),
        ChangeNotifierProvider<MainHomeViewModel>(
          create: (_) => MainHomeViewModel(),
        ),
        ChangeNotifierProvider<AuthViewModel>(
          create: (_) => AuthViewModel(
            loginUseCase: LoginUseCase(
              AuthRepositoryImpl(remoteDataSource: AuthRemoteDataSourceImpl()),
            ),
          ),
        ),
        ChangeNotifierProvider<LayoutViewModel>(
          create: (_) {
            final repository = LayoutRepositoryImpl(
              remoteDataSource: LayoutRemoteDataSourceImpl(),
            );
            return LayoutViewModel(
              createTableUseCase: CreateTableUseCase(repository),
              createTimeSlotUseCase: CreateTimeSlotUseCase(repository),
              updateTimeSlotUseCase: UpdateTimeSlotUseCase(repository),
              getTablesUseCase: GetTablesUseCase(repository),
              getTimeSlotsUseCase: GetTimeSlotsUseCase(repository),
            );
          },
        ),
        ChangeNotifierProvider<BookingViewModel>(
          create: (_) {
            final layoutDS = LayoutRemoteDataSourceImpl();
            final bookingDS = BookingRemoteDataSourceImpl();
            final BookingRepository repository = BookingRepositoryImpl(
              bookingRemoteDataSource: bookingDS,
              layoutRemoteDataSource: layoutDS,
            );
            return BookingViewModel(
              getAvailableTablesUseCase: GetAvailableTablesUseCase(repository),
              createBookingUseCase: CreateBookingUseCase(repository),
              getAllBookingsUseCase: FetchBookingsUseCase(repository),
              updateBookingStatusUseCase: UpdateBookingStatusUseCase(
                repository,
              ),
            );
          },
        ),
      ],

      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return Consumer<ThemeController>(
            builder: (context, controller, _) {
              return MaterialApp.router(
                routerConfig: AppGoRouter.router,
                title: AppText.appName,
                debugShowCheckedModeBanner: false,
                theme: MyTheme.lightTheme(context),
                darkTheme: MyTheme.darkTheme(context),
                themeMode: controller.isDark ? ThemeMode.dark : ThemeMode.light,
              );
            },
          );
        },
      ),
    );
  }
}
