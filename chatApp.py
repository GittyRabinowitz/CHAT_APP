from flask import Flask, render_template, request
import csv
# import win32api

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
                    return render_template("login.html")
                else:
                    return "something went wrong!! check your password..."
                    # win32api.MessageBox(0, 'check your password...', 'something went wrong!!')
        if not flag:
                        with open(USERS, 'a') as file:
                               file.write(username + "," + password + "\n")
                               file.close()
                               return render_template("login.html")


@app.route("/register", methods=['GET', 'POST'])
def homePage():
    if request.method == 'GET':
        return render_template("register.html")
    elif request.method == 'POST':
        username = request.form['username']
        userpass = request.form['password']
        return checkUserData(username, userpass)
        
@app.route("/login", methods=['GET','POST'])
def loginPage():
    return "login"

        
if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)
