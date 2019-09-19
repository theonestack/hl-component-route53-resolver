CfhighlanderTemplate do
  Name 'route53-resolver'
  Description "route53-resolver - #{component_version}"

  Parameters do
    ComponentParam 'EnvironmentName', 'dev', isGlobal: true
    ComponentParam 'EnvironmentType', 'development', allowedValues: ['development','production'], isGlobal: true
    ComponentParam 'VPCId', type: 'AWS::EC2::VPC::Id'
    ComponentParam 'SubnetIds', type: 'List<AWS::EC2::Subnet::Id>'
  end


end
