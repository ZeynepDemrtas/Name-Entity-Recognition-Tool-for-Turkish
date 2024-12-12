from nltk import tokenize
import re
import numpy as np
from transformers import BertTokenizerFast, AutoModelForTokenClassification
import json
import pymongo
from tensorflow.keras.utils import pad_sequences
from tensorflow.keras import models
from transformers import pipeline
from secret import url


# secilen model tipi --> 0:BiLSTM, 1:BiGRU, 2:BERT

class ModelProcess(object):
    def __init__(self):
        self.text = "" 
        self.check_bilstm = False
        self.check_bigru = False
        self.check_bert = False
        self.cluster = pymongo.MongoClient(url)
        db = self.cluster.NamedEntityRecognitionDB
        self.collection_dataset_bigru = db["dataset_words"]
        self.collection_dataset_bilstm = db["word_vectors"]
        self.collection_dataset_labels = db["labels"]
        self.dict_pad_item = {0: int(self.collection_dataset_bilstm.find_one({"words": "PADDING"})['index_id']), 
                              1: int(self.collection_dataset_bigru.find_one({"word": "PADDING"})['index_id']),
                              "label": int(self.collection_dataset_labels.find_one({"label": "PAD"})['index_id'])
                             }

    def set_text(self, input_text):
        self.text = input_text
    
    def set_model_type(self, choosen_model):
        self.choosen_model = choosen_model 
    
    def load_bilstm(self):
        self.model_BiLSTM = models.load_model('models/bilstm_model.h5')
        self.check_bilstm = True

    def load_bigru(self):
        self.model_BiGRU = models.load_model('models/bigru_model.h5') 
        self.check_bigru = True
    
    def load_bert(self):
        tokenizer = BertTokenizerFast.from_pretrained("dbmdz/bert-base-turkish-cased")
        config = json.load(open('models/bert_modelconfig.json'))
        json.dump(config, open('models/bert_modelconfig.json',"w"))
        model_fine_tuned = AutoModelForTokenClassification.from_pretrained('models/bert_model')
        self.nlp = pipeline("ner", model=model_fine_tuned, tokenizer=tokenizer)
        self.check_bert = True
        
    def delete_punctuations(self,sentence):
        #print(self.text)
        return [re.sub(r'[^\w\s]', '',sentence) ]

    def tokenize_sentences(self ):
        self.text = tokenize.sent_tokenize(self.text)
        for i in range(len(self.text)):
            self.text[i]=self.delete_punctuations(self.text[i])
        print(self.text)
        if self.choosen_model!=2:
            self.text = [tokenize.word_tokenize(" ".join(self.text[i])) for i in range(len(self.text))]
        print(self.text)
   

    
        #print(self.text)

    def predict_BiLSM_BiGRU(self):
        predicted_list = ""
        self.tokenize_sentences()
        for sentence in self.text:
            predicted_tags = []
            sentence = self.padding(sentence)
            #print(sentence)
            if self.choosen_model == 0:
                if self.check_bilstm == False:
                    self.load_bilstm()
                    self.check_bilstm = True
                predictions = self.model_BiLSTM.predict(sentence)
            elif self.choosen_model == 1:
                if self.check_bigru == False:
                    self.load_bigru()
                    self.check_bigru = True
                    
                predictions = self.model_BiGRU.predict(sentence)
            for idx in np.argmax(predictions, axis=-1)[0]:
                tag=self.collection_dataset_labels.find_one({"index_id": int(idx)})['label']
                if tag!='PAD':
                    predicted_tags.append(tag)
                else:
                    break
            print(predicted_tags)
            predicted_tags = " ".join(predicted_tags)
            print(predicted_tags)
            predicted_list+=predicted_tags+' '
        return predicted_list
        
    
    def predict_BERT(self):
        if self.check_bert == False:
            self.load_bert() 
        result=""
        self.tokenize_sentences()
        for sentence in self.text:
            example = sentence
            str_word_char_range = {}
            words_list = tokenize.word_tokenize(example[0])
            print(words_list)
            start=0
            for word in words_list:
                str_word_char_range[word] = [start,start+len(word)]
                start = start+len(word)+1
            ner_results = self.nlp(example)
            counter_word_list = 0
            counter_ner_result = 0
            VIT_list = {}
            for counter_ner_result in range(len(ner_results[0])):
                range_word = str_word_char_range[words_list[counter_word_list]]
                if (ner_results[0][counter_ner_result]["start"] in range(range_word[0], range_word[1]+1)) and (ner_results[0][counter_ner_result]["end"] in range(range_word[0], range_word[1]+1)):     
                    VIT_list[str(words_list[counter_word_list])] = str(ner_results[0][counter_ner_result]["entity"])
                    counter_word_list += 1
                if counter_word_list == len(words_list):
                    break
            for i in range(len(words_list)):
                try:
                    VIT_list[words_list[i]] 
                except KeyError:
                    VIT_list[words_list[i]] = "O"

            print(VIT_list)
            result+=" ".join(x for x in VIT_list.values())+" "
        return result
        
        

                
    def word_to_index(self, str_word):
               
        if self.choosen_model==0:
            try:
                return int(self.collection_dataset_bilstm.find_one({"words": str(str_word)})['index_id'])
            except TypeError:
                return int(self.collection_dataset_bilstm.find_one({"words": "UNFINDED"})['index_id'])
        elif self.choosen_model==1:
            try:
                return int(self.collection_dataset_bigru.find_one({"word": str(str_word)})['index_id'])
            except TypeError:
                return int(self.collection_dataset_bigru.find_one({"word": "şey"})['index_id'])
                                   
    
    def padding(self, sentence):
        return pad_sequences([[self.word_to_index(word) for word in sentence]], maxlen=43, padding="post", value = self.dict_pad_item[self.choosen_model] )

"""
obj_model = ModelProcess()
obj_model.set_text("Türkiye başkenti Ankaradır")
obj_model.set_model_type(int(0))
chosenModel = "0"
if chosenModel == "0" or chosenModel == "1":
    predict_result = obj_model.predict_BiLSM_BiGRU()
elif chosenModel == "2":
    predict_result = obj_model.predict_BERT()
    
    
    
print(predict_result)"""