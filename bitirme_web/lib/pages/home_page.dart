import 'package:bitirme_web/cubit/home_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/data.dart';
import '../utils/utils.dart';
const List<String> model = <String>['BiLSTM', 'BiGRU', 'BERT'];

class HomePage extends StatefulWidget {
  HomeCubit view_model;
  String input;
  String output;
  int model;

  HomePage(this.view_model, this.input, this.output, this.model);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  String selectedValue = model.first;
  TextEditingController _inputController= TextEditingController();
  TextEditingController _outputController= TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedValue=model[widget.model];
    _inputController.text=widget.input;
    _outputController.text=widget.output;


  }
  @override
  Widget build(BuildContext context) {
    return Container(
            margin: EdgeInsets.all(10.0) ,
            padding: EdgeInsets.all(10.0) ,
          child: Column(
            children:<Widget> [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                  Container(
                      width: 400.0,
                      child: TextField(
                        style: TextStyle(
                            fontSize: 20.0, height: 2.0, color: Colors.black),
                        controller: _inputController,
                        showCursor: true,
                        textInputAction: TextInputAction.newline,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Metni Giriniz',
                        ),
                      )),

                  SizedBox(
                      width: 400.0,
                      child: TextField(
                        controller: _outputController,
                        readOnly: true,
                        style: TextStyle(
                            fontSize: 20.0, height: 2.0, color: Colors.black),
                        textInputAction: TextInputAction.newline,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ))
                ]),
              SizedBox(height :100),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                DropdownButton<String>(
                  value: selectedValue,
                  elevation: 16,
                  style: const TextStyle(color: Colors.black),
                  underline: Container(
                    height: 2,
                    color: Colors.blueGrey,
                  ),
                  onChanged: (String? newValue){
                    setState(() {
                      selectedValue = newValue!;
                    });
                  },
                  items: model.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    widget.view_model.fetchModelResult(Data(_inputController.text.trim(),model.indexOf(selectedValue)));

                  },
                  icon: Icon(Icons.change_circle),
                  label: Text("İsim Varlıklarını Bul"),
                ),
              ])
              ],
          ),

    );

  }


}
