import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartwallet/contract_linking.dart';

class HelloUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Getting the value and object or contract_linking
    var contractLink = Provider.of<ContractLinking>(context);

    TextEditingController yourNameController = TextEditingController();
    yourNameController.text = "0xc22776D4deE0999eD946bC6158440015C9Fd9965";

    return Scaffold(
      body: Center(
        child: contractLink.isLoading
            ? CircularProgressIndicator()
            : SingleChildScrollView(
                child: Form(
                  child: Column(
                    children: [
                      Text(
                        contractLink.deployedName,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.tealAccent),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 29),
                        child: TextFormField(
                          controller: yourNameController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Your Name",
                              hintText: "What is your name ?",
                              icon: Icon(Icons.drive_file_rename_outline)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: ElevatedButton(
                          child: Text(
                            'Set Name',
                            style: TextStyle(fontSize: 30),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                          ),
                          onPressed: () {
                            contractLink.setName(yourNameController.text);
                            yourNameController.clear();
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
