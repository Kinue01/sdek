import 'package:clientapp/domain/model/Client.dart';

abstract class CurrentClientRepository {
  Future<Client> getCurrClient();
  Future<bool> saveCurrClient(Client client);
}