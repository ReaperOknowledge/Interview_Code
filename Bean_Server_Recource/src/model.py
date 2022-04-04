#!/usr/bin/env python3
from sklearn import datasets
from joblib import load
import numpy as np
import json

def model(id):
    my_model = load("resources/tree_model.pkl")
    if type(id) is np.array:
        print("numpy array")
        predict = my_model.predict(id)
    else:
        array = np.array(id)
        array = array.reshape(1,-1)

        predict = my_model.predict(array)
        pred_list = predict.tolist()
        json_str = json.dumps(pred_list)

    return json_str
