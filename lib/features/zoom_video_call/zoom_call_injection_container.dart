import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_zoom_call/features/zoom_video_call/data/data_sources/firebase_auth/firebase_auth_data_source.dart';
import 'package:flutter_zoom_call/features/zoom_video_call/data/data_sources/firebase_firestore/firebase_firestore_data_source.dart';
import 'package:flutter_zoom_call/features/zoom_video_call/data/data_sources/jitsi_meet_api/jitsi_data_source.dart';
import 'package:flutter_zoom_call/features/zoom_video_call/domain/repositories/zoom_repository.dart';
import 'package:flutter_zoom_call/features/zoom_video_call/presentation/cubits/auth/auth_cubit.dart';
import 'package:flutter_zoom_call/features/zoom_video_call/presentation/cubits/meeting/meeting_cubit.dart';
import 'package:get_it/get_it.dart';

import 'data/data_sources/firebase_auth/firebase_auth_data_source_impl.dart';
import 'data/data_sources/firebase_firestore/firebase_firestore_data_source_impl.dart';
import 'data/data_sources/jitsi_meet_api/jitsi_data_source_impl.dart';
import 'data/repositories/zoom_repository_impl.dart';
import 'domain/use_cases/create_or_join_meeting_usecase.dart';
import 'domain/use_cases/get_current_user_usecase.dart';
import 'domain/use_cases/get_meeting_history_usecase.dart';
import 'domain/use_cases/listen_to_auth_change_usecase.dart';
import 'domain/use_cases/sign_in_with_google_account_usecase.dart';
import 'domain/use_cases/sign_out_usecase.dart';

final sl = GetIt.instance;

Future<void> initializeZoomCallingFeature() async {
//data sources
  sl.registerLazySingleton<FirebaseAuthDataSource>(
      () => FirebaseAuthDataSourceImpl(fireStore: sl(), auth: sl()));
  sl.registerLazySingleton<FirebaseFireStoreDataSource>(
      () => FirebaseFireStoreDataSourceImpl(fireStore: sl(), auth: sl()));
  sl.registerLazySingleton<JitsiMeetDataSource>(
      () => JitsiMeetDataSourceImpl(fireStore: sl(), auth: sl()));

//repositories
  sl.registerLazySingleton<ZoomRepository>(() => ZoomRepositoryImpl(
        jitsiMeetDataSource: sl(),
        fireStoreDataSource: sl(),
        authDataSource: sl(),
      ));

//use cases

  sl.registerLazySingleton<CreateOrJoinMeetingUseCase>(
      () => CreateOrJoinMeetingUseCase(zoomRepository: sl()));
  sl.registerLazySingleton<GetCurrentUserUseCase>(
      () => GetCurrentUserUseCase(zoomRepository: sl()));
  sl.registerLazySingleton<GetMeetingHistoryUseCase>(
      () => GetMeetingHistoryUseCase(zoomRepository: sl()));
  sl.registerLazySingleton<ListenToAuthChangeUseCase>(
      () => ListenToAuthChangeUseCase(zoomRepository: sl()));
  sl.registerLazySingleton<SignInWithGoogleAccountUseCase>(
      () => SignInWithGoogleAccountUseCase(zoomRepository: sl()));
  sl.registerLazySingleton<SignOutUseCase>(
      () => SignOutUseCase(zoomRepository: sl()));

//cubits
  sl.registerFactory<AuthCubit>(() => AuthCubit());
  sl.registerFactory<MeetingCubit>(() => MeetingCubit());

//external
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseRemoteConfig.instance);
}
