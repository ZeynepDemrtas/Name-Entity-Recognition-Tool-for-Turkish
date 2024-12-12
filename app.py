from flask import Flask, request
#import model_yukleme as model
from ModelProcess import ModelProcess
    
app = Flask(__name__)
                                    

@app.route("/NER", methods=["POST"]) 
def index():
    try:
        predict_result=""
        sentences=request.args['sentences']
        chosenModel=request.args['chosenModel']
        obj_model = ModelProcess()
        obj_model.set_text(sentences)
        obj_model.set_model_type(int(chosenModel))

        if chosenModel == "0" or chosenModel == "1":
            predict_result=obj_model.predict_BiLSM_BiGRU()
        elif chosenModel == "2":
            predict_result=obj_model.predict_BERT()

       
        data={ "data":predict_result,
         "success":True
        }
        return data
    except Exception as e:
        print(e)
        data={ "data": 'Hata oluştu. Tekrar deneyiniz.',
         "success":False
        }
        return data
   

if __name__ == "__main__":
    app.run(debug=False, host='127.0.0.1', port=8000)
