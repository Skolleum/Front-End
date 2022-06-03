import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:iconsax/iconsax.dart';
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
  int balance = 0, totalDeposits = 0, installmentAmount = 3;

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
    balance = 0;
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
          margin: const EdgeInsets.only(
            left: 10,
            right: 10,
          ),
          color: Color(0xff161621),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FadeInUp(
                duration: Duration(milliseconds: 800),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Balance',
                      style: TextStyle(
                          color: Colors.blueGrey.shade300, fontSize: 20),
                    ),
                    IconButton(
                      onPressed: () async {
                        var result = await readContract(getBalanceAmount, []);
                        balance = result?.first?.toInt();
                        setState(() {});
                      },
                      icon: Icon(Icons.refresh),
                      color: Colors.blueGrey.shade200,
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      'Deposit',
                      style: TextStyle(
                          color: Colors.blueGrey.shade300, fontSize: 20),
                    ),
                    IconButton(
                      onPressed: () async {
                        var result = await readContract(getDepositAmount, []);
                        totalDeposits = result?.first?.toInt();
                        setState(() {});
                      },
                      icon: Icon(Icons.refresh),
                      color: Colors.blueGrey.shade200,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeInUp(
                    duration: Duration(milliseconds: 800),
                    child: Text(
                      "\$ $balance",
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  FadeInUp(
                    duration: Duration(milliseconds: 800),
                    child: Text(
                      "\$ $totalDeposits",
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ],
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
              FadeInUp(
                duration: Duration(milliseconds: 1000),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    MaterialButton(
                      onPressed: () {
                        () async {
                          await writeContract(
                            addDepositAmount,
                            [BigInt.from(installmentAmount)],
                          );
                        };
                      },
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: Color(0xff02d39a).withOpacity(0.7),
                      child: Expanded(
                        child: Row(
                          children: [
                            Icon(
                              Iconsax.wallet,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Deposit",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    MaterialButton(
                      onPressed: () async {
                        await writeContract(withdrawBalance, []);
                      },
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: Color.fromARGB(255, 211, 33, 2)
                                  .withOpacity(0.4),
                              width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      splashColor:
                          Color.fromARGB(255, 211, 26, 2).withOpacity(0.4),
                      highlightColor:
                          Color.fromARGB(255, 211, 30, 2).withOpacity(0.4),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      color: Colors.transparent,
                      elevation: 0,
                      child: Expanded(
                        child: Row(
                          children: [
                            Icon(
                              Iconsax.arrow_3,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Withdraw",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return (ListTile(
                      textColor: Colors.white,
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
