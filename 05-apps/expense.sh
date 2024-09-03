#!/bin/bash
# user data will get sudo access
dnf install ansible -y
cd /tmp
git clone https://github.com/guru-sulakhe/expense-ansible-roles.git
cd expense-ansible-roles
ansible-playbook main.yaml -e component=backend -e login_password=ExpenseApp1 # Running ansible backend code
ansible-playbook main.yaml -e component=frontend 

