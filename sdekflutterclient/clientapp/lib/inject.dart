import 'package:clientapp/data/repository/authorisation_data_repository.dart';
import 'package:clientapp/data/repository/client_data_repository.dart';
import 'package:clientapp/data/repository/employee_data_repository.dart';
import 'package:clientapp/data/repository/message_data_repository.dart';
import 'package:clientapp/data/repository/package_data_repository.dart';
import 'package:clientapp/data/repository/package_status_data_repository.dart';
import 'package:clientapp/data/repository/package_type_data_repository.dart';
import 'package:clientapp/data/repository/position_data_repository.dart';
import 'package:clientapp/data/repository/transport_data_repository.dart';
import 'package:clientapp/data/repository/transport_type_data_repository.dart';
import 'package:clientapp/data/repository/user_data_repository.dart';
import 'package:clientapp/data/repositoryimpl/authorisation_repositoryimpl.dart';
import 'package:clientapp/data/repositoryimpl/client_repositoryimpl.dart';
import 'package:clientapp/data/repositoryimpl/employee_repositoryimpl.dart';
import 'package:clientapp/data/repositoryimpl/message_repository_impl.dart';
import 'package:clientapp/data/repositoryimpl/package_repositoryimpl.dart';
import 'package:clientapp/data/repositoryimpl/package_status_repositoryimpl.dart';
import 'package:clientapp/data/repositoryimpl/package_type_repositoryimpl.dart';
import 'package:clientapp/data/repositoryimpl/position_repositoryimpl.dart';
import 'package:clientapp/data/repositoryimpl/role_repositoryimpl.dart';
import 'package:clientapp/data/repositoryimpl/transport_repositoryimpl.dart';
import 'package:clientapp/data/repositoryimpl/transport_type_repositoryimpl.dart';
import 'package:clientapp/data/repositoryimpl/user_repositoryimpl.dart';
import 'package:clientapp/domain/repository/authorisation_repository.dart';
import 'package:clientapp/domain/repository/client_repository.dart';
import 'package:clientapp/domain/repository/employee_repository.dart';
import 'package:clientapp/domain/repository/message_repository.dart';
import 'package:clientapp/domain/repository/package_repository.dart';
import 'package:clientapp/domain/repository/package_status_repository.dart';
import 'package:clientapp/domain/repository/package_type_repository.dart';
import 'package:clientapp/domain/repository/position_repository.dart';
import 'package:clientapp/domain/repository/role_repository.dart';
import 'package:clientapp/domain/repository/transport_repository.dart';
import 'package:clientapp/domain/repository/transport_type_repository.dart';
import 'package:clientapp/domain/repository/user_repository.dart';
import 'package:clientapp/domain/usecase/auth/GetGoogleUrlUseCase.dart';
import 'package:clientapp/domain/usecase/auth/GetUserByLoginPassUseCase.dart';
import 'package:clientapp/domain/usecase/auth/RevokeTokenBySecretUseCase.dart';
import 'package:clientapp/domain/usecase/auth/SendAuthCodeUseCase.dart';
import 'package:clientapp/domain/usecase/client/AddClientUseCase.dart';
import 'package:clientapp/domain/usecase/client/DeleteClientUseCase.dart';
import 'package:clientapp/domain/usecase/client/GetClientByIdUseCase.dart';
import 'package:clientapp/domain/usecase/client/GetClientByUserIdUseCase.dart';
import 'package:clientapp/domain/usecase/client/GetClientsUseCase.dart';
import 'package:clientapp/domain/usecase/client/UpdateClientUseCase.dart';
import 'package:clientapp/domain/usecase/employee/AddEmployeeUseCase.dart';
import 'package:clientapp/domain/usecase/employee/DeleteEmployeeUseCase.dart';
import 'package:clientapp/domain/usecase/employee/GetEmployeeByIdUseCase.dart';
import 'package:clientapp/domain/usecase/employee/GetEmployeeByUserIdUseCase.dart';
import 'package:clientapp/domain/usecase/employee/GetEmployeesUseCase.dart';
import 'package:clientapp/domain/usecase/employee/UpdateEmployeeUseCase.dart';
import 'package:clientapp/domain/usecase/message/SendMessageUseCase.dart';
import 'package:clientapp/domain/usecase/pack/AddPackageUseCase.dart';
import 'package:clientapp/domain/usecase/pack/DeletePackageUseCase.dart';
import 'package:clientapp/domain/usecase/pack/GetPackageByIdUseCase.dart';
import 'package:clientapp/domain/usecase/pack/GetPackagesByClientIdUseCase.dart';
import 'package:clientapp/domain/usecase/pack/GetPackagesUseCase.dart';
import 'package:clientapp/domain/usecase/pack/UpdatePackageUseCase.dart';
import 'package:clientapp/domain/usecase/package_status/AddPackageStatusUseCase.dart';
import 'package:clientapp/domain/usecase/package_status/DeletePackageStatusUseCase.dart';
import 'package:clientapp/domain/usecase/package_status/GetPackageStatusByIdUseCase.dart';
import 'package:clientapp/domain/usecase/package_status/GetPackageStatusesUseCase.dart';
import 'package:clientapp/domain/usecase/package_status/UpdatePackageStatusUseCase.dart';
import 'package:clientapp/domain/usecase/package_type/AddPackageTypeUseCase.dart';
import 'package:clientapp/domain/usecase/package_type/DeletePackageTypeUseCase.dart';
import 'package:clientapp/domain/usecase/package_type/GetPackageTypeByIdUseCase.dart';
import 'package:clientapp/domain/usecase/package_type/GetPackageTypesUseCase.dart';
import 'package:clientapp/domain/usecase/package_type/UpdatePackageTypeUseCase.dart';
import 'package:clientapp/domain/usecase/position/AddPositionUseCase.dart';
import 'package:clientapp/domain/usecase/position/DeletePositionUseCase.dart';
import 'package:clientapp/domain/usecase/position/GetPositionByIdUseCase.dart';
import 'package:clientapp/domain/usecase/position/GetPositionsUseCase.dart';
import 'package:clientapp/domain/usecase/position/UpdatePositionUseCase.dart';
import 'package:clientapp/domain/usecase/role/GetRoleByIdUseCase.dart';
import 'package:clientapp/domain/usecase/role/GetRolesUseCase.dart';
import 'package:clientapp/domain/usecase/transport/AddTransportUseCase.dart';
import 'package:clientapp/domain/usecase/transport/DeleteTransportUseCase.dart';
import 'package:clientapp/domain/usecase/transport/GetTransportByDriverIdUseCase.dart';
import 'package:clientapp/domain/usecase/transport/GetTransportByIdUseCase.dart';
import 'package:clientapp/domain/usecase/transport/GetTransportUseCase.dart';
import 'package:clientapp/domain/usecase/transport/UpdateTransportUseCase.dart';
import 'package:clientapp/domain/usecase/transport_type/AddTransportTypeUseCase.dart';
import 'package:clientapp/domain/usecase/transport_type/DeleteTransportTypeUseCase.dart';
import 'package:clientapp/domain/usecase/transport_type/GetTransportTypeByIdUseCase.dart';
import 'package:clientapp/domain/usecase/transport_type/GetTransportTypesUseCase.dart';
import 'package:clientapp/domain/usecase/transport_type/UpdateTransportTypeUseCase.dart';
import 'package:clientapp/domain/usecase/user/AddUserUseCase.dart';
import 'package:clientapp/domain/usecase/user/DeleteUserUseCase.dart';
import 'package:clientapp/domain/usecase/user/GetUserByIdUseCase.dart';
import 'package:clientapp/domain/usecase/user/GetUsersUseCase.dart';
import 'package:clientapp/domain/usecase/user/UpdateUserUseCase.dart';
import 'package:clientapp/local/local_storage/client_local_storage.dart';
import 'package:clientapp/local/local_storage/employee_local_storage.dart';
import 'package:clientapp/local/local_storage/package_local_storage.dart';
import 'package:clientapp/local/local_storage/package_status_local_storage.dart';
import 'package:clientapp/local/local_storage/package_type_local_storage.dart';
import 'package:clientapp/local/local_storage/position_local_storage.dart';
import 'package:clientapp/local/local_storage/role_local_storage.dart';
import 'package:clientapp/local/local_storage/transport_local_storage.dart';
import 'package:clientapp/local/local_storage/transport_type_local_storage.dart';
import 'package:clientapp/local/local_storage/user_local_storage.dart';
import 'package:clientapp/remote/api/MessageApi.dart';
import 'package:clientapp/remote/api/authorisation_api.dart';
import 'package:clientapp/remote/api/client_api.dart';
import 'package:clientapp/remote/api/employee_api.dart';
import 'package:clientapp/remote/api/package_api.dart';
import 'package:clientapp/remote/api/package_status_api.dart';
import 'package:clientapp/remote/api/package_type_api.dart';
import 'package:clientapp/remote/api/position_api.dart';
import 'package:clientapp/remote/api/role_api.dart';
import 'package:clientapp/remote/api/transport_api.dart';
import 'package:clientapp/remote/api/transport_type_api.dart';
import 'package:clientapp/remote/api/user_api.dart';
import 'package:clientapp/remote/repositoryimpl/authorisation_data_repository_impl.dart';
import 'package:clientapp/remote/repositoryimpl/client_data_repository_impl.dart';
import 'package:clientapp/remote/repositoryimpl/employee_data_repository_impl.dart';
import 'package:clientapp/remote/repositoryimpl/message_data_repository_impl.dart';
import 'package:clientapp/remote/repositoryimpl/package_data_repository_impl.dart';
import 'package:clientapp/remote/repositoryimpl/package_status_data_repository_impl.dart';
import 'package:clientapp/remote/repositoryimpl/package_type_data_repository_impl.dart';
import 'package:clientapp/remote/repositoryimpl/position_data_repository_impl.dart';
import 'package:clientapp/remote/repositoryimpl/role_data_repository_impl.dart';
import 'package:clientapp/remote/repositoryimpl/transport_data_repository_impl.dart';
import 'package:clientapp/remote/repositoryimpl/transport_type_data_repository_impl.dart';
import 'package:clientapp/remote/repositoryimpl/user_data_repository_impl.dart';
import 'package:clientapp/view/home_page/controller/home_controller.dart';
import 'package:clientapp/view/login_page/controller/login_page_controller.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/repository/role_data_repository.dart';
import 'domain/usecase/message/ReceiveMessageUseCase.dart';
import 'view/send_package_page/controller/send_package_controller.dart';
import 'view/track_package_page/controller/track_package_controller.dart';

