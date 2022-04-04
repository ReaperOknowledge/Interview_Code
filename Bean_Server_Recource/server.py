from flask import Flask, render_template
from flask import jsonify
import connexion


# Create the application instance
app = connexion.App(__name__, specification_dir="./")

# Read the yaml file to configure the endpoints
app.add_api("master.yml")

# create a URL route in our application for "/"
@app.route("/")
def home():

    html_lines = html()
    return render_template('home.html', 
            page_title=html_lines[0][0],
            title=html_lines[1][0],
            page_desc=html_lines[2][0],
            title2=html_lines[3][0],
            p2_1=html_lines[4][0],
            p2_2=html_lines[5][0],
            title3=html_lines[6][0],
            p3_1=html_lines[7][0],
            title4=html_lines[8][0]
            )#jsonify(msg)



def html():
    """Used to get the lines from the text files to put into webpage"""
    one    = "src/main_page/page_title.txt"
    two    = "src/main_page/title.txt" 
    three  = "src/main_page/page_desc.txt"
    four   = "src/main_page/title2.txt"
    five   = "src/main_page/p2_1.txt"
    six    = "src/main_page/p2_2.txt"
    seven  = "src/main_page/title3.txt"
    eight  = "src/main_page/p3_1.txt"
    #nine   = "src/main_page/p3_2.txt"
    ten    = "src/main_page/title4.txt"
    #eleven ="src/main_page/p4_1.txt"
    #twelve ="src/main_page/p4_2.txt"
    #thirteen ="src/main_page/title_end.txt"
    #fourteen ="src/main_page/pend_1.txt"
    #fifteen  ="src/main_page/pend_2.txt"

    flist = [one, two, three, four, five, six, seven, eight, ten]

    rlist = []

    for s in flist:
        page_title = open(s, 'r')
        rlist.append(page_title.readlines())
        page_title.close()


    return rlist




if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080, debug=True)
