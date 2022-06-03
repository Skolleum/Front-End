import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:smartwallet/constants/asset_constants.dart';
import 'package:smartwallet/constants/string_constants.dart';
import 'package:smartwallet/model/Transaction.dart';
import 'package:web3dart/web3dart.dart';

import '../../helper/shared_preferences.dart';
import '../../model/linechart_model.dart';

TransactionModel transactionModel = TransactionModel(
  'PAID',
  '0xAE123213',
  '10',
  DateFormat.jm().format(DateTime.now()),
);

class WalletPage extends StatefulWidget {
  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  int balance = 0, totalDeposits = 0, installmentAmount = 10;

  Client httpClient;
  Web3Client ethClient;
// JSON-RPC is a JSON-encoded remote procedure dispatch protocol.
//  Remote Procedure Call (RPC) focuses on “ running a piece of code on some other server.

  String rpcUrl = StringConstants.RPC_URL;

  List<TransactionModel> list =
      List<TransactionModel>.filled(1, transactionModel, growable: true);

  @override
  void initState() {
    list = List<TransactionModel>.filled(1, transactionModel, growable: true);

    initialSetup();
    super.initState();
  }

  Future<void> initialSetup() async {
    /// This will launch a client that connects to the RPC URL's JSON RPC API.
    ///Requests will be sent to the [RPC server] using the httpClient.

    httpClient = Client();

    ///It opens a connection to Eth to send transactions and interact with smart contracts.
    ethClient = Web3Client(rpcUrl, httpClient);

    await getCredentials();
    await getDeployedContract();
    await getContractFunctions();
  }

  /// This will generate [credentials] using the supplied [privateKey] and
  /// load the Ethereum address given by these credentials.
  Credentials credentials;
  EthereumAddress myAddress;

  Future<void> getCredentials() async {
    String walletPrivateKey =
        await walletSharedPref.readStringValue("privateKey");

    credentials = await ethClient.credentialsFromPrivateKey(walletPrivateKey);
    myAddress = await credentials.extractAddress();
    print("WALLET_PRIVATE_KEY___$walletPrivateKey");
  }

  /// This will execute a [functionName] using the arguments [functionArgs] provided in the [contract] and output the result.
  String abi;
  EthereumAddress contractAddress;

  Future<void> getDeployedContract() async {
    String abiString =
        await rootBundle.loadString(AssetConstants.JSON_CONTRACT);
    var abiJson = jsonDecode(abiString);
    abi = jsonEncode(abiJson['abi']);

    contractAddress =
        EthereumAddress.fromHex(abiJson['networks']['5777']['address']);
  }

  ///Signs the given transaction with the keys provided in the [credentials] item before uploading it to the client for execution.
  DeployedContract contract;
  ContractFunction getBalanceAmount,
      getDepositAmount,
      addDepositAmount,
      withdrawBalance;

  Future<void> getContractFunctions() async {
    contract = DeployedContract(
        ContractAbi.fromJson(abi, "Investment"), contractAddress);

    getBalanceAmount = contract.function('getBalanceAmount');
    getDepositAmount = contract.function('getDepositAmount');
    addDepositAmount = contract.function('addDepositAmount');
    withdrawBalance = contract.function('withdrawBalance');
  }

  Future<List<dynamic>> readContract(
    ContractFunction functionName,
    List<dynamic> functionArgs,
  ) async {
    var queryResult = await ethClient.call(
      contract: contract,
      function: functionName,
      params: functionArgs,
    );

    return queryResult;
  }

  Future<void> writeContract(
    ContractFunction functionName,
    List<dynamic> functionArgs,
  ) async {
    await ethClient.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: functionName,
        parameters: functionArgs,
      ),
    );
  }

  SmartWalletSharedPref walletSharedPref = SmartWalletSharedPref();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff161621),
      body: SafeArea(
        child: Container(
          color: Color(0xff161621),
          child: Column(
            children: [
              FadeInUp(
                duration: Duration(milliseconds: 800),
                child: Text(
                  "Balance",
                  style:
                      TextStyle(color: Colors.blueGrey.shade300, fontSize: 20),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              FadeInUp(
                duration: Duration(milliseconds: 800),
                child: Text(
                  "\$ 12,500.00",
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              FadeInUp(
                duration: Duration(milliseconds: 1000),
                child: Container(
                  width: double.infinity,
                  height: 250,
                  child: LineChart(
                    lineChartModel(),
                    swapAnimationDuration:
                        Duration(milliseconds: 1000), // Optional
                    swapAnimationCurve: Curves.linear, // Optional
                  ),
                ),
              ),

              // show balance
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    '£ $balance',
                    style: TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // update balance
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: FloatingActionButton.extended(
                    heroTag: 'check_balance',
                    onPressed: () async {
                      var result = await readContract(getBalanceAmount, []);
                      balance = result?.first?.toInt();
                      setState(() {});
                    },
                    label: Text(
                      StringConstants.CHECK_BALANCE,
                    ),
                    icon: Icon(Icons.refresh),
                    backgroundColor: Colors.pink,
                  ),
                ),
              ),
              // show deposits
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    '£ $totalDeposits',
                    style: TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // update deposits
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: FloatingActionButton.extended(
                    heroTag: 'check_deposits',
                    onPressed: () async {
                      var result = await readContract(getDepositAmount, []);
                      totalDeposits = result?.first?.toInt();
                      setState(() {});
                    },
                    label: Text('Check Deposits'),
                    icon: Icon(Icons.refresh),
                    backgroundColor: Colors.pink,
                  ),
                ),
              ),
              // deposit amount
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 100,
                    width: 250,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: FloatingActionButton.extended(
                        heroTag: 'deposit_amount',
                        onPressed: () async {
                          await writeContract(addDepositAmount,
                              [BigInt.from(installmentAmount)]);
                        },
                        label: Text('Deposit £ 3'),
                        icon: Icon(Icons.add_circle),
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ),
                ),
              ),
              // withdraw balance
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 100,
                    width: 350,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: FloatingActionButton.extended(
                        heroTag: 'withdraw_balance',
                        onPressed: () async {
                          await writeContract(withdrawBalance, []);
                        },
                        label: Text('Withdraw Balance'),
                        icon: Icon(Icons.remove_circle),
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ),
                ),
              ),

              Expanded(
                  child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return (ListTile(
                    tileColor: Colors.white,
                    hoverColor: Colors.grey,
                    leading: list[index].name == "PAID"
                        ? Icon(Icons.call_made_outlined)
                        : Icon(Icons.call_received_outlined),
                    title: Text(list[index].name),
                    subtitle: Column(children: [
                      Text('\u{20B9}${list[index].amount}'),
                      Text("Token Hash :" +
                          '${list[index].hash.substring(0, 7)}')
                    ]),
                    onTap: () => print("ListTile"),
                    trailing: Text('${list[index].timestamp}'),
                  ));
                },
              ))
            ],
          ),
        ),
      ),
    );
  }
}
