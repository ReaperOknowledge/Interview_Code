#!/usr/bin/env python3
from flask import render_template, make_response

def desc():
    headers = {'Content-Type':'text/html'}
    return make_response(render_template("description.html"), 200, headers)
