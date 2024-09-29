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
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/repository/role_data_repository.dart';
import 'domain/usecase/message/ReceiveMessageUseCase.dart';
import 'view/send_package_page/controller/send_package_controller.dart';
import 'view/track_package_page/controller/track_package_controller.dart';

GetIt getIt = GetIt.instance;

Future<void> initGetIt() async {

  // ----------------------------------------
  // REMOTE
  // ----------------------------------------
  getIt.registerLazySingletonAsync(() async => Dio());

  getIt.registerLazySingletonAsync<RoleApi>(() async => RoleApiImpl(client: getIt()));
  getIt.registerLazySingletonAsync<PositionApi>(() async => PositionApiImpl(client: getIt()));
  getIt.registerLazySingletonAsync<TransportApi>(() async => TransportApiImpl(client: getIt()));
  getIt.registerLazySingletonAsync<TransportTypeApi>(() async => TransportTypeApiImpl(client: getIt()));
  getIt.registerLazySingletonAsync<UserApi>(() async => UserApiImpl(client: getIt()));
  getIt.registerLazySingletonAsync<PackageApi>(() async => PackageApiImpl(client: getIt()));
  getIt.registerLazySingletonAsync<PackageStatusApi>(() async => PackageStatusApiImpl(client: getIt()));
  getIt.registerLazySingletonAsync<PackageTypeApi>(() async => PackageTypeApiImpl(client: getIt()));
  getIt.registerLazySingletonAsync<EmployeeApi>(() async => EmployeeApiImpl(client: getIt()));
  getIt.registerLazySingletonAsync<ClientApi>(() async => ClientApiImpl(dio_client: getIt()));
  getIt.registerLazySingletonAsync<AuthorisationApi>(() async => AuthorisationApiImpl(client: getIt()));
  getIt.registerLazySingletonAsync<MessageApi>(() async => MessageApiImpl());
  
  
  // ---------------------------------------------
  // LOCAL
  // ---------------------------------------------
  getIt.registerLazySingletonAsync(() async => SharedPreferencesAsync());

  getIt.registerFactoryAsync<RoleLocalStorage>(() async => RoleLocalStorageImpl(sharedPreferencesAsync: getIt()));
  getIt.registerFactoryAsync<PositionLocalStorage>(() async => PositionLocalStorageImpl(sharedPreferencesAsync: getIt()));
  getIt.registerFactoryAsync<UserLocalStorage>(() async => UserLocalStorageImpl(sharedPreferencesAsync: getIt()));
  getIt.registerFactoryAsync<TransportTypeLocalStorage>(() async => TransportTypeLocalStorageImpl(sharedPreferencesAsync: getIt()));
  getIt.registerFactoryAsync<TransportLocalStorage>(() async => TransportLocalStorageImpl(sharedPreferencesAsync: getIt()));
  getIt.registerFactoryAsync<PackageTypeLocalStorage>(() async => PackageTypeLocalStorageImpl(sharedPreferencesAsync: getIt()));
  getIt.registerFactoryAsync<PackageStatusLocalStorage>(() async => PackageStatusLocalStorageImpl(sharedPreferencesAsync: getIt()));
  getIt.registerFactoryAsync<PackageLocalStorage>(() async => PackageLocalStorageImpl(sharedPreferencesAsync: getIt()));
  getIt.registerFactoryAsync<ClientLocalStorage>(() async => ClientLocalStorageImpl(sharedPreferencesAsync: getIt()));
  getIt.registerFactoryAsync<EmployeeLocalStorage>(() async => EmployeeLocalStorageImpl(sharedPreferencesAsync: getIt()));
  

  // ------------------------------------------
  // DATA
  // ------------------------------------------
  getIt.registerFactoryAsync<RoleDataRepository>(() async => RoleDataRepositoryImpl(roleApi: getIt()));
  getIt.registerFactoryAsync<PositionDataRepository>(() async => PositionDataRepositoryImpl(positionApi: getIt()));
  getIt.registerFactoryAsync<TransportDataRepository>(() async => TransportDataRepositoryImpl(transportApi: getIt()));
  getIt.registerFactoryAsync<TransportTypeDataRepository>(() async => TransportTypeDataRepositoryImpl(transportTypeApi: getIt()));
  getIt.registerFactoryAsync<UserDataRepository>(() async => UserDataRepositoryImpl(userApi: getIt()));
  getIt.registerFactoryAsync<PackageDataRepository>(() async => PackageDataRepositoryImpl(packageApi: getIt()));
  getIt.registerFactoryAsync<PackageStatusDataRepository>(() async => PackageStatusDataRepositoryImpl(packageStatusApi: getIt()));
  getIt.registerFactoryAsync<PackageTypeDataRepository>(() async => PackageTypeDataRepositoryImpl(packageTypeApi: getIt()));
  getIt.registerFactoryAsync<EmployeeDataRepository>(() async => EmployeeDataRepositoryImpl(employeeApi: getIt()));
  getIt.registerFactoryAsync<ClientDataRepository>(() async => ClientDataRepositoryImpl(clientApi: getIt()));
  getIt.registerFactoryAsync<AuthorisationOauthDataRepository>(() async => AuthorisationDataRepositoryImpl(authorisationApi: getIt()));
  getIt.registerLazySingletonAsync<MessageDataRepository>(() async => MessageDataRepositoryImpl(messageApi: getIt()));


  // ------------------------------------------
  // DOMAIN
  // ------------------------------------------
  getIt.registerFactoryAsync<RoleRepository>(() async => RoleRepositoryImpl(repository: getIt()));
  getIt.registerFactoryAsync<PositionRepository>(() async => PositionRepositoryImpl(repository: getIt()));
  getIt.registerFactoryAsync<TransportRepository>(() async => TransportRepositoryImpl(repository: getIt()));
  getIt.registerFactoryAsync<TransportTypeRepository>(() async => TransportTypeRepositoryImpl(repository: getIt()));
  getIt.registerFactoryAsync<UserRepository>(() async => UserRepositoryImpl(repository: getIt()));
  getIt.registerFactoryAsync<PackageRepository>(() async => PackageRepositoryImpl(repository: getIt()));
  getIt.registerFactoryAsync<PackageStatusRepository>(() async => PackageStatusRepositoryImpl(repository: getIt()));
  getIt.registerFactoryAsync<PackageTypeRepository>(() async => PackageTypeRepositoryImpl(repository: getIt()));
  getIt.registerFactoryAsync<EmployeeRepository>(() async => EmployeeRepositoryImpl(repository: getIt()));
  getIt.registerFactoryAsync<ClientRepository>(() async => ClientRepositoryImpl(repository: getIt()));
  getIt.registerFactoryAsync<AuthorisationOauthRepository>(() async => AuthorisationOauthRepositoryImpl(repository: getIt()));
  getIt.registerFactoryAsync<MessageRepository>(() async => MessageRepositoryImpl(repository: getIt()));


  getIt.registerFactoryAsync(() async => GetRolesUseCase(repository: getIt()));
  getIt.registerFactoryAsync(() async => GetRoleByIdUseCase(repository: getIt()));

  getIt.registerFactoryAsync(() async => AddPositionUseCase(repository: getIt()));
  getIt.registerFactoryAsync(() async => DeletePositionUseCase(repository: getIt()));
  getIt.registerFactoryAsync(() async => GetPositionsUseCase(repository: getIt()));
  getIt.registerFactoryAsync(() async => GetPositionByIdUseCase(repository: getIt()));
  getIt.registerFactoryAsync(() async => UpdatePositionUseCase(repository: getIt()));

  getIt.registerFactoryAsync(() async => AddTransportUseCase(repository: getIt()));
  getIt.registerFactoryAsync(() async => DeleteTransportUseCase(repository: getIt()));
  getIt.registerFactoryAsync(() async => GetTransportByIdUseCase(repository: getIt()));
  getIt.registerFactoryAsync(() async => GetTransportByDriverIdUseCase(repository: getIt()));
  getIt.registerFactoryAsync(() async => GetTransportUseCase(repository: getIt()));
  getIt.registerFactoryAsync(() async => UpdateTransportUseCase(repository: getIt()));

  getIt.registerFactoryAsync(() async => AddTransportTypeUseCase(repository: getIt()));
  getIt.registerFactoryAsync(() async => DeleteTransportTypeUseCase(repository: getIt()));
  getIt.registerFactoryAsync(() async => GetTransportTypeByIdUseCase(repository: getIt()));
  getIt.registerFactoryAsync(() async => GetTransportTypesUseCase(repository: getIt()));
  getIt.registerFactoryAsync(() async => UpdateTransportTypeUseCase(repository: getIt()));

  getIt.registerFactoryAsync(() async => AddUserUseCase(repository: getIt()));
  getIt.registerFactoryAsync(() async => DeleteUserUseCase(repository: getIt()));
  getIt.registerFactoryAsync(() async => GetUserByIdUseCase(repository: getIt()));
  getIt.registerFactoryAsync(() async => GetUsersUseCase(repository: getIt()));
  getIt.registerFactoryAsync(() async => UpdateUserUseCase(repository: getIt()));

  getIt.registerFactoryAsync(() async => AddPackageUseCase(repository: getIt()));
  getIt.registerFactoryAsync(() async => DeletePackageUseCase(repository: getIt()));
  getIt.registerFactoryAsync(() async => GetPackageByIdUseCase(repository: getIt()));
  getIt.registerFactoryAsync(() async => GetPackagesByClientIdUseCase(repository: getIt()));
  getIt.registerFactoryAsync(() async => GetPackagesUseCase(repository: getIt()));
  getIt.registerFactoryAsync(() async => UpdatePackageUseCase(repository: getIt()));

  getIt.registerFactoryAsync(() async => AddPackageStatusUseCase(repository: getIt()));
  getIt.registerFactoryAsync(() async => DeletePackageStatusUseCase(repository: getIt()));
  getIt.registerFactoryAsync(() async => GetPackageStatusByIdUseCase(repository: getIt()));
  getIt.registerFactoryAsync(() async => GetPackageStatusesUseCase(repository: getIt()));
  getIt.registerFactoryAsync(() async => UpdatePackageStatusUseCase(repository: getIt()));

  getIt.registerFactoryAsync(() async => AddPackageTypeUseCase(repository: getIt()));
  getIt.registerFactoryAsync(() async => DeletePackageTypeUseCase(repository: getIt()));
  getIt.registerFactoryAsync(() async => GetPackageTypeByIdUseCase(repository: getIt()));
  getIt.registerFactoryAsync(() async => GetPackageTypesUseCase(repository: getIt()));
  getIt.registerFactoryAsync(() async => UpdatePackageTypeUseCase(repository: getIt()));

  getIt.registerFactoryAsync(() async => AddEmployeeUseCase(repository: getIt()));
  getIt.registerFactoryAsync(() async => DeleteEmployeeUseCase(repository: getIt()));
  getIt.registerFactoryAsync(() async => GetEmployeeByIdUseCase(repository: getIt()));
  getIt.registerFactoryAsync(() async => GetEmployeeByUserIdUseCase(repository: getIt()));
  getIt.registerFactoryAsync(() async => GetEmployeesUseCase(repository: getIt()));
  getIt.registerFactoryAsync(() async => UpdateEmployeeUseCase(repository: getIt()));

  getIt.registerFactoryAsync(() async => AddClientUseCase(repository: getIt()));
  getIt.registerFactoryAsync(() async => DeleteClientUseCase(repository: getIt()));
  getIt.registerFactoryAsync(() async => GetClientByIdUseCase(repository: getIt()));
  getIt.registerFactoryAsync(() async => GetClientByUserIdUseCase(repository: getIt()));
  getIt.registerFactoryAsync(() async => GetClientsUseCase(repository: getIt()));
  getIt.registerFactoryAsync(() async => UpdateClientUseCase(repository: getIt()));

  getIt.registerFactoryAsync(() async => GetGoogleUrlUseCase(repository: getIt()));
  getIt.registerFactoryAsync(() async => RevokeTokenBySecretUseCase(repository: getIt()));
  getIt.registerFactoryAsync(() async => SendAuthCodeUseCase(repository: getIt()));

  getIt.registerFactoryAsync(() async => SendMessageUseCase(repository: getIt()));
  getIt.registerFactoryAsync(() async => ReceiveMessageUseCase(repository: getIt()));


  // ----------------------------------------
  // VIEW
  // ----------------------------------------
  getIt.registerLazySingletonAsync(() async => HomeController());
  getIt.registerLazySingletonAsync(() async => SendPackageController());
  getIt.registerLazySingletonAsync(() async => TrackPackageController());
}