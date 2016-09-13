require 'chefspec'
require 'chefspec/berkshelf'

stub_command("test -d /opt/tomcat_petclinic/webapps/petclinic").and_return(true)
