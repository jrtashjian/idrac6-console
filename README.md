# iDRAC 6 Virtual Console Launcher

A bash script to make connecting to an iDRAC 6 console easier.

Includes [jre-7u80-linux-x64.tar.gz](https://download.oracle.com/otn/java/jdk/7u80-b15/jre-7u80-linux-x64.tar.gz) which you can also download yourself if you'd like.

## Usage

Clone the project to your machine:
```
git clone https://github.com/jrtashjian/idrac6-console.git
```

Make the script executable:
```
chmod +x connect.sh
```

Run the program:
```
connect.sh HOST[:PORT] [-u USER] [-p PASSWORD]

HOST[:PORT]    The host running iDRAC 6. Default port is '5900'

-u USER        iDRAC username. Default is 'root'
-p PASSWORD    iDRAC password. Default is 'calvin'
```