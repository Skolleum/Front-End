import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartwallet/helper/crypto_api_helper.dart';

import '../model/crypto_model.dart';

class CryptoCubit extends Cubit<List<Crypto>> {
  final _dataService = CryptoAPI();

  CryptoCubit() : super([]);

  void getCrypto() async => emit(await _dataService.fetchPost());
}
