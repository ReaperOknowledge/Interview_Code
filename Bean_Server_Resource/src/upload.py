from flask import render_template, Flask, make_response, request, redirect
import numpy as np
from joblib import load
import connexion
import os

app = connexion.App(__name__)

def upload():
    headers = {'Content-Type': 'text/html'}
    return make_response(render_template('calc_pg.html'), 200, headers)




def upload_file(arg1):
#    if(request.method == 'POST'):
#        f = request.files['file']
#        my_model = load("resources/tree_model.pkl")
#        predict = my_model.predict(f)

#        with open("output.txt", 'w') as out:
#            out.write(predict)
        return 'hi'



