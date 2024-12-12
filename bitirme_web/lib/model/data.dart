class Data{
  String? sentences;
  int? chosenModel;




  Data(this.sentences,this.chosenModel);


  Data.fromJson(Map<String, dynamic> json)

      :sentences = json['sentences'],
        chosenModel = json['chosenModel'];


  Map<String,dynamic> toJson()=>{
    'sentences':sentences,
    'chosenModel':chosenModel,
  };
}