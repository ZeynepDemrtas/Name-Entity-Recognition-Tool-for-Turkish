class Result{
  String data;
  bool success;



  Result(this.data,this.success);


  Result.fromJson(Map<String, dynamic> json)

        :data = json['data'],
        success = json['success'];




  Map<String,dynamic> toJson()=>{
    'data':data,
    'success':success,
  };
}