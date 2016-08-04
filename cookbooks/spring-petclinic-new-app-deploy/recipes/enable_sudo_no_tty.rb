# Need to run this just for test kitchen and inspec to work 

execute 'comment requiretty in /etc/sudoers' do
    command 'sed -i "s/^Defaults    requiretty/#Defaults    requiretty/g" /etc/sudoers'
end