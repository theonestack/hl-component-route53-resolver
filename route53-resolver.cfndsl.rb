CloudFormation do
  
  tags = []
  tags << { Key: 'EnvironmentName', Value: Ref('EnvironmentName') }
  tags << { Key: 'EnvironmentType', Value: Ref('EnvironmentType') }
  
  EC2_SecurityGroup(:SecurityGroup) {
    GroupDescription FnSub("Control access to route53 resolver")
    VpcId Ref(:VPCId)
    Tags tags
  }
  
  Route53Resolver_ResolverEndpoint(:ResolverEndpoint) {
    Direction direction.upcase
    IpAddresses maximum_availability_zones.times.collect { |az| { SubnetId: FnSelect(az, Ref(:SubnetIds)) } }
    SecurityGroupIds([
      Ref(:SecurityGroup)
    ])
    Tags tags
  }
  
  rules.each do |rule|
    Route53Resolver_ResolverRule(:ResolverRule) {
      DomainName rule['domain']
      ResolverEndpointId Ref(:ResolverEndpoint)
      RuleType rule.key?('type') ? rule['type'].upcase : 'FORWARD'
      TargetIps rule['ips'].map { |ip| { Ip: ip, Port: '53' } }
      Tags tags
    }
    
    Route53Resolver_ResolverRuleAssociation(:ResolverRuleAssociation) {
      ResolverRuleId Ref(:ResolverRule)
      VPCId Ref(:VPCId)
    }
  end if (defined? rules) && (rules.any?)
  
end