GetIt getIt = GetIt.instance;

void initGetIt() {

  // ----------------------------------------
  // REMOTE
  // ----------------------------------------
  getIt.registerLazySingleton(() => Dio());

  getIt.registerLazySingleton<RoleApi>(() => RoleApiImpl(client: getIt()));
  getIt.registerLazySingleton<PositionApi>(() => PositionApiImpl(client: getIt()));
  getIt.registerLazySingleton<TransportApi>(() => TransportApiImpl(client: getIt()));
  getIt.registerLazySingleton<TransportTypeApi>(() => TransportTypeApiImpl(client: getIt()));
  getIt.registerLazySingleton<UserApi>(() => UserApiImpl(client: getIt()));
  getIt.registerLazySingleton<PackageApi>(() => PackageApiImpl(client: getIt()));
  getIt.registerLazySingleton<PackageStatusApi>(() => PackageStatusApiImpl(client: getIt()));
  getIt.registerLazySingleton<PackageTypeApi>(() => PackageTypeApiImpl(client: getIt()));
  getIt.registerLazySingleton<EmployeeApi>(() => EmployeeApiImpl(client: getIt()));
  getIt.registerLazySingleton<ClientApi>(() => ClientApiImpl(dio_client: getIt()));
  getIt.registerLazySingleton<AuthorisationApi>(() => AuthorisationApiImpl(client: getIt()));
  getIt.registerLazySingleton<MessageApi>(() => MessageApiImpl());
  
  
  // ---------------------------------------------
  // LOCAL
  // ---------------------------------------------
  getIt.registerLazySingleton(() => SharedPreferences.getInstance());

  getIt.registerFactory<RoleLocalStorage>(() => RoleLocalStorageImpl(sharedPreferencesAsync: getIt()));
  getIt.registerFactory<PositionLocalStorage>(() => PositionLocalStorageImpl(sharedPreferencesAsync: getIt()));
  getIt.registerFactory<UserLocalStorage>(() => UserLocalStorageImpl(sharedPreferencesAsync: getIt()));
  getIt.registerFactory<TransportTypeLocalStorage>(() => TransportTypeLocalStorageImpl(sharedPreferencesAsync: getIt()));
  getIt.registerFactory<TransportLocalStorage>(() => TransportLocalStorageImpl(sharedPreferencesAsync: getIt()));
  getIt.registerFactory<PackageTypeLocalStorage>(() => PackageTypeLocalStorageImpl(sharedPreferencesAsync: getIt()));
  getIt.registerFactory<PackageStatusLocalStorage>(() => PackageStatusLocalStorageImpl(sharedPreferencesAsync: getIt()));
  getIt.registerFactory<PackageLocalStorage>(() => PackageLocalStorageImpl(sharedPreferencesAsync: getIt()));
  getIt.registerFactory<ClientLocalStorage>(() => ClientLocalStorageImpl(sharedPreferencesAsync: getIt()));
  getIt.registerFactory<EmployeeLocalStorage>(() => EmployeeLocalStorageImpl(sharedPreferencesAsync: getIt()));
  

  // ------------------------------------------
  // DATA
  // ------------------------------------------
  getIt.registerFactory<RoleDataRepository>(() => RoleDataRepositoryImpl(roleApi: getIt()));
  getIt.registerFactory<PositionDataRepository>(() => PositionDataRepositoryImpl(positionApi: getIt()));
  getIt.registerFactory<TransportDataRepository>(() => TransportDataRepositoryImpl(transportApi: getIt()));
  getIt.registerFactory<TransportTypeDataRepository>(() => TransportTypeDataRepositoryImpl(transportTypeApi: getIt()));
  getIt.registerFactory<UserDataRepository>(() => UserDataRepositoryImpl(userApi: getIt()));
  getIt.registerFactory<PackageDataRepository>(() => PackageDataRepositoryImpl(packageApi: getIt()));
  getIt.registerFactory<PackageStatusDataRepository>(() => PackageStatusDataRepositoryImpl(packageStatusApi: getIt()));
  getIt.registerFactory<PackageTypeDataRepository>(() => PackageTypeDataRepositoryImpl(packageTypeApi: getIt()));
  getIt.registerFactory<EmployeeDataRepository>(() => EmployeeDataRepositoryImpl(employeeApi: getIt()));
  getIt.registerFactory<ClientDataRepository>(() => ClientDataRepositoryImpl(clientApi: getIt()));
  getIt.registerFactory<AuthorisationOauthDataRepository>(() => AuthorisationDataRepositoryImpl(authorisationApi: getIt()));
  getIt.registerFactory<MessageDataRepository>(() => MessageDataRepositoryImpl(messageApi: getIt()));


  // ------------------------------------------
  // DOMAIN
  // ------------------------------------------
  getIt.registerFactory<RoleRepository>(() => RoleRepositoryImpl(repository: getIt(), roleLocalStorage: getIt()));
  getIt.registerFactory<PositionRepository>(() => PositionRepositoryImpl(repository: getIt(), positionLocalStorage: getIt()));
  getIt.registerFactory<TransportRepository>(() => TransportRepositoryImpl(repository: getIt(), transportLocalStorage: getIt()));
  getIt.registerFactory<TransportTypeRepository>(() => TransportTypeRepositoryImpl(repository: getIt(), transportTypeLocalStorage: getIt()));
  getIt.registerFactory<UserRepository>(() => UserRepositoryImpl(repository: getIt(), userLocalStorage: getIt()));
  getIt.registerFactory<PackageRepository>(() => PackageRepositoryImpl(repository: getIt(), packageLocalStorage: getIt()));
  getIt.registerFactory<PackageStatusRepository>(() => PackageStatusRepositoryImpl(repository: getIt(), packageStatusLocalStorage: getIt()));
  getIt.registerFactory<PackageTypeRepository>(() => PackageTypeRepositoryImpl(repository: getIt(), packageTypeLocalStorage: getIt()));
  getIt.registerFactory<EmployeeRepository>(() => EmployeeRepositoryImpl(repository: getIt(), employeeLocalStorage: getIt()));
  getIt.registerFactory<ClientRepository>(() => ClientRepositoryImpl(repository: getIt(), clientLocalStorage: getIt()));
  getIt.registerFactory<AuthorisationOauthRepository>(() => AuthorisationOauthRepositoryImpl(repository: getIt()));
  getIt.registerFactory<MessageRepository>(() => MessageRepositoryImpl(repository: getIt()));


  getIt.registerFactory(() => GetRolesUseCase(repository: getIt()));
  getIt.registerFactory(() => GetRoleByIdUseCase(repository: getIt()));

  getIt.registerFactory(() => AddPositionUseCase(repository: getIt()));
  getIt.registerFactory(() => DeletePositionUseCase(repository: getIt()));
  getIt.registerFactory(() => GetPositionsUseCase(repository: getIt()));
  getIt.registerFactory(() => GetPositionByIdUseCase(repository: getIt()));
  getIt.registerFactory(() => UpdatePositionUseCase(repository: getIt()));

  getIt.registerFactory(() => AddTransportUseCase(repository: getIt()));
  getIt.registerFactory(() => DeleteTransportUseCase(repository: getIt()));
  getIt.registerFactory(() => GetTransportByIdUseCase(repository: getIt()));
  getIt.registerFactory(() => GetTransportByDriverIdUseCase(repository: getIt()));
  getIt.registerFactory(() => GetTransportUseCase(repository: getIt()));
  getIt.registerFactory(() => UpdateTransportUseCase(repository: getIt()));

  getIt.registerFactory(() => AddTransportTypeUseCase(repository: getIt()));
  getIt.registerFactory(() => DeleteTransportTypeUseCase(repository: getIt()));
  getIt.registerFactory(() => GetTransportTypeByIdUseCase(repository: getIt()));
  getIt.registerFactory(() => GetTransportTypesUseCase(repository: getIt()));
  getIt.registerFactory(() => UpdateTransportTypeUseCase(repository: getIt()));

  getIt.registerFactory(() => AddUserUseCase(repository: getIt()));
  getIt.registerFactory(() => DeleteUserUseCase(repository: getIt()));
  getIt.registerFactory(() => GetUserByIdUseCase(repository: getIt()));
  getIt.registerFactory(() => GetUsersUseCase(repository: getIt()));
  getIt.registerFactory(() => UpdateUserUseCase(repository: getIt()));

  getIt.registerFactory(() => AddPackageUseCase(repository: getIt()));
  getIt.registerFactory(() => DeletePackageUseCase(repository: getIt()));
  getIt.registerFactory(() => GetPackageByIdUseCase(repository: getIt()));
  getIt.registerFactory(() => GetPackagesByClientIdUseCase(repository: getIt()));
  getIt.registerFactory(() => GetPackagesUseCase(repository: getIt()));
  getIt.registerFactory(() => UpdatePackageUseCase(repository: getIt()));

  getIt.registerFactory(() => AddPackageStatusUseCase(repository: getIt()));
  getIt.registerFactory(() => DeletePackageStatusUseCase(repository: getIt()));
  getIt.registerFactory(() => GetPackageStatusByIdUseCase(repository: getIt()));
  getIt.registerFactory(() => GetPackageStatusesUseCase(repository: getIt()));
  getIt.registerFactory(() => UpdatePackageStatusUseCase(repository: getIt()));

  getIt.registerFactory(() => AddPackageTypeUseCase(repository: getIt()));
  getIt.registerFactory(() => DeletePackageTypeUseCase(repository: getIt()));
  getIt.registerFactory(() => GetPackageTypeByIdUseCase(repository: getIt()));
  getIt.registerFactory(() => GetPackageTypesUseCase(repository: getIt()));
  getIt.registerFactory(() => UpdatePackageTypeUseCase(repository: getIt()));

  getIt.registerFactory(() => AddEmployeeUseCase(repository: getIt()));
  getIt.registerFactory(() => DeleteEmployeeUseCase(repository: getIt()));
  getIt.registerFactory(() => GetEmployeeByIdUseCase(repository: getIt()));
  getIt.registerFactory(() => GetEmployeeByUserIdUseCase(repository: getIt()));
  getIt.registerFactory(() => GetEmployeesUseCase(repository: getIt()));
  getIt.registerFactory(() => UpdateEmployeeUseCase(repository: getIt()));

  getIt.registerFactory(() => AddClientUseCase(repository: getIt()));
  getIt.registerFactory(() => DeleteClientUseCase(repository: getIt()));
  getIt.registerFactory(() => GetClientByIdUseCase(repository: getIt()));
  getIt.registerFactory(() => GetClientByUserIdUseCase(repository: getIt()));
  getIt.registerFactory(() => GetClientsUseCase(repository: getIt()));
  getIt.registerFactory(() => UpdateClientUseCase(repository: getIt()));

  getIt.registerFactory(() => GetGoogleUrlUseCase(repository: getIt()));
  getIt.registerFactory(() => RevokeTokenBySecretUseCase(repository: getIt()));
  getIt.registerFactory(() => SendAuthCodeUseCase(repository: getIt()));
  getIt.registerFactory(() => GetUserByLoginPassUseCase(repository: getIt()));

  getIt.registerFactory(() => SendMessageUseCase(repository: getIt()));
  getIt.registerFactory(() => ReceiveMessageUseCase(repository: getIt()));


  // ----------------------------------------
  // VIEW
  // ----------------------------------------
  getIt.registerLazySingleton(() => HomeController());
  getIt.registerLazySingleton(() => SendPackageController());
  getIt.registerLazySingleton(() => TrackPackageController());
  getIt.registerLazySingleton(() => LoginPageController(getUserByLoginPassUseCase: getIt())); // не зареган ???
}