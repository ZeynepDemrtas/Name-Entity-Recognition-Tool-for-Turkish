class Utils{
  static String getOutput(String sentences,String labels){
    List<String> sentenceList= sentences.split(" ");
    List<String> labelList= labels.split(" ");
    String result="";
    for(int i=0;i<sentenceList.length;i+=1){
      result+="${sentenceList[i]} : ${labelList[i]} \n";
    }
    return result;
  }
}