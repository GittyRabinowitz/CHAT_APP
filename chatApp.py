from flask import Flask, render_template,redirect, request
import csv

USERS = "users.csv"

app = Flask(__name__)

def checkUserData(username, password):
    flag = False
    print(USERS)
    with open(USERS) as usersFile:
        users = csv.reader(usersFile,delimiter="\n")
        for user in users:
            name ,passwd = user[0].split(",")
            print(name + "-------------"+passwd)
            if name == username:
                flag = True
                if passwd == password:
                     return redirect("/login")

                else:
                    return "something went wrong!! check your password..."
        if not flag:
                        with open(USERS, 'a') as file:
                               file.write(username + "," + password + "\n")
                               file.close()
                               return redirect("/login")


@app.route("/register", methods=['GET', 'POST'])
def register():
    if request.method == 'GET':
        return render_template("register.html")
    elif request.method == 'POST':
        username = request.form['username']
        userpass = request.form['password']
        return checkUserData(username, userpass)



def checkUserDataLogIn(username, password):
    flag = False
    with open(USERS) as usersFile:
        users = csv.reader(usersFile,delimiter="\n")
        for user in users:
            name ,passwd = user[0].split(",")
            if name == username:
                flag = True
                if passwd == password:
                      return redirect("/lobby")
                else:
                    return "something went wrong!! check your password..."
        if not flag:
            return redirect("/register")
             
@app.route("/login", methods=['GET', 'POST'])
def login():
    if request.method == 'GET':
        return render_template("login.html")
    elif request.method == 'POST':
        username = request.form['username']
        userpass = request.form['password']
        return checkUserDataLogIn(username, userpass)


     
if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)
