#
# Cookbook Name:: wsi_tomcat
# Recipe:: deploy_application
# Author: Ivan Suftin < isuftin@usgs.gov >
#
# Description: Deploys application(s) to a specified tomcat instance

tc_node = node['wsi_tomcat']
node.run_state['wsi_tomcat'] = {
  'instances' => {}
}
node['wsi_tomcat']['instances'].each do |instance, attributes|
  next unless attributes.key?('application')
  ruby_block "Check Tomcat Run State For #{instance}" do
    block do
      running = Helper::TomcatInstance.ready?(node, instance)
      node.run_state['wsi_tomcat']['instances'][instance] = { 'ready' => running }
    end
  end

  port = Helper::TomcatInstance.ports(node, instance)[0]
  attributes.application.each do |application, application_attributes|
    tomcat_application "Deploy Tomcat application #{application}" do
      name application
      instance_name instance
      version application_attributes.member?('version') ? application_attributes['version'] : ''
      location application_attributes['location']
      path application_attributes['path']
      type application_attributes['type']
      action :deploy
      only_if { node.run_state['wsi_tomcat']['instances'][instance]['ready'] }
    end
  end

  next unless tc_node['deploy']['remove_unlisted_applications']
  databag_name = tc_node['data_bag_config']['bag_name']
  credentials_attribute = tc_node['data_bag_config']['credentials_attribute']
  tomcat_script_pass = data_bag_item(databag_name, credentials_attribute)[instance]['tomcat_script_pass']

  begin
    deployed_apps = Helper::ManagerClient.get_deployed_applications(port, tomcat_script_pass)
    deployed_apps.each do |path, _state, _session_count, name|
      version = name.split('#').length > 1 ? name.split('#')[-1] : ''
      name = name.split('#').length > 1 ? name.split('#')[1] : name
      # Don't delete the manager app
      next unless name != 'manager'
      next if attributes.application.keys.include?(name)
      tomcat_application "Undeploy Tomcat application #{name}" do
        name name
        instance_name instance
        version version
        path path
        action :undeploy
        only_if { node.run_state['wsi_tomcat']['instances'][instance]['ready'] }
      end
    end
  rescue => e
    Chef::Log.error(e)
    return false
  end
end
